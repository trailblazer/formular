require "formular/errors"
module Formular
  module Elements
    #these methods are used when
    module ControlGroup
      def error
        has_errors? && builder.respond_to?(:error) ? builder.error(options[:error_attrs], { content: error_text }).to_s : ""
      end

      def label
        label_opts = options[:label] ? {content: options[:label]} : {}
        label_opts.merge(options[:label_opts]) if options[:label_opts]
        builder.label(options[:attribute_name], label_opts).to_s
      end

      include Errors
    end
  end
end