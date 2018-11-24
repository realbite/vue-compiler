require 'execjs'

module Vue

  class Compiler

    JS_ROOT = File.join(File.dirname(__FILE__),'../..','js')

    class << self

      def _reset
        @__ctx = nil
      end

      def set_options(opts={})
         @options = opts
      end

      def _options
        @options || {}
      end

      def _compiler
        version = _options[:version] || _options['version'] || '2.5'
        script = File.join(JS_ROOT,"vue-compile-template-#{version}.js")
        raise "invalid compile script #{script}" unless File.exist?(script)
        script
      end

      def _ctx
        @__ctx ||= ExecJS.compile( File.read(_compiler) + custom)
      end

      def custom
         <<-JS

            VXCompile = function(text){
              resp = VueTemplateCompiler.compile(text);
              return {
                render: resp.render,
                staticRenderFns: resp.staticRenderFns,
                errors:resp.errors,
                tips:resp.tips
              }
            }

            VXParse = function(text){
              resp = VueTemplateCompiler.parseComponent(text);
              return {
                script: resp.script ,
                template: resp.template ,
                styles:resp.styles
              }
            }
         JS
      end

      def compile(template,options={})
        obj = _ctx.call("VXCompile",template.to_s)
         {
           :render=>obj["render"].to_s,
           :staticRenderFns=>obj["staticRenderFns"].to_a,
           :errors=>obj["errors"].to_a,
           :tips=>obj["tips"].to_a
         }
      end

      def parseComponent(file, options={})
        obj = _ctx.call("VXParse",file.to_s)
        {:script=>obj["script"] && obj["script"]["content"],
         :template=>obj["template"] && obj["template"]["content"],
         :styles=>obj["styles"] && obj["styles"].map{ |s| s["content"] }
        }
      end


    end

  end

end
