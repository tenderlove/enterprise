require 'test/unit'
require 'rubygems'
require 'enterprise'

class TestEnterprise < Test::Unit::TestCase
  def setup
    @filename = File.join(File.dirname(__FILE__), 'assets', 'reference.rb')
    @codes = File.read(@filename)
  end

  def teardown
    Object.send(:remove_const, :HelloWorld) if defined? HelloWorld
  end

  def test_sexp_parse
    sexml = Enterprise::SEXML @codes, @filename
    assert sexml
    assert_equal 11, sexml.css('s').length
  end

  def test_sexml_can_be_converted_to_sexp
    sexml = Enterprise::SEXML @codes, @filename
    ruby_codes = sexml.to_sexp
    assert_instance_of Sexp, ruby_codes
  end

  def test_sexml_can_be_converted_to_ruby
    sexml = Enterprise::SEXML @codes, @filename
    ruby_codes = sexml.to_ruby
    m = Module.new
    m.module_eval ruby_codes
    assert m::HelloWorld.new.innernet
  end

  def test_require_some_xml
    require 'assets/hello_world'
    assert_equal 'the ibarernet is awesome', ::HelloWorld.new.innernet
  end
end
