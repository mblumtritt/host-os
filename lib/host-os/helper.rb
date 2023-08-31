# frozen_string_literal: true

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
end
