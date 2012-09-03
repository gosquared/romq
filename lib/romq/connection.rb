require 'amqp'

require_relative 'config'
require_relative 'helpers'

module RoMQ
  class Connection
    include Helpers

    def initialize(&block)
      stop_gracefully

      EM.run do
        flush_logs_periodically.()

        connection = Config.rabbitmq_connection
        @amqp_connection = AMQP.connect(connection)

        @amqp_connection.on_error do |channel, connection_close|
          raise channel_close.reply_text
        end

        @amqp_connection.on_open do
          logger.info("[RoMQ] connected to #{connection[:host]}")
          @amqp_connection.on_tcp_connection_loss do
            reconnect.(block)
          end

          channel  = AMQP::Channel.new(@amqp_connection, auto_recovery: true)
          channel.on_error(&handle_channel_error)
          channel.prefetch(Config::RABBITMQ_PREFECTH)

          yield(channel)
        end
      end
    rescue AMQP::TCPConnectionFailed
      reconnect.(block)
    rescue AMQP::PossibleAuthenticationFailureError
      logger.info("[RoMQ] could not authenticate, check your credentials: #{@amqp_connection.settings}")
      stop.()
    end

    def reconnect
      Proc.new do |block|
        logger.info("[RoMQ] will try to re-connect in #{Config::RABBITMQ_RECONNECT_IN} seconds...")
        EM.stop if EM.reactor_running?
        sleep Config::RABBITMQ_RECONNECT_IN
        Connection.new(&block)
      end
    end

    def stop
      Proc.new do
        if @amqp_connection and @amqp_connection.connected?
          @amqp_connection.disconnect do
            logger.info("[RoMQ] closed connection to #{@amqp_connection.settings[:host]}")
          end
        end
        super
      end
    end

    def handle_channel_error
      Proc.new do |channel, channel_close|
        logger.error("[RoMQ] channel-level exception")
        logger.error("[RoMQ] AMQP class id : #{channel_close.class_id}")
        logger.error("[RoMQ] AMQP method id: #{channel_close.method_id}")
        logger.error("[RoMQ] Status code   : #{channel_close.reply_code}")
        logger.error("[RoMQ] Error message : #{channel_close.reply_text}")
      end
    end
  end
end
