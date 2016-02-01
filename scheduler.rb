#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup(:default, :production)
require 'logger'

logger = Logger.new(STDOUT)

require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

scheduler.in '3s' do
  logger.info 'Hello... Rufus, one shot'
  sleep 8
  logger.info 'one shot completed'
end

scheduler.every '3s' do
  logger.debug 'Periodic schedule'
  sleep 3
  logger.debug 'Periodic ended'
end

scheduler.in '10s' do
  logger.info 'Killing scheduler'
  logger.debug 'Requesting termination for scheduler'
  scheduler.stop(terminate: false)
end

scheduler.join
logger.debug 'All jobs have been terminated, exiting'