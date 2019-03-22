#
# Copyright (C) 2019 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

require File.expand_path(File.dirname(__FILE__) + '/common')

describe "content security policy" do
  include_context "in-process server selenium tests"

  context "with csp enabled" do

    it "should display a flash alert for non-whitelisted iframe", ignore_js_errors: true do
      Account.default.enable_feature!(:javascript_csp)
      Account.default.enable_csp!

      course_with_teacher_logged_in
      @course.wiki_pages.create!(title: 'Page1', body: "<iframe width=\"560\" height=\"315\""\
      "src=\"https://www.youtube.com/embed/dQw4w9WgXcQ\" frameborder=\"0\""\
      "allow=\"accelerometer; autoplay; encrypted-media; gyroscope;"\
      "picture-in-picture\" allowfullscreen></iframe>")

      get "/courses/#{@course.id}/pages/Page1/"

      expect_instui_flash_message "Content on this page violates the security policy, contact your admin for assistance."
    end

  end
end