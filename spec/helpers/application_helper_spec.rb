# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
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
