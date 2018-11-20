## Vue Version

    2.5.17

## INSTALLATION

    gem install vue-compiler


## COMPILE A TEMPLATE

    require 'vue/compiler'


    Vue::Compiler.compile "<div><span>{{ msg }}</span></div>"

      => {:render=>"with(this){return _c('div',[_c('span',[_v(_s(msg))])])}", :staticRenderFns=>[], :errors=>"", :tips=>""}



## PARSE A SFC

    Vue::Compiler.parseComponent "<style>h1{color:red;}</style><template><div><span>{{ msg }}</span></div></template><script>var a=3;</script>"

    ==> {:script=>"var a=3;", :template=>"<div><span>{{ msg }}</span></div>", :styles=>["h1{color:red;}"]}

## CREATE RENDER FUNCTION

replace the template string with the render function in your Vue Object.

    render:function(){
          with(this){return _c('div',[_c('span',[_v(_s(msg))])])}
    }

## SPROCKETS

this will replace any template strings within an object in your regular javascript assets with a render function.

this will NOT compile .vue extension single file components !!

### example

in assets/js/app/index.coffee

    this.app = new Vue({
        el: '#app'

        template: """
           <div>
              <div class="header">
                  <h1 >{{msg}}</h1>
              </div>
           </div>
        """

        data:
           msg:"hello from vue"
    })


or of you prefer in javascript assets/js/app/index.js

    var  app = new Vue({
        el: '#app',
        template: "<div>\n   <div class=\"header\">\n       <h1 >{{msg}}</h1>\n   </div>\n</div>",
        data: { msg: "hello from vue"   }
    });


in your config.ru ..

    require 'sprockets'
    require 'vue/sprockets'

    VueSprocketsCompiler.set_root '/app'   # the relative path under which any js files will be processed

    .....
    .....
    .....
    map '/assets' do
        environment = Sprockets::Environment.new
        environment.append_path 'assets/js'
        environment.append_path 'assets/css'
        ....

        run environment
    end
    ....
    ....
