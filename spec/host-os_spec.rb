# frozen_string_literal: true

require_relative 'helper'

RSpec.describe HostOS do
  case HostOS.id
  when :linux
    include_examples 'linux'
  when :macosx
    include_examples 'macosx'
  when :freebsd, :netbsd, :openbsd, :dragonfly, :aix, :irix, :hpux
    include_examples 'unix'
  when :sunos
    include_examples 'sunos'
  when :windows, :mswin, :mingw, :bccwin, :djgpp, :wince, :emc
    include_examples 'windows'
  when :cygwin
    include_examples 'cygwin'
  when :vms
    include_examples 'vms'
  when :os2
    include_examples 'os2'
  end

  include_examples(HostOS.posix? ? 'posix' : 'non_posix')
end
