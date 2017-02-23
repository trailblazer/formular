module Formular
  # TODO: indirectly tested in erb_test and slim_test. Should probably test directly
  module Helper
    def form(model, url, **options, &block)
      form_options = options
      builder_options = form_options.select { |k, v| form_options.delete(k) || true if [:builder, :model, :path_prefix, :errors, :elements].include?(k) }

      form_options[:action] ||= url
      builder(model, builder_options).form(form_options, &block)
    end

    BUILDERS = {
      basic: 'Formular::Builders::Basic',
      bootstrap3: 'Formular::Builders::Bootstrap3',
      bootstrap4: 'Formular::Builders::Bootstrap4',
      bootstrap3_inline: 'Formular::Builders::Bootstrap3Inline',
      bootstrap4_inline: 'Formular::Builders::Bootstrap4Inline',
      bootstrap3_horizontal: 'Formular::Builders::Bootstrap3Horizontal',
      bootstrap4_horizontal: 'Formular::Builders::Bootstrap4Horizontal',
      foundation6: 'Formular::Builders::Foundation6'
    }.freeze

    class << self
      def _builder
        @builder || load_builder(:basic)
      end
      attr_writer :builder

      def builder(name)
        self.builder = load_builder(name)
      end

      def load_builder(name)
        require "formular/builders/#{name}"
        Formular::Builders.const_get(BUILDERS.fetch(name))
      end
    end

    private

    def builder(model, **options)
      builder_name = options.delete(:builder)

      builder = builder_name ? Formular::Helper.load_builder(builder_name) : Formular::Helper._builder
      options[:model] ||= model

      builder.new(options)
    end

  end # module Helper

  module RailsHelper
    include Helper

    def trb_form_for(model, url, **options, &block)
      options[:csrf_token] ||= form_authenticity_token
      options[:csrf_token_name] ||= request_forgery_protection_token.to_s

      form(model, url, options, &block)
    end
  end  # module RailsHelper
end # module Formular
