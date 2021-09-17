# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module RadioButton
      extend ActiveSupport::Concern
      include Base

      included do
        def radio_button_with_bootstrap(name, value, *args)
          options = args.extract_options!.symbolize_keys!
          args << options.except(:label, :label_class, :help, :inline)

          html = radio_button_without_bootstrap(name, value, *args) + " " + options[:label]

          disabled_class = " disabled" if options[:disabled]
          label_class    = options[:label_class]

          if options[:inline]
            label_class = " #{label_class}" if label_class
            label(name, html, class: "radio-inline#{disabled_class}#{label_class}", value: value)
          else
            content_tag(:div, class: "radio#{disabled_class}") do
              label(name, html, value: value, class: label_class)
            end
          end
        end

        bootstrap_alias :radio_button
      end

      private

      def radio_button_label(name, value, options)
        label_options = { value: value, class: radio_button_label_class(options) }
        label_options[:for] = options[:id] if options[:id].present?
        label(name, options[:label], label_options)
      end

      def radio_button_classes(name, options)
        classes = [options[:class]]
        classes << (options[:custom] ? "custom-control-input" : "form-check-input")
        classes << "is-invalid" if error?(name)
        classes << "position-static" if options[:skip_label] || options[:hide_label]
        classes.flatten.compact
      end

      def radio_button_label_class(options)
        classes = []
        classes << (options[:custom] ? "custom-control-label" : "form-check-label")
        classes << options[:label_class]
        classes << hide_class if options[:hide_label]
        classes.flatten.compact
      end

      def radio_button_wrapper_class(options)
        classes = []
        classes << if options[:custom]
                     custom_radio_button_wrapper_class(options)
                   else
                     standard_radio_button_wrapper_class(options)
                   end
        classes << options[:wrapper_class] if options[:wrapper_class].present?
        classes.flatten.compact
      end

      def standard_radio_button_wrapper_class(options)
        classes = %w[form-check]
        classes << "form-check-inline" if layout_inline?(options[:inline])
        classes << "disabled" if options[:disabled]
        classes
      end

      def custom_radio_button_wrapper_class(options)
        classes = %w[custom-control custom-radio]
        classes << "custom-control-inline" if layout_inline?(options[:inline])
        classes
      end
    end
  end
end
