# frozen_string_literal: true

require_relative 'host-os/helper'

#
# HostOS is a module that provides information about the operating system,
# the current Ruby interpreter ({interpreter}) and configured environment ({env}).
# It helps you write environment-specific code in a clean way.
#
module HostOS
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
      defined?(Process.fork)
    end

    # @param what [Symbol, String] the identifier to check
    # @return [true, false] whether the host OS is the given identifier or type
    def is?(what)
      return true if (ID == what) || (TYPE == what)
      what = defined?(what.to_sym) ? what.to_sym : what.to_s.to_sym
      (ID == what) || (TYPE == what)
    end

    private

    def identify
      ruby_platform = RUBY_PLATFORM.downcase
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
        ].find { |pi| ruby_platform.include?(pi[0]) }
      id ? [normalized || id.to_sym, type] : %i[unknown unknown]
    end
  end

  ID, TYPE = identify

  autoload :Interpreter, "#{__dir__}/host-os/interpreter"
  autoload :Env, "#{__dir__}/host-os/env"
  autoload :VERSION, "#{__dir__}/host-os/version"
end
