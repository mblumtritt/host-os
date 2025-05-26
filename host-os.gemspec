# frozen_string_literal: true

require_relative 'lib/host-os/version'

Gem::Specification.new do |spec|
  spec.name = 'host-os'
  spec.version = HostOS::VERSION
  spec.summary =
    'This module offers details on the host OS, the present Ruby interpreter ' \
      'and environment.'
  spec.description = <<~DESCRIPTION
    This gem helps you write environment-specific code in a clean way.
    It provides a simple API to get information about the operating system,
    the current Ruby interpreter, and the configured environment.
  DESCRIPTION

  spec.author = 'Mike Blumtritt'
  spec.license = 'BSD-3-Clause'
  spec.homepage = 'https://github.com/mblumtritt/host-os'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/host-os'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 2.7'

  spec.files = (Dir['lib/**/*'] + Dir['examples/**/*']) << '.yardopts'
  spec.extra_rdoc_files = %w[README.md LICENSE]
end
