# frozen_string_literal: true

require_relative 'helper'

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
  # @example Test for JRuby
  #  HostOS.interpreter == :jruby
  #
  module Interpreter
    extend Helper

    class << self
      # @attribute [r] id
      # @return [Symbol] interpreter identifier
      def id = ID

      # @attribute [r] mri?
      # @return [true, false] whether the interpreter is the Yukihiro Matsumoto's
      #   C-based (default) Ruby Interpreter
      def mri? = (ID == :mri)
      alias default? mri?

      # @attribute [r] cardinal?
      # @return [true, false] whether the interpreter is the Parrot based Cardinal
      #   interpreter
      def cardinal? = (ID == :cardinal)
      alias parrot? cardinal?

      # @attribute [r] jruby?
      # @return [true, false] whether the interpreter is the Java based JRuby
      #  Interpreter
      def jruby? = (ID == :jruby)
      alias java? jruby?

      # @attribute [r] rbx?
      # @return [true, false] whether the interpreter is the Rubinius Interpreter
      def rbx? = (ID == :rbx)
      alias rubinius? rbx?

      # @attribute [r] ree?
      # @return [true, false] whether the interpreter is the Ruby Enterprise
      #   Edition
      def ree? = (ID == :ree)
      alias enterprise? ree?

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
        return RUBY_ENGINE.to_s.to_sym if RUBY_ENGINE != 'ruby'
        RUBY_DESCRIPTION.downcase.include?('enterprise') ? :ree : :mri
      end
    end

    # @return [Symbol] interpreter identifier
    ID = identify
  end
end
