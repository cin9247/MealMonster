require "spec_helper"

describe "users" do
  describe "registration" do
    pending "can register"
  end

  describe "overview" do
    before do
      create_user "peter", "password", "admin"
      create_user "max", "password", "driver"

      login_with "peter", "peter"
      visit users_path
    end

    it "should show all registered users" do
      expect(page).to have_content "peter"
      expect(page).to have_content "max"

      expect(page).to have_content "driver"
      expect(page).to have_content "admin"
    end
  end
end
