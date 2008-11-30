require "spec"

module BooHiss
  class CLI
    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv, @libraries = argv, []
    end
    attr_reader :argv

    def run
      option_parser.parse!(@argv)

      @libraries.each do |l|
        require l
      end
      klass, method_name = klass_and_method_for(@argv.shift)

      mob = Mob.new(klass, method_name, tester, reporter)
      mob.enrage
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] klass [method] ..."

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on("-v", "--version", "Display the version information") do
          puts BooHiss::VERSION
          exit
        end

        opts.on("-r library", "--require library", "Require the library to bootstrap your code") do |library|
          @libraries ||= []
          @libraries << library
        end

        opts.on("-x", "--exit", "Exit on a mutation which doesn't cause a failure") do
          puts "I am going to exit on the first mutation which doesn't cause a failure"
          puts
          @exit_on_bad_mutation = true
        end

        opts.on("-R name", "--reporter name", "Choose the reporting to use") do |name|
          @reporter_name = name
        end

        opts.separator ""
      end
    end

    def exit_on_bad_mutation?
      @exit_on_bad_mutation
    end

    def tester
      @tester ||= Tester.new(self)
    end

    REPORTERS = {
      "default" => DefaultReporter,
      "formatted" => FormattedReporter,
    }

    def reporter
      @reporter ||= begin
        REPORTERS[reporter_name].new(self)
      end
    end

    def reporter_name
      @reporter_name ||= "default"
    end

    def klass_and_method_for(klass_and_method)
      case klass_and_method
      when /^(.+)#(.+)$/
        [klass_for($1), $2]
      when /^(.+)\.(.+)$/
        [class << klass_for($1); self; end, $2]
      when /^(.+)$/
        [klass_for($1), nil]
      else
        raise Error, "Unknown class/method format, #{klass_and_method}"
      end
    end

    def klass_for(name)
      list = name.split("::")
      list.shift if list.first == ""
      obj = Object
      list.each do |x|
        # This is required because const_get tries to look for constants in the
        # ancestor chain, but we only want constants that are HERE
        obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
      end
      obj
    end

    class Tester
      def initialize(cli)
        @cli = cli
      end

      def passes?
        err, out = "", ""
        options = Spec::Runner::OptionParser.parse(@cli.argv.dup, StringIO.new(err), StringIO.new(out))
        result = Spec::Runner::CommandLine.run(options)
        if options.example_groups.empty?
          puts "No tests!?"
          puts out
          puts err
          exit
        end
        [result, err, out]
      end
    end
  end
end
