# transform vue objects by compiling the templates into render functions.

require 'sprockets'
require 'vue/compiler'

class VueSprocketsCompiler

  # compile templates under this path.
  def self.set_root(path=nil)
    path = [path].flatten
    @path = path.map{|p| (p||'')[0,1] == '/' ? p : '/' + (p||'') }
  end

  def self.is_in_path(path)
    @path.any?{|p| path[0..p.length-1] == p}
  end


  def self.toFunction(code)
     return 'function () {' + code + '}'
  end

  def self.call(input)
    source   = input[:data]
    load_path = input[:load_path]
    filename = input[:filename]

    path = filename[load_path.length..-1]

    if is_in_path(path)
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
