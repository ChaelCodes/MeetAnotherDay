ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  class_attr_index = html_tag.index 'class="'
  label = html_tag.index 'label'

  if label
    html_tag
  elsif class_attr_index
    html_tag.insert class_attr_index + 7, 'is-danger '
  else
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
  end
end
