require 'test_helper'
require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap4'

describe 'Bootstrap4::Element::ButtonTest' do
  let(:builder) { Formular::Builders::Bootstrap4.new }

  describe Formular::Element::Bootstrap4::Button do
    it 'default' do
      element = builder.button(:public, content: 'Basic')
      element.to_s.must_equal %(<button class="btn btn-secondary" type="button">Basic</button>)
    end

    it 'with custom color' do
      element = builder.button(:public, content: 'Basic', color: 'primary')
      element.to_s.must_equal %(<button class="btn btn-primary" type="button">Basic</button>)
    end

    it 'with custom size' do
      element = builder.button(:public, content: 'Basic', size: 'lg')
      element.to_s.must_equal %(<button class="btn btn-lg btn-secondary" type="button">Basic</button>)
    end

    it 'is block btn' do
      element = builder.button(:public, content: 'Basic', block: true)
      element.to_s.must_equal %(<button class="btn btn-block btn-secondary" type="button">Basic</button>)
    end
  end
end
