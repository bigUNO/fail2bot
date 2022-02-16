#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'matrix_sdk'
require 'tomlrb'

options = {}
OptionParser.new do |parser|
  parser.on('--ban-time DURATION', 'The duration of the ban [REQUIRED]') do |value|
    options[:ban_time] = value
  end
  parser.on('--dry-run', 'Validate inputs only') do |value|
    options[:dry_run] = value
  end
  parser.on('--ip IP', 'The IP address that has been banned [REQUIRED]') do |value|
    options[:ip] = value
  end
  parser.on('--name ???', 'Placeholder until I find out what this field is [REQUIRED]') do |value|
    options[:name] = value
  end
  parser.on('-v', '--verbose', 'More logging for debuggin\'') do
    options[:verbose] = true
  end
end.parse!

# Load config from ./fail2bot.toml
def load_configuration(options)
  c = Tomlrb.load_file('./fail2bot.toml', symbolize_keys: true)
  # TODO: validate that required parameters are present
  puts c if options[:verbose]
  c
end

# TODO: validation is fucked
def validate_cl_input(options)
  case options
  when options.key?('ban_time') == true
    puts '--ban-time is required'
  when options[:name] == ''
    puts '--name is required'
  when options[:ip] == ''
    puts '--ip is required'
  else
    puts options if options[:verbose]
  end
end

def send_message_to_matrix(options, config)
  client = MatrixSdk::Client.new config.dig(:matrix, :server)
  client.api.access_token = config.dig(:matrix, :access_token)
  puts 'Syncing with matrix server' if options[:verbose]
  client.sync

  hq = client.find_room config.dig(:matrix, :room)
  hq.send_text "\u{2696} #{options[:ip]} has been found guilty of crimes against #{options[:name]}." \
               "\u{1f46e} Serving #{options[:ban_time]} in jail."
end

validate_cl_input(options)
config = load_configuration(options)
send_message_to_matrix(options, config) unless options[:dry_run]
