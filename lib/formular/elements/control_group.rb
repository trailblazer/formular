require "formular/errors"
module Formular
  module Elements
    #these methods are used when
    module ControlGroup
      def error
        has_errors? && @builder.respond_to?(:error) ? @builder.error(@options[:error_attrs], { content: error_text }).to_s : ""
      end

      def label
        options = @options[:label] ? {content: @options[:label]} : {}
        @builder.label(@options[:name], @options[:label_attrs], options).to_s
      end

      include Errors
    end
  end
end