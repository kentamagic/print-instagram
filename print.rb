#!/usr/bin/env ruby

require 'rubygems'
require 'instagram'
require 'logger'
require 'optparse'
require 'pp' # pretty printing for debugging

class PrintInstagram

  # Get client ID and client secret from
  # http://instagram.com/developer
  # and set as environment variables in shell
  Instagram.configure do |config|
    config.client_id = ENV['INSTAGRAM_CLIENT']
    config.client_secret = ENV['INSTAGRAM_SECRET']
  end

  # Set up log of instagrams printed
  file = File.open('print.log', 'a')
  logger = Logger.new(file)

  # Parse command line arguments and
  # specify correct usage
  #   @param args [Hash] A set of command line options
  def self.parse(args)
    options = {}
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: print.rb [options]"
      opts.separator ""
      opts.separator "Specific options:"

      # Mandatory
      # Search tag for Instagram API
      opts.on("-t", "--tag TAG",
        "Require the search TAG before executing") do |tag|
        options[:tag] = tag
      end

      # Optional
      # @example Cron job will specify minID to retrieve only
      # the latest instagrams
      opts.on("-m", "--min ID",
        "Print only instagrams before the min ID") do |min_id|
        options[:min_id] = min_id
      end
    end

    # Ensure that mandatory switch (-t) was specified
    begin
      opt_parser.parse!(args)
      if options[:tag].nil?
        puts "Missing option: tag"
        puts opt_parser
        exit
      end

    # Rescue friendly output when parsing fails 
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s # Print errors
      puts opt_parser
      exit
    end

    #Otherwise options successfully parsed
  end

  def self.print()
    self.parse(ARGV)
  end
end