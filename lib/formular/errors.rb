module Formular
  module Errors
    def error_message(attribute_name)
      errors.send(error_method) if has_errors?(attribute_name)
    end

    def has_errors?(attribute_name)
      errors && errors_on_attribute(attribute_name).size > 0
    end

    protected

    #errors is an array, what method should we use to return a string?
    def error_method
      :first
    end

    def errors_on_attribute
      @attribute_errors ||= errors[attribute_name]
    end
  end
end
