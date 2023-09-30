# frozen_string_literal: true

#
# HostOS is a module that provides information about the operating system,
# the current Ruby interpreter ({interpreter}) and configured environment ({env}).
# It helps you write environment-specific code in a clean way.
#
module HostOS
  module Helper
    def is?(what)
      return true if id == what
      id == (defined?(what.to_sym) ? what.to_sym : what.to_s.to_sym)
    end

    protected

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
  # @note When no environment is configured 'prod
  #
  module Env
    extend Helper

    class << self
      # @attribute [r] production?
      # @return [true, false] whether the environment is configured as "production"
      # @note This will return true if the environment is not configured.

      # @attribute [r] test?
      # @return [true, false] whether the environment is configured as "test"

      # @attribute [r] development?
      # @return [true, false] whether the environment is configured as
      #   "development"

      # @attribute [r] id
      # @return [Symbol] environment identifier
      def id
        ID
      end

      # @!method is?(what)
      # @param what [Symbol, String] the identifier to check
      # @return [true, false] whether the environment is the given identifier

      # @comment YARD requires this line

      private

      def identify
        found =
          (
            ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['ENVIRONMENT'] ||
              ENV['ENV']
          )
        return :production if found.nil? || found.empty?
        found.downcase.tr(' -', '__').to_sym
      end
    end

    # @return [Symbol] environment identifier
    ID = identify
  end

  #
  # This module allows to identify the used Ruby interpreter.
  #
  # Besides here documented boolean attributes you can also check for any other
  # boolean attribute or interpreter name:
  #
  # @example Query for the Opal interpreter
  #   HostOS.interpreter.opal?
  # @example Query for TruffleRuby
  #   HostOS.interpreter.truffleruby?
  #
  module Interpreter
    extend Helper

    class << self
      # @attribute [r] id
      # @return [Symbol] interpreter identifier
      def id
        ID
      end

      # @attribute [r] mri?
      # @return [true, false] whether the interpreter is the Yukihiro Matsumoto's
      #   C-based (default) Ruby Interpreter
      def mri?
        ID == :mri
      end
      alias cruby? mri?
      alias default? mri?

      # @attribute [r] cardinal?
      # @return [true, false] whether the interpreter is the Parrot based Cardinal
      #   interpreter
      def cardinal?
        ID == :cardinal
      end
      alias parrot? cardinal?

      # @attribute [r] jruby?
      # @return [true, false] whether the interpreter is the Java based JRuby
      #  Interpreter
      def jruby?
        ID == :jruby
      end
      alias java? jruby?

      # @attribute [r] rbx?
      # @return [true, false] whether the interpreter is the Rubinius Interpreter
      def rbx?
        ID == :rbx
      end
      alias rubinius? rbx?

      # @attribute [r] ree?
      # @return [true, false] whether the interpreter is the Ruby Enterprise
      #   Edition
      def ree?
        ID == :ree
      end
      alias enterprise? ree?

      # @attribute [r] jit_enabled?
      # @return [true, false] whether the interpreter currently uses a JIT
      #   Compiler
      def jit_enabled?
        jit_type != :none
      end

      # @attribute [r] jit_type
      # @return [:mjit, :rjit, :yjit, :java, :none] type of currently used JIT
      #   Compiler
      def jit_type
        return :mjit if defined?(RubyVM::MJIT) && RubyVM::MJIT.enabled?
        return :yjit if defined?(RubyVM::YJIT) && RubyVM::YJIT.enabled?
        return :rjit if defined?(RubyVM::RJIT) && RubyVM::RJIT.enabled?
        jruby? ? :java : :none
      end

      # @!visibility private
      def to_s
        case ID
        when :mri
          'CRuby'
        when :ree
          'Enterprise Ruby'
        when :cardinal
          'Cardinal'
        when :jruby
          'JRuby'
        when :rby
          'Rubinius'
        when :truffleruby
          'TruffleRuby'
        else
          ID.to_s.upcase
        end
      end

      # @!method is?(what)
      # @param what [Symbol, String] the identifier to check
      # @return [true, false] whether the interpreter is the given identifier

      # @comment YARD requires this line

      private

      def identify
        if defined?(RUBY_PLATFORM) && (RUBY_PLATFORM == 'parrot')
          return :cardinal
        end
        return :mri unless defined?(RUBY_ENGINE)
        return RUBY_ENGINE.to_sym if RUBY_ENGINE != 'ruby'
        RUBY_DESCRIPTION.downcase.include?('enterprise') ? :ree : :mri
      end
    end

    # @return [Symbol] interpreter identifier
    ID = identify
  end

  extend Helper

  class << self
    # @attribute [r] id
    # @return [Symbol] OS identifier
    def id
      ID
    end

    # @attribute [r] type
    # @return [:unix,  :windows, :vms, :os2, :unknown] OS type
    def type
      TYPE
    end

    # @attribute [r] interpreter
    # @return [Interpreter] interpreter information
    def interpreter
      Interpreter
    end

    # @attribute [r] env
    # @return [Env] environment information
    def env
      Env
    end

    # @attribute [r] unix?
    # @return [true, false] whether the host OS is a Unix OS
    def unix?
      TYPE == :unix
    end

    # @attribute [r] windows?
    # @return [true, false] whether the host OS is a Windows OS
    def windows?
      TYPE == :windows
    end

    # @attribute [r] vms?
    # @return [true, false] whether the host OS is VMS
    def vms?
      TYPE == :vms
    end

    # @attribute [r] os2?
    # @return [true, false] whether the host OS is OS/2
    def os2?
      TYPE == :os2
    end

    # @attribute [r] macosx?
    # @return [true, false] whether the host OS is identified as MacOS
    def macosx?
      ID == :macosx
    end

    # @attribute [r] linux?
    # @return [true, false] whether the host OS is identified as Linux derivate
    def linux?
      ID == :linux
    end

    # @attribute [r] cygwin?
    # @return [true, false] whether the host OS is Windows/Cygwin
    def cygwin?
      ID == :cygwin
    end

    # @attribute [r] posix?
    # @return [true, false] whether the host OS is Posix compatible
    # This attribute is `true` when Posix compatible commands like `fork` are
    # available.
    def posix?
      Process.respond_to?(:fork)
    end

    # @param what [Symbol, String] the identifier to check
    # @return [true, false] whether the host OS is the given identifier or type
    def is?(what)
      return true if (ID == what) || (TYPE == what)
      what = defined?(what.to_sym) ? what.to_sym : what.to_s.to_sym
      (ID == what) || (TYPE == what)
    end

    # @!visibility private
    def to_s
      case ID
      when :linux
        'Linux'
      when :macosx
        'MacOSX'
      when :freebsd
        'FreeBSD'
      when :netbsd
        'NetBSD'
      when :openbsd
        'OpenBSD'
      when :dragonfly
        'Dragonly'
      when :sunis
        'SunOS'
      when :mswin
        'MSWin'
      when :mingw
        'MinGW'
      when :bccwin
        'BCCWin'
      when :wince
        'WinCE'
      when :windows, :cygwin
        ID.to_s.capitalize
      else
        ID.to_s.upcase
      end
    end

    private

    def identify
      require('rbconfig') unless defined?(RbConfig)
      id = RbConfig::CONFIG['host_os'].downcase
      id, type, normalized =
        [
          ['linux', :unix],
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

  ID, TYPE = identify
end
