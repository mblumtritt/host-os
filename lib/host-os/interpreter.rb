# frozen_string_literal: true

require_relative('../host-os') unless defined?(HostOS.id)

module HostOS
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
      # @!attribute [r] mri?
      # @return [true, false] whether the interpreter is the Yukihiro
      #   Matsumoto's C-based (default) Ruby Interpreter
      def mri?
        id == :mri
      end
      alias cruby? mri?
      alias default? mri?

      # @!attribute [r] cardinal?
      # @return [true, false] whether the interpreter is the Parrot based
      #   Cardinal interpreter
      def cardinal?
        id == :cardinal
      end
      alias parrot? cardinal?

      # @!attribute [r] jruby?
      # @return [true, false] whether the interpreter is the Java based JRuby
      #  Interpreter
      def jruby?
        id == :jruby
      end
      alias java? jruby?

      # @!attribute [r] rbx?
      # @return [true, false] whether the interpreter is the Rubinius
      #   Interpreter
      def rbx?
        id == :rbx
      end
      alias rubinius? rbx?

      # @!attribute [r] ree?
      # @return [true, false] whether the interpreter is the Ruby Enterprise
      #   Edition
      def ree?
        id == :ree
      end
      alias enterprise? ree?

      # @!attribute [r] jit_enabled?
      # @return [true, false] whether the interpreter currently uses a JIT
      #   Compiler
      def jit_enabled?
        jit_type != :none
      end

      # @!attribute [r] jit_type
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
        @to_s ||=
          {
            cardinal: 'Cardinal',
            jruby: 'JRuby',
            mri: 'CRuby',
            rby: 'Rubinius',
            ree: 'Enterprise Ruby',
            truffleruby: 'TruffleRuby'
          }.compare_by_identity[
            id
          ] || id.to_s.upcase
      end

      # Path name of current Ruby executable.
      # @!attribute [r] exe
      # @return [String] complete path name to current Ruby executable
      # @return [nil] when executable can not be detected
      def exe
        defined?(@exe) ? @exe : @exe = find_exe
      end

      # @!attribute [r] id
      # @return [Symbol] interpreter identifier

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

      def find_exe
        require 'rbconfig' unless defined?(RbConfig)
        RbConfig.ruby
      rescue LoadError
        ENV['RUBY']
      rescue NoMethodError
        File.join(
          RbConfig::CONFIG['bindir'],
          RbConfig::CONFIG['ruby_install_name'] + RbConfig::CONFIG['EXEEXT']
        )
      end
    end

    @id = identify
  end
end
