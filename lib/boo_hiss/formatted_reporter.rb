module BooHiss
  class FormattedReporter < SilentReporter
    def record_initial_test_run(*args)
      super
      print "."
      $stdout.flush
    end

    def record_initial_test_result(*args)
      super
      print "$"
      $stdout.flush
    end

    def mutation_test_run(*args)
      super
      print "."
      $stdout.flush
    end

    def mutation_test_result(*args)
      super
      print "$"
      $stdout.flush
    end

    def completed
      require 'ruby-debug'
      debugger
      1
    end
  end
end
