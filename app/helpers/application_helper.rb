# frozen_string_literal: true

# Any needed Application UI functions
module ApplicationHelper
  # Add pagination helpers
  include Pagy::Frontend



  # Page-specific navigation methods with sensible defaults

  # Navigation for show pages - Edit + Index links, optionally with delete
  def show_page_navigation(resource, include_delete: false)
    buttons = []
    buttons << edit_link(resource)
    buttons << delete_button(resource) if include_delete
    buttons << index_link(resource)
    tag.div(safe_join(buttons), class: "buttons")
  end



  # Navigation for edit pages - Show + Index links
  def edit_page_navigation(resource)
    buttons = []
    buttons << show_link(resource)
    buttons << index_link(resource)
    tag.div(safe_join(buttons), class: "buttons")
  end

  # Cancel button for new pages - links to index
  def cancel_new_link(resource_class)
    link_to("Cancel", url_for(resource_class), class: "button is-primary")
  end

  # Delete Button if the user has permission
  def delete_button(resource, title: "Delete")
    return unless policy(resource).destroy?
    button_to(title,
              url_for(resource),
              method: :delete,
              data: { confirm: "Are you sure?" },
              class: "button is-danger")
  end

  def delete_icon(resource)
    return unless policy(resource).destroy?
    button_to("",
              url_for(resource),
              method: :delete,
              data: { confirm: "Are you sure?" },
              form_class: "delete",
              class: "delete")
  end

  def error_header(resource)
    return unless resource.errors.any?

    "#{pluralize(resource.errors.count, 'error')} prohibited this #{resource} from being saved:"
  end

  # Display an icon stored in app/assets/icons
  def icon(name, alt: nil)
    tag.span(class: "icon") do
      image_tag "#{name}.svg", alt:
    end
  end

  # Show Link if the user has permission
  def show_link(resource)
    return unless policy(resource).show?
    link_to("Show", url_for(resource), class: "button is-link is-outlined")
  end

  # Edit Link if the user has permission
  def edit_link(resource)
    return unless policy(resource).edit?
    link_to("Edit", url_for([:edit, resource]), class: "button is-primary")
  end

  # Index Link if the user has permission
  def index_link(resource)
    return unless policy(resource).index?
    link_to("All #{resource.model_name.human.pluralize.titleize}", url_for(resource.class),
            class: "button is-link is-outlined")
  end

  def alert_color
    return "is-danger" if alert || response.status == 422
    return "is-success" if notice
    "is-primary"
  end

  # Helper method to convert Markwodn to HTML in the views
  def kramdown(text)
    sanitize Kramdown::Document.new(text).to_html
  end

  # Converts to html and then that removes all html tags in order to get pure text
  def kramdown_pure_text(text)
    sanitize kramdown(text), { tags: [] }
  end

  # Generate QR code for a given URL
  # See: https://github.com/whomwah/rqrcode
  def qr_code(url)
    qr = RQRCode::QRCode.new(url)
    svg = qr.as_svg(color: "000", fill: "fff", offset: 3, shape_rendering: "crispEdges", module_size: 5,
                    standalone: true, use_path: true).html_safe # rubocop:disable Rails/OutputSafety

    tag.div(class: "qr-code-container has-text-centered") do
      svg
    end
  end
end
