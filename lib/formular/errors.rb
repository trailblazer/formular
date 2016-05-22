module Formular
  module Errors
    def error_text
      text = has_custom_error? ? options[:error] : errors.send(error_method)

      "#{html_escape(text)}".html_safe
    end

    def has_errors?
      builder.errors && builder.errors.size > 0
    end

    protected
    #errors is an array, what method should we use to return a string?
    def error_method
      :first
    end

    def errors
      @errors ||= (errors_on_attribute).compact
    end

    def errors_on_attribute
      builder.errors[options[:name]]
    end

    def has_custom_error?
      options[:error].is_a?(String)
    end
  end
end
