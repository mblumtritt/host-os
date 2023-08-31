# frozen_string_literal: true

require 'rspec/core'
require_relative '../lib/host-os/support'

$stdout.sync = $stderr.sync = $VERBOSE = true
RSpec.configure(&:disable_monkey_patching!)
Dir.glob("#{__dir__}/shared_examples/*.rb").each { |f| require(f) }
