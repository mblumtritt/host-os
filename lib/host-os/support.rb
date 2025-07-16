# frozen_string_literal: true

require_relative('../host-os') unless defined?(HostOS.id)

module HostOS
  # This module provides helpful support methods for the {HostOS} module.
  #
  # It adds attributes and methods depending on the detected operating system and
  # Ruby interpreter.
  #
  # @note You need to require `host-os/support` explicitly.
  module Support
    if defined?(File::NULL)
      # @attribute [r] dev_null
      # @return [String] name of or path to the null device
      # @note This attribute is only available on
      #   Windows, OS2 and Unix systems for older Ruby versions.
      def dev_null
        File::NULL
      end
    elsif HostOS.windows?
      def dev_null
        'NUL'
      end
    elsif HostOS.os2?
      def dev_null
        'nul'
      end
    elsif HostOS.unix?
      def dev_null
        '/dev/null'
      end
    end

    if HostOS.windows?
      # @attribute [r] open_command
      # @return [String] name of the open command
      # @note This attribute is only available on Windows, MacOS and Linux systems.
      def open_command
        'start'
      end
    elsif HostOS.macosx?
      def open_command
        'open'
      end
    elsif HostOS.linux?
      def open_command
        'xdg-open'
      end
    end

    if HostOS.windows?
      # @attribute [r] rss_bytes
      # @return [Integer] number of bytes used by the current process
      # @note This attribute is only available on Windows and Unix or when using
      #   JRuby
      def rss_bytes
        `tasklist /FI "PID eq #{Process.pid}" /FO CSV`.split(',"')[-1].tr(
          ',.',
          '__'
        ).to_i * 1024
      end
    elsif Interpreter.jruby?
      def rss_bytes
        require 'java' unless defined?(java)
        bean = java.lang.management.ManagementFactory.getMemoryMXBean
        bean.heap_memory_usage.used + bean.non_heap_memory_usage.used
      end
    elsif HostOS.unix?
      def rss_bytes
        `ps -o rss= -p #{Process.pid}`.to_i * 1024
      end
    end

    if HostOS.windows?
      # @param app_name [String] name of the application
      # @return [String] absolute name of the directory
      # Determines the name of the directory where application specific data
      # should be stored.
      # @note This method is only available on Windows and Posix-compatible
      #   systems.
      def app_config_path(app_name)
        File.expand_path(
          app_name,
          ENV['LOCALAPPDATA'] ||
            "#{ENV['USERPROFILE']}/Local Settings/Application Data"
        )
      end
    elsif HostOS.macosx?
      def app_config_path(app_name)
        File.expand_path(app_name, '~/Library/Application Support')
      end
    elsif HostOS.unix?
      def app_config_path(app_name)
        File.expand_path(app_name, ENV['XDG_CONFIG_HOME'] || '~/.config')
      end
    end

    # @attribute [r] suggested_thread_count
    # @return [Integer] suggested number of threads to use
    def suggested_thread_count
      @suggested_thread_count ||= find_suggested_thread_count
    end

    # @attribute [r] temp_dir
    # @return [String] name of the temporary directory
    def temp_dir
      @temp_dir ||= find_temp_dir
    end

    private

    def find_suggested_thread_count
      count = ENV['TC'].to_i
      return count if count > 0
      begin
        require('etc') unless defined?(Etc)
        Etc.nprocessors
      rescue LoadError
        4
      end
    end

    def find_temp_dir
      return Dir.tmpdir if defined?(Dir.tmpdir)
      ret = as_dir('TMPDIR') || as_dir('TMP') || as_dir('TEMP')
      return ret if ret
      ret =
        begin
          require('etc') unless defined?(Etc)
          Etc.systmpdir
        rescue LoadError
          "#{ENV['LOCALAPPDATA']}/Temp"
        end
      as_dir('system temp', ret) || as_dir('/tmp', '/tmp') || as_dir('.', '.')
    end

    def as_dir(name, dirname = nil)
      dirname ||= ENV[name]
      return if dirname.nil? || dirname.empty?
      dirname = File.expand_path(dirname)
      stat = File.stat(dirname)
      stat.directory? or warn("#{name} is not a valid directory - #{dirname}")
      stat.writable? or warn("#{name} is not writable - #{dirname}")
      (stat.world_writable? && !stat.sticky?) and
        warn("#{name} is world-writable - #{dirname}")
      dirname
    rescue SystemCallError
      nil
    end
  end

  extend Support
end
