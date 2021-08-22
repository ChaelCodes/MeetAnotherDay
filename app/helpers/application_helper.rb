# frozen_string_literal: true

# Any needed Application UI functions
module ApplicationHelper
  # Display buttons for the show page
  def buttons(resource, include_nav: false)
    buttons = []
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
end
