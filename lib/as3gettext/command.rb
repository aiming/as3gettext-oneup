require 'optparse'
require 'gettext'
require 'gettext/rgettext'
require 'as3gettext/as3_parser'
require 'as3gettext/generate_xml'

module As3gettext
  class Command
    include GetText
    def initialize
      @config = {
        :mode => :gettext
      }
    end
    attr_accessor :config

    def run(argv)
      parse argv
      send @config[:mode]
    end

    def gettext
      RGetText.add_parser As3gettext::As3Parser
      GetText.rgettext config[:targets], config[:output] || STDOUT
    end

    def xml
      xml_string = GenerateXml.new.generate config[:targets]
      if config[:output]
        File.open(config[:output], 'w') do |f|
          f.puts xml_string
        end
      else 
        puts xml_string
      end
    end

    def parse(argv)
      op = OptionParser.new
      op.banner = <<-EOF.gsub(/^\s+/, '')
        Usage: 
        $ as3gettext src/HelloWrold.as src/**/*.mxml -o template.pot
        $ as3gettext i18n/**.po -x -o langs.xml 
      EOF
      op.on('-h', '--help', 'show this message') { puts op; Kernel::exit 1 }
      op.on('-x', 'export XML') { config[:mode] = :xml }
      op.on('-o=VAL', 'output file') {|v| config[:output] = v }
      op.parse! argv
      if argv.length == 0
        puts op
        exit 1
      end
      config[:targets] = argv
    end
  end
end
