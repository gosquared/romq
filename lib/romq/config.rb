module RoMQ
  module Config
    extend self

    LOG_EVERY = ENV.fetch('LOG_EVERY') { 2 }.to_i

    RABBITMQ_CLUSTER = ENV.fetch('RABBITMQ_CLUSTER') {
      "localhost"
    }.split(",")

    RABBITMQ_PORT         = ENV.fetch('RABBITMQ_PORT') { 5672 }
    RABBITMQ_TIMEOUT      = ENV.fetch('RABBITMQ_TIMEOUT') { 1 }.to_i
    RABBITMQ_USER         = ENV.fetch('RABBITMQ_USER') { "guest" }
    RABBITMQ_PASSWORD     = ENV.fetch('RABBITMQ_PASSWORD') { "guest" }
    RABBITMQ_VHOST        = ENV.fetch('RABBITMQ_VHOST') { "/" }
    RABBITMQ_RECONNECT_IN = ENV.fetch('RABBITMQ_RECONNECT_IN') { 5 }.to_i
    RABBITMQ_PREFECTH     = ENV.fetch('RABBITMQ_PREFECTH') { 100 }.to_i

    def rabbitmq_connection
      {
        :host     => RABBITMQ_CLUSTER.sample,
        :port     => RABBITMQ_PORT,
        :vhost    => RABBITMQ_VHOST,
        :user     => RABBITMQ_USER,
        :password => RABBITMQ_PASSWORD,
        :timeout  => RABBITMQ_TIMEOUT
      }
    end
  end
end
