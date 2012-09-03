require_relative 'config'
require 'logger'

module RoMQ
  module Helpers
    DEBUG = ENV.fetch('DEBUG') { false }

    def flush_logs_periodically
      Proc.new do |seconds = Config::LOG_EVERY|
        EM.add_periodic_timer(seconds) do
          EM.defer { $stdout.flush }
        end
      end
    end

    def stop
      if @connections_to_stop <= 0
        EM.stop if EM.reactor_running?
        logger.info("Stopping #{self.class} service... done!")
        exit 0
      else
        logger.info("Waiting on #{@connections_to_stop} connection(s) to close...")
      end
    end

    # If you need to tear down any other connections, keep track of
    # their status via @connections_to_stop
    def stop_gracefully
      @connections_to_stop = 0

      Signal.trap "SIGTERM", stop
      Signal.trap "SIGINT", stop
      Signal.trap "SIGQUIT", stop
    end

    def logger
      return @logger if @logger

      @logger = Logger.new(STDOUT)
      @logger.level = DEBUG ? Logger::DEBUG : Logger::INFO
      @logger
    end
  end
end
