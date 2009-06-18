class Sexp
  include Nokogiri::XML

  def to_xml doc = Document.new, parent = doc.root = Node.new('s', doc)
    each do |node|
      case node
      when Sexp
        new_parent = Node.new('s', parent.document)
        parent.add_child new_parent
        node.to_xml doc, new_parent
      else
        name = node.to_s
        if node.to_s.empty? || node.to_s !~ /^[A-Za-z]+$/
          name = 'special'
        end

        n = Node.new(name, parent.document)
        n['type'] = node.class.name

        if Regexp === node
          n['value'] = [Marshal.dump(node)].pack('m')
        else
          n['value'] = node.to_s
        end

        parent << n
      end
    end
    doc
  end
end
