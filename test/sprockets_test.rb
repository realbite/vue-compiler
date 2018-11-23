require 'test/unit'
require_relative '../lib/vue/compiler'
require_relative '../lib/vue/sprockets'

class SprocketsTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end
  V = ::VueSprocketsCompiler

  def test_path
    V.set_root nil
    assert_true V.is_in_path('/aaa')
    assert_true V.is_in_path('/bbb')

    V.set_root 'foo'
    assert_true  V.is_in_path('/foo')
    assert_true  V.is_in_path('/foo/aaa')
    assert_false V.is_in_path('/aaa')
    assert_false V.is_in_path('/')

    V.set_root ['foo','bar']
    assert_true  V.is_in_path('/foo')
    assert_true  V.is_in_path('/foo/aaa')

    assert_true  V.is_in_path('/bar')
    assert_true  V.is_in_path('/bar/aaa')

    assert_false V.is_in_path('/aaa')
    assert_false V.is_in_path('/')


  end


end
