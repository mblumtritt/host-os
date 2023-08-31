# frozen_string_literal: true

require_relative 'helper'

module HostOS
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
end
