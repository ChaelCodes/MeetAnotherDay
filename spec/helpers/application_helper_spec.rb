# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  let(:user) { create(:user, :admin) }
  let(:event) { create(:event) }
  let(:profile) { create(:profile) }
  let(:event_attendee) { create(:event_attendee) }
  let(:notification) { create(:notification) }

  before do
    helper.extend(Pundit::Authorization)
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe "#show_page_navigation" do
    it "generates edit and index links without delete by default" do
      result = helper.show_page_navigation(event)
      
      expect(result).to include('class="buttons"')
      expect(result).to include("href=\"#{edit_event_path(event)}\"")
      expect(result).to include('class="button is-primary"')
      expect(result).to include('>Edit<')
      expect(result).to include('href="/events"')
      expect(result).to include('class="button is-link is-outlined"')
      expect(result).to include('>All Events<')
      expect(result).not_to include('method="delete"')
    end

    it "includes delete button when include_delete is true" do
      result = helper.show_page_navigation(event, include_delete: true)
      
      expect(result).to include('<form')
      expect(result).to include('class="button is-danger"')
      expect(result).to include('>Delete<')
      expect(result).to include('data-confirm="Are you sure?"')
    end

    context "when user lacks permissions" do
      let(:user) { create(:user) }

      it "does not include edit link when user lacks permission" do
        result = helper.show_page_navigation(event)
        
        expect(result).not_to include("href=\"#{edit_event_path(event)}\"")
        expect(result).not_to include('>Edit<')
      end
    end
  end

  describe "#edit_page_navigation" do
    it "generates show and index links" do
      result = helper.edit_page_navigation(event)
      
      expect(result).to include('class="buttons"')
      expect(result).to include("href=\"#{event_path(event)}\"")
      expect(result).to include('class="button is-link is-outlined"')
      expect(result).to include('>Show<')
      expect(result).to include('href="/events"')
      expect(result).to include('>All Events<')
    end
  end

  describe "#cancel_new_link" do
    it "generates cancel link with primary styling" do
      result = helper.cancel_new_link(Event)
      
      expect(result).to include('href="/events"')
      expect(result).to include('class="button is-primary"')
      expect(result).to include('>Cancel<')
    end

    it "works with different resource classes" do
      result = helper.cancel_new_link(Profile)
      
      expect(result).to include('href="/profiles"')
      expect(result).to include('>Cancel<')
    end
  end

  describe "#show_link" do
    it "generates show link with proper styling" do
      result = helper.show_link(event)
      
      expect(result).to include("href=\"#{event_path(event)}\"")
      expect(result).to include('class="button is-link is-outlined"')
      expect(result).to include('>Show<')
    end

    it "returns nil when policy denies access" do
      allow(helper).to receive(:policy).with(event).and_return(double(show?: false))
      
      result = helper.show_link(event)
      
      expect(result).to be_nil
    end
  end

  describe "#edit_link" do
    it "generates edit link with primary styling" do
      result = helper.edit_link(event)
      
      expect(result).to include("href=\"#{edit_event_path(event)}\"")
      expect(result).to include('class="button is-primary"')
      expect(result).to include('>Edit<')
    end

    context "when user lacks permissions" do
      let(:user) { create(:user) }

      it "returns nil when user lacks permission" do
        result = helper.edit_link(event)
        
        expect(result).to be_nil
      end
    end
  end

  describe "#index_link" do
    it "generates index link with proper styling" do
      result = helper.index_link(event)
      
      expect(result).to include('href="/events"')
      expect(result).to include('class="button is-link is-outlined"')
      expect(result).to include('>All Events<')
    end

    it "returns nil when policy denies access" do
      allow(helper).to receive(:policy).with(event).and_return(double(index?: false))
      
      result = helper.index_link(event)
      
      expect(result).to be_nil
    end
  end

  context "when kramdown is used to convert markdown to html" do
    it "if the inline code markdown code is passed" do
      markdown_source = "`inline code`"
      expect(kramdown(markdown_source)).to eq "<p><code>inline code</code></p>\n"
    end

    it "if the multiline code markdown code is passed" do
      markdown_source = "* list"
      expect(kramdown(markdown_source)).to eq "<ul>\n  <li>list</li>\n</ul>\n"
    end
  end

  context "when kramdown_pure_text is used to remove any markdown code" do
    it "if the inline code markdown code is passed" do
      markdown_source = "`inline code`"
      expect(kramdown_pure_text(markdown_source)).to eq "inline code\n"
    end
  end
end
