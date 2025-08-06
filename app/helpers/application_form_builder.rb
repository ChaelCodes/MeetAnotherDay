# frozen_string_literal: true

# This FormBuilder is the default for the application
# It'll use Bulma styling and build labelled form fields
# If you need a specific input not included here, please add it
class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  delegate :sanitize, :tag, to: :@template

  # This does not appear to be in use
  # It's supposedly used by devise, but testing doesn't show the checkbox?
  def labelled_check_box(method, *input_options, label_options: {}, help: "")
    tag.div(class: "field") do
      check_box(method, *input_options) +
        label(method, label_options) +
        tag.p(sanitize(help), class: "help")
    end
  end

  def labelled_collection_select(method, *input_options, label_options: {}, help: "")
    form_controls(method, label_options, help) do
      collection_select(method, *input_options)
    end
  end

  def labelled_number_field(method, label_options: {}, input_options: {}, help: "")
    form_controls(method, label_options, help) do
      number_field(method, input_options)
    end
  end

  def labelled_select(method, *input_options, label_options: {}, help: "")
    form_controls(method, label_options, help) do
      select(method, *input_options)
    end
  end

  def labelled_text_area(method, label_options: {}, input_options: {}, help: "")
    form_controls(method, label_options, help) do
      text_area(method, input_options)
    end
  end

  def labelled_text_field(method, label_options: {}, input_options: {}, help: "")
    form_controls(method, label_options, help) do
      text_field(method, input_options)
    end
  end

  # Field Overrides
  def email_field(method, options = {})
    super(method, options.merge(class: "input"))
  end

  def number_field(method, options = {})
    super(method, options.merge(class: "input"))
  end

  def password_field(method, options = {})
    super(method, options.merge(class: "input"))
  end

  def text_area(method, options = {})
    super(method, options.merge(class: "textarea"))
  end

  def text_field(method, options = {})
    super(method, options.merge(class: "input"))
  end

  # FormBuilder Overrides
  def collection_select(*args)
    tag.div class: "select" do
      super(*args)
    end
  end

  def label(method, text = nil, options = {}, &block)
    super(method, text, options.merge(class: "label"), &block)
  end

  def select(*args)
    tag.div class: "select" do
      super(*args)
    end
  end

  def submit(value = nil, options = {})
    super(value, options.merge(class: "button is-primary"))
  end

  private

  def form_controls(method, label_options, help = "", &block)
    tag.div(class: "field") do
      label(method, label_options) +
        tag.div(class: "control", &block) +
        tag.p(sanitize(help), class: "help")
    end
  end
end
