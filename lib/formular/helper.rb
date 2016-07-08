module Formular
  # TODO: indirectly tested in erb_test and slim_test. Should probably test directly
  module Helper
    def form(model, url, **options, &block)
      form_options = options
      builder_options = form_options.select { |k, v| form_options.delete(k) || true if [:builder, :model, :path_prefix, :errors, :elements].include?(k) }

      form_options[:method] ||= :post
      form_options[:action] ||= url
      builder(model, builder_options).form(form_options, &block)
    end

    BUILDERS = {
      basic: 'Formular::Builders::Basic',
      bootstrap3: 'Formular::Builders::Bootstrap3',
      bootstrap3_inline: 'Formular::Builders::Bootstrap3Inline',
      bootstrap3_horizontal: 'Formular::Builders::Bootstrap3Inline',
      foundation6: 'Formular::Builders::Foundation6'
    }.freeze

    class << self
      def _builder
        @builder || Formular::Builders::Basic
      end
      attr_writer :builder

      def builder(name)
        require "formular/builders/#{name}"
        self.builder = Formular::Builders.const_get(BUILDERS.fetch(name)) # Formular::Builders::Bootstrap3
      end
    end

    private

    def builder(model, **options)
      builder = options.delete(:builder)
      builder = builder.nil? ? Formular::Helper._builder : Formular::Helper.builder(builder)
      options[:model] ||= model

      builder.new(options)
    end
  end # module Helper
end # module Formular
