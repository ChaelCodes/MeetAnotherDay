# frozen_string_literal: true

# Any needed Application UI functions
module ApplicationHelper
  # Display buttons for the show page
  def buttons_for_show(resource)
    buttons = []
    buttons << edit_link(resource)
    buttons << delete_link(resource)
    buttons << index_link(resource)
    safe_join(buttons.compact_blank, "|")
  end

  # Display buttons for the show page
  def buttons_for_index(resource)
    buttons = []
    buttons << edit_link(resource)
    buttons << delete_link(resource)
    buttons.map do |button|
      tag.td { button }
    end
    safe_join(buttons)
  end

  # Delete Link if the user has permission
  def delete_link(resource)
    return unless policy(resource).destroy?
    link_to("Delete",
            url_for(resource),
            method: :delete,
            data: { confirm: "Are you sure?" })
  end

  # Edit Link if the user has permission
  def edit_link(resource)
    return unless policy(resource).edit?
    link_to("Edit", url_for([:edit, resource]))
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
