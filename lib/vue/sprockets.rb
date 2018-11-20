# transform vue objects by compiling the templates into render functions.

require 'vue/compiler'

class VueSprocketsCompiler

  # compile templates under this path.
  def self.set_root(path=nil)
    path = '/' + path unless path[0,1] == '/'
    @root = path
  end

  def self.toFunction(code)
     return 'function () {' + code + '}'
  end

  def self.call(input)
    source   = input[:data]
    load_path = input[:load_path]
    filename = input[:filename]

    path = filename[load_path.length..-1]

    if !@root || (path[0..@root.length-1] == @root)
      js = source.gsub( /(?<spaces>\s+)template\s*:\s*(?<quote>["`'])(?<code>.*?[^\\])\k<quote>/m ) do |match|
        spaces = "#{$1}"
        src = $3.gsub("\\n","\n")
        src = src.gsub("\\\"","\"")
        src = src.gsub("\\\'","\'")
        src = src.gsub("\\t","\t")

        result = Vue::Compiler.compile(src)

        out = spaces + "render :" + toFunction(result[:render]) + ",\n"
        out += spaces + "staticRenderFns :[" + (result[:staticRenderFns] || []).map{|f| toFunction(f)}.join(',') + "]"
        puts "ERROR: vue/sprockets #{filename} ==>\n#{result[:errors]}" if result[:errors].to_s != ""
        puts "TIP: vue/sprockets #{filename} ==>\n#{result[:tips]}"   if result[:tips].to_s != ""
        out
      end
      {:data=>js}
    else
      nil
    end
  end

end

Sprockets.register_postprocessor('application/javascript', VueSprocketsCompiler)
