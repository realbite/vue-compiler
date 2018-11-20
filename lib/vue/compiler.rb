require 'v8'



module Vue

  class Compiler

    JS_ROOT = File.join(File.dirname(__FILE__),'../..','js')

    COMPILER = File.join(JS_ROOT,'vue-compile-template-2.4.js')

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
        @__ctx ||= begin
          ctx = V8::Context.new
          ctx.load  _compiler
          ctx
        end
      end

      def compile(template,options={})
        obj = _ctx[:VueTemplateCompiler][:compile].call(template.to_s)
         {
           :render=>obj[:render].to_s,
           :staticRenderFns=>obj[:staticRenderFns].to_a,
           :errors=>obj[:errors].to_s,
           :tips=>obj[:tips].to_s
         }
      end

      def parseComponent(file, options={})
        obj = _ctx[:VueTemplateCompiler][:parseComponent].call(file.to_s)
        {:script=>obj[:script] && obj[:script][:content],
         :template=>obj[:template] && obj[:template][:content],
         :styles=>obj[:styles] && obj[:styles].map{ |s| s[:content] }
        }
      end


    end

  end

end
