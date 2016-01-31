module Formular
  module Helper # TODO: test me!
    def form(model, url, attributes={ method: :post }, &block)
      Formular::Helper._frontend.new(model: model).form({action: url}.merge(attributes), &block)
    end

    FRONTENDS = {
      # formular: true,
      bootstrap3:   "Bootstrap3",
      foundation5:  "Foundation5",
    }

    class << self
      def _frontend
        @frontend || Formular::Builder
      end

      attr_writer :frontend

      def frontend(name)
        require "formular/frontend/#{name}"
        self.frontend = Formular.const_get(FRONTENDS.fetch(name))::Builder # Formular::Bootstrap3::Builder
      end
    end
  end
end
