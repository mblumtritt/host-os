# frozen_string_literal: true

#
# HostOS is a module that provides information about the operating system,
# the current Ruby interpreter ({interpreter}) and configured environment ({env}).
# It helps you write environment-specific code in a clean way.
#
module HostOS
  class << self
    # @return [:unix,  :windows, :vms, :os2, :unknown] OS type
    attr_reader :type

    # @!attribute [r] interpreter
    # @return [Interpreter] interpreter information
    def interpreter
      Interpreter
    end

    # @!attribute [r] env
    # @return [Env] environment information
    def env
      Env
    end

    # @!attribute [r] unix?
    # @return [true, false] whether the host OS is a Unix OS
    def unix?
      @type == :unix
    end

    # @!attribute [r] windows?
    # @return [true, false] whether the host OS is a Windows OS
    def windows?
      @type == :windows
    end

    # @!attribute [r] vms?
    # @return [true, false] whether the host OS is VMS
    def vms?
      @type == :vms
    end

    # @!attribute [r] os2?
    # @return [true, false] whether the host OS is OS/2
    def os2?
      @type == :os2
    end

    # @!attribute [r] macosx?
    # @return [true, false] whether the host OS is identified as MacOS
    def macosx?
      @id == :macosx
    end

    # @!attribute [r] linux?
    # @return [true, false] whether the host OS is identified as Linux derivate
    def linux?
      @id == :linux
    end

    # @!attribute [r] cygwin?
    # @return [true, false] whether the host OS is Windows/Cygwin
    def cygwin?
      @id == :cygwin
    end

    # @!attribute [r] posix?
    # @return [true, false] whether the host OS is Posix compatible
    # This attribute is `true` when Posix compatible commands like `fork` are
    # available.
    def posix?
      Process.respond_to?(:fork)
    end

    # @param what [Symbol, String] the identifier to check
    # @return [true, false] whether the host OS is the given identifier or type
    def is?(what)
      return (@id == what) || (@type == what) if what.is_a?(Symbol)
      if defined?(what.to_sym)
        what = what.to_sym
        return (@id == what) || (@type == what)
      end
      if defined?(what.to_s)
        what = what.to_s.to_sym
        return (@id == what) || (@type == what)
      end
      false
    end

    # @!attribute [r] id
    # @return [Symbol] OS identifier

    # @!visibility private
    def to_s
      @to_s ||=
        {
          bccwin: 'BCCWin',
          cygwin: 'Cygwin',
          dragonfly: 'Dragonly',
          freebsd: 'FreeBSD',
          linux: 'Linux',
          macosx: 'MacOSX',
          mingw: 'MinGW',
          mswin: 'MSWin',
          netbsd: 'NetBSD',
          openbsd: 'OpenBSD',
          sunos: 'SunOS',
          wince: 'WinCE',
          windows: 'Windows'
        }.compare_by_identity[
          @id
        ] || @id.to_s.upcase
    end

    private

    def identify
      require('rbconfig') unless defined?(RbConfig)
      id = RbConfig::CONFIG['host_os'].downcase
      id, type, normalized =
        [
          ['linux', :unix, :linux],
          ['arch', :unix, :linux],
          ['darwin', :unix, :macosx],
          ['mac', :unix, :macosx],
          ['freebsd', :unix],
          ['netbsd', :unix],
          ['openbsd', :unix],
          ['dragonfly', :unix],
          ['aix', :unix],
          ['irix', :unix],
          ['hpux', :unix],
          ['solaris', :unix, :sunos],
          ['sunos', :unix, :sunos],
          ['windows', :windows],
          ['cygwin', :windows],
          ['mswin', :windows],
          ['mingw', :windows],
          ['bccwin', :windows],
          ['djgpp', :windows],
          ['wince', :windows],
          ['emc', :windows],
          ['vms', :vms],
          ['os2', :os2]
        ].find { |info| id.include?(info[0]) }
      id ? [normalized || id.to_sym, type] : %i[unknown unknown]
    end
  end

  module Helper
    attr_reader :id

    def is?(what)
      return id == what if what.is_a?(Symbol)
      return id == what.to_sym if defined?(what.to_sym)
      return id == what.to_s.to_sym if defined?(what.to_s)
      false
    end

    private

    def respond_to_missing?(name, _include_all = false)
      (name[-1] == '?') || super
    end

    def method_missing(name, *args)
      return super if name[-1] != '?'
      return is?(name[0..-2]) if args.empty?
      raise(
        ArgumentError,
        "wrong number of arguments (given #{args.size}, expected 0)"
      )
    end
  end
  private_constant :Helper

  #
  # This module allows to identify the current environment by checking the `ENV`
  # for the following variables in order:
  #
  # * RAILS_ENV
  # * RACK_ENV
  # * ENVIRONMENT
  # * ENV
  #
  # You can check for any boolean attribute:
  #
  # @example Query if the environment is configured as "staging"
  #   HostOS.env.staging?
  # @example Test if the environment is configured as "production"
  #   HostOS.env.is? :production
  #
  # @note When no environment is configured `production` is assumed.
  #
  module Env
    extend Helper

    class << self
      # @!attribute [r] production?
      # @return [true, false] whether the environment is configured as "production"
      # @note This will return true if the environment is not configured.

      # @!attribute [r] test?
      # @return [true, false] whether the environment is configured as "test"

      # @!attribute [r] development?
      # @return [true, false] whether the environment is configured as
      #   "development"

      # @!attribute [r] id
      # @return [Symbol] environment identifier

      # @!method is?(what)
      # @param what [Symbol, String] the identifier to check
      # @return [true, false] whether the environment is the given identifier

      # @comment YARD requires this line

      private

      def identify
        found =
          ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['ENVIRONMENT'] ||
            ENV['ENV']
        return :production if found.nil? || found.empty?
        found.downcase.gsub(/\W/, '_').to_sym
      end
    end

    @id = identify
  end

  autoload :Interpreter, "#{__dir__}/host-os/interpreter.rb"

  extend Helper

  @id, @type = identify
end
