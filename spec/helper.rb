# frozen_string_literal: true

require_relative '../lib/host-os/support'

$stdout.sync = $stderr.sync = $VERBOSE = true
RSpec.configure(&:disable_monkey_patching!)
Dir.glob("#{__dir__}/shared_examples/*.rb").each { require(_1) }
