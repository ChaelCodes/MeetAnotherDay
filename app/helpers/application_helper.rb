# frozen_string_literal: true

# Any needed Application UI functions
module ApplicationHelper
  # Add pagination helpers
  include Pagy::Frontend

  # Display buttons for the show page
  def buttons(resource, include_nav: false, include_show: false)
    buttons = []
    buttons << show_link(resource) if include_show
    buttons << edit_link(resource)
    buttons << delete_button(resource)
    buttons << index_link(resource) if include_nav
    tag.div(safe_join(buttons), class: "buttons")
  end

  # Delete Button if the user has permission
  def delete_button(resource)
    return unless policy(resource).destroy?
    button_to("Delete",
              url_for(resource),
              method: :delete,
              data: { confirm: "Are you sure?" },
              class: "button is-danger")
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
    link_to("Show", url_for(resource), class: "button is-link")
  end

  # Edit Link if the user has permission
  def edit_link(resource)
    return unless policy(resource).edit?
    link_to("Edit", url_for([:edit, resource]), class: "button is-success")
  end

  # Index Link if the user has permission
  def index_link(resource)
    return unless policy(resource).index?
    link_to("All #{resource.model_name.human.pluralize.titleize}", url_for(resource.class), class: "button is-link")
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

  # Generate QR code for a resource with handle
  def qr_code(url)
    # Generate QR code
    # See: https://github.com/whomwah/rqrcode
    qr = RQRCode::QRCode.new(url)
    svg = qr.as_svg(
      color: "000",
      fill: "fff",
      offset: 3,
      shape_rendering: "crispEdges",
      module_size: 5,
      standalone: true,
      use_path: true
    )

    tag.div(class: "qr-code-container has-text-centered") do
      svg.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
