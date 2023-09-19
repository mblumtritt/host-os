# frozen_string_literal: true

#
# This example prints an overview of detected information about your current
# OS, environment and Ruby interpreter.
#
# Just run
# $ ruby examples/current.rb
#
# or play around with eg.:
# $ ruby --jit examples/current.rb
# $ ENV=test ruby examples/current.rb
#

require 'host-os/support'

puts <<~INFORMATION
  # OS Information
    - id: #{HostOS.id}
    - type: #{HostOS.type}
    - POSIX compatible: #{HostOS.posix?}
    - suggested_thread_count: #{HostOS.suggested_thread_count}
    - temp_dir: #{HostOS.temp_dir}
    - dev_null: #{defined?(HostOS.dev_null) ? HostOS.dev_null : '*unsupported*'}
    - open_command: #{
       defined?(HostOS.open_command) ? HostOS.open_command : '*unsupported*'
     }
    - rss_bytes: #{
       defined?(HostOS.rss_bytes) ? HostOS.rss_bytes : '*unsupported*'
     }
    - app_config_path: #{
       if defined?(HostOS.app_config_path)
         HostOS.app_config_path('')
       else
         '*unsupported*'
       end
     }

  # Environment
    - id: #{HostOS.env.id}

  # Ruby Interpreter
    - id: #{HostOS.interpreter.id}
    - JIT: #{HostOS.interpreter.jit_type}
INFORMATION
