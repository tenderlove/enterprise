module Enterprise
  module FileLoader
    def self.load filename, options = nil, &block
      return true if $".include?(filename) # bug in polyglot

      $stderr.puts filename if ENV['ENTERPRISE_DEBUG']
      sexml = Nokogiri::XML(File.read(filename)) { |cmd| cmd.noblanks }
      $" << filename
      Kernel.eval sexml.to_ruby, TOPLEVEL_BINDING
    end
  end
end

Polyglot.register 'xml', Enterprise::FileLoader
