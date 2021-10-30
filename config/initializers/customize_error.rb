# frozen_string_literal: true

# Customize the field errors output by ActionView to include the 'is-danger' class.
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  class_attr_index = html_tag.index 'class="'
  label = html_tag.index "label"

  if label
    html_tag
  elsif class_attr_index
    html_tag.insert class_attr_index + 7, "is-danger "
  else
    # rubocop:disable Rails/OutputSafety
    # It is ok to mark this as safe because there is no user-input.
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
