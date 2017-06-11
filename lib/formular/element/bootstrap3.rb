require 'formular/element'
require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/module'
require 'formular/element/bootstrap3/checkable_control'
require 'formular/element/bootstrap3/column_control'

module Formular
  class Element
    module Bootstrap3
      include CheckableControl

      Label = Class.new(Formular::Element::Label) { set_default :class, ['control-label'] }
      Row = Class.new(Formular::Element::Div) { set_default :class, ['row'] }

      class Icon < Formular::Element::Span
        add_option_keys :name
        set_default :class, :icon_class

        #returns the class of the bootstrap Glyphicons
        #accepts the string or symbolized name of the glyphicon (see list below for available options)
        #asterisk, plus, euro, minus, cloud, envelope, pencil, glass, music, search, heart, star, star-empty,
        #user, film, th-large, th, th-list, ok, remove, zoom-in, zoom-out, off, signal, cog, trash, home, file,
        #time, road, download-alt, download, upload, inbox, play-circle, repeat, refresh, list-alt, lock,
        #flag, headphones, volume-off, volume-down, volume-up, qrcode, barcode, tag, tags, book, bookmark,
        #print, camera, font, bold, italic, text-height, text-width, align-left, align-center, align-right,
        #align-justify, list, indent-left, indent-right, facetime-video, picture, map-marker, adjust,
        #tint, edit, share, check, move, step-backward, fast-backward, backward, play, pause, stop, forward,
        #fast-forward, step-forward, eject, chevron-left, chevron-right, plus-sign, minus-sign, remove-sign,
        #ok-sign, question-sign, info-sign, screenshot, remove-circle, ok-circle, ban-circle, arrow-left,
        #arrow-right, arrow-up, arrow-down, share-alt, resize-full, resize-small, exclamation-sign, gift, leaf,
        #fire, eye-open, eye-close, warning-sign, plane, calendar, random, comment, magnet, chevron-up,
        #chevron-down, retweet, shopping-cart, folder-close, folder-open, resize-vertical, resize-horizontal,
        #hdd, bullhorn, bell, certificate, thumbs-up, thumbs-down, hand-right, hand-left, hand-up, hand-down,
        #circle-arrow-right, circle-arrow-left, circle-arrow-up, circle-arrow-down, globe, wrench, tasks,
        #filter, briefcase, fullscreen, dashboard, paperclip, heart-empty, link, phone, pushpin, usd, gbp,
        #sort, sort-by-alphabet, sort-by-alphabet-alt, sort-by-order, sort-by-order-alt, sort-by-attributes,
        #sort-by-attributes-alt, unchecked, expand, collapse-down, collapse-up, log-in, flash, log-out, new-window,
        #record, save, open, saved, import, export, send, floppy-disk, floppy-saved, floppy-remove, floppy-save,
        #floppy-open, credit-card, transfer, cutlery, header, compressed, earphone, phone-alt, tower, stats,
        #sd-video, hd-video, subtitles, sound-stereo, sound-dolby, sound-5-1, sound-6-1, sound-7-1,
        #copyright-mark, registration-mark, cloud-download, cloud-upload, tree-conifer, tree-deciduous
        def icon_class
          icon_name = options[:name].to_s.gsub("_","-")
          %(glyphicon glyphicon-#{icon_name})
        end
      end

      class Submit < Formular::Element::Button
        set_default :class, ['btn', 'btn-default']
        set_default :type, 'submit'
      end # class Submit

      class ErrorNotification < Formular::Element::ErrorNotification
        set_default :class, ['alert alert-danger']
        set_default :role, 'alert'
      end

      class Error < Formular::Element::Error
        tag :span
        set_default :class, ['help-block']
      end # class Error

      class Hint < Formular::Element::Span
        set_default :class, ['help-block']
      end # class Hint

      class Input < Formular::Element::Input
        include Formular::Element::Modules::Wrapped
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, :input_class

        def input_class
          'form-control' unless options[:type].to_s == 'file'
        end
      end # class Input

      class Select < Formular::Element::Select
        include Formular::Element::Modules::Wrapped
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Select

      class Textarea < Formular::Element::Textarea
        include Formular::Element::Modules::Wrapped
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Textarea

      class Wrapper < Formular::Element::Div
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Element::Div
        set_default :class, ['form-group', 'has-error']
      end # class Wrapper
    end # module Bootstrap3
  end # class Element
end # module Formular
