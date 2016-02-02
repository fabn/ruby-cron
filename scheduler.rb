#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup(:default, :production)
require 'logger'

logger = Logger.new(STDOUT)

require 'rufus-scheduler'
scheduler = Rufus::Scheduler.singleton

logger.info 'Rufus scheduler started'

# Shutdown procedure, wait for running jobs then exit
shutdown = proc do
  # Using a thread otherwise lock won't work
  Thread.new { logger.debug 'Scheduler shutdown initiated' }  
  scheduler.shutdown(:wait)
end

# Intercept INT and TERM signal initiating a shutdown
trap :INT, &shutdown
trap :TERM, &shutdown

load 'jobs' if File.exists? 'jobs.rb'

scheduler.join
logger.debug 'All jobs have been terminated, exiting'
