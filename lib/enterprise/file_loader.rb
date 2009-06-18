module Enterprise
  module FileLoader
    def self.load filename, options = nil, &block
      sexml = Nokogiri::XML(File.read(filename)) { |cmd| cmd.noblanks }
      Kernel.eval sexml.to_ruby, TOPLEVEL_BINDING
    end
  end
end

Polyglot.register 'xml', Enterprise::FileLoader
