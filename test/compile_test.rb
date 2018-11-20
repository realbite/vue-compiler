require 'test/unit'
require_relative '../lib/vue/compiler'

class CompilerTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_compile_string
    Vue::Compiler._reset
    hash = Vue::Compiler.compile "<div><span>{{ msg }}</span></div>"
    assert_equal("with(this){return _c('div',[_c('span',[_v(_s(msg))])])}", hash[:render])
    assert_equal([], hash[:staticRenderFns])
    assert_equal("", hash[:errors])
    assert_equal("", hash[:tips])

    hash = Vue::Compiler.compile "<div><span>{{{} msg }}</span></div>"
    assert_not_equal("", hash[:errors])

  end

  def test_parse_sfc
    Vue::Compiler._reset
    hash = Vue::Compiler.parseComponent %Q[<style>h1{color:red;}</style><template><div><span>{{ msg }}</span></div></template><script>var a=3;</script>]
    assert_equal( hash[:styles], ["h1{color:red;}"])
    assert_equal( hash[:template], "<div><span>{{ msg }}</span></div>")
    assert_equal( hash[:script], "var a=3;")
  end
end
