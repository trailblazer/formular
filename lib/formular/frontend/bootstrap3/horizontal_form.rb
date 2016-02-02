require "formular/frontend/bootstrap3"

module Formular
  # http://getbootstrap.com/css/#forms

  # TODO: switches, prefix actions
  module Bootstrap3
    #  <div class="form-group has-error">
    #   <label class="control-label" for="inputerror1">Input with success</label>
    #   <input type="text" class="form-control" id="inputSuccess1" aria-describedby="helpBlock2">
    #   <span id="helpBlock2" class="help-block">A block of help text that breaks onto a new line and may extend beyond one line.</span>
    # </div>
    module HorizontalForm
      class Builder < Bootstrap3::Builder        
        #used to override the basic GroupContent with the horizontal
        module GroupContent
          def group_content(attributes, options, control)
            #column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}
            #label_class is optional as if there is no label then the user will pass 
            #an offset class into input_class insead
            column_attrs = options.delete(:column_attrs)
            options[:label_attrs].merge!(class: column_attrs[:label_class]) if column_attrs[:label_class]
            super
            @label + @tag.(:div, { class: column_attrs[:input_class] }, @input_html) #FIX ME: User needs to be able to definet the classes on the input group
          end
        end
        
        # <div class="form-group">
        #   <label for="exampleInputEmail1">Email address</label>
        #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">
        # </div>
        class Input < Bootstrap3::Builder::Input
          include GroupContent
        end

        class Textarea < Bootstrap3::Builder::Textarea
          include GroupContent
        end
        
        class Select < Bootstrap3::Builder::Select
          include GroupContent
        end
        
        class Collection < Bootstrap3::Builder::Collection
          class Checkbox < Bootstrap3::Builder::Collection::Checkbox
            include GroupContent
          end
          class Radio < Bootstrap3::Builder::Collection::Radio
            include GroupContent
          end
        end
      end
    # TODO: TEST that attributes hash is immutuable.
    end
  end
end
