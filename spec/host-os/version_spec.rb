# frozen_string_literal: true

require_relative '../helper'
require_relative '../../lib/host-os/version'

RSpec.describe HostOS::VERSION do
  it { is_expected.to match(/\A[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\z/) }
  it { is_expected.to be_frozen }
end
