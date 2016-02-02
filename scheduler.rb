#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup(:default, :production)
require 'logger'
require 'optparse'

$logger = Logger.new(STDOUT)
$logger.level = Logger::INFO

# Parse commandline options
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely, i.e. log level DEBUG") do |v|
    $logger.level = Logger::DEBUG if v
  end

  # Optional logger level
  opts.on('-l', '--level [LEVEL]', %i(debug info warn error fatal), "Manually select logger level, one of #{%i(debug info warn error fatal).join(' ')}") do |level|
    if level
      $logger.level = Logger::const_get(level.to_s.upcase)
    else
      $logger.warn "Invalid log level given, defaulting to INFO"
    end
  end
  
  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

require 'rufus-scheduler'
scheduler = Rufus::Scheduler.singleton

$logger.info 'Rufus scheduler started'

# Shutdown procedure, wait for running jobs then exit
shutdown = proc do
  # Using a thread otherwise lock won't work
  Thread.new { $logger.debug 'Scheduler shutdown initiated' }  
  scheduler.shutdown(:wait)
end

# Intercept INT and TERM signal initiating a shutdown
trap :INT, &shutdown
trap :TERM, &shutdown

scheduler.every '3s' do
  # Report aliveness, - 1 because of self
  $logger.debug "Scheduler is alive and there are #{scheduler.jobs.size - 1} job(s) scheduled"
end

load 'jobs.rb' if File.exists? 'jobs.rb'

scheduler.join
$logger.info 'All jobs have been terminated, exiting'
