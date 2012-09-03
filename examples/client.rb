#!/usr/bin/env ruby

require 'ap'
require_relative '../lib/romq'

RoMQ::Connection.new do |channel|
  exchange = channel.direct("romq")

  EM.add_periodic_timer(2) do
    exchange.publish("Time is: #{Time.now}")
  end

  channel.queue("client.rb", exclusive: true).
    bind(exchange).
    subscribe do |metadata, payload|
      ap payload
    end
end
