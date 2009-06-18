require 'nokogiri'
require 'ruby2ruby'

module Enterprise
  def self.SEXML codes, filename = nil
    sexp = RubyParser.new.parse codes, filename
    sexp.to_xml
  end

  class XMLToSexp
    def visit node
      if ! node['value']
        return s(*node.children.map { |child| child.accept self })
      else
        case node['type']
        when 'Symbol'
          node['value'].to_sym
        when 'Regexp'
          Marshal.load node['value'].unpack('m').first
        when 'NilClass'
          nil
        when 'Fixnum', 'Bignum'
          Integer(node['value'])
        when 'Float'
          Float(node['value'])
        else
          node['value']
        end
      end
    end
  end
end

class Nokogiri::XML::Node
  def to_sexp
    accept Enterprise::XMLToSexp.new
  end

  def to_ruby
    Ruby2Ruby.new.process(to_sexp)
  end
end

class Nokogiri::XML::Document
  def to_ruby
    Ruby2Ruby.new.process(root.to_sexp)
  end
end
