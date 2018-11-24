Gem::Specification.new do |s|
  s.name = 'vue-compiler'
  s.description = %Q[vue-template-compiler functionality in a gem - compile and parse your vue.js templates]
  s.summary = %Q[vue-template-compiler functionality in a gem]
  s.version = '0.1.5'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Clive Andrews']
  s.license = 'MIT'
  s.email = ['gems@realitybites.eu']
  s.homepage = 'https://github.com/realbite/vue-compiler'


  s.add_dependency('execjs')

  s.files = ['lib/vue/compiler.rb','lib/vue/sprockets.rb' ]
  s.files << 'js/vue-compile-template-2.4.js'
  s.files << 'js/vue-compile-template-2.5.js'
  s.files << 'LICENSE'
  s.files << 'README.md'

  s.extra_rdoc_files = ['README.md','LICENSE']
  s.require_paths = ['lib']
end
