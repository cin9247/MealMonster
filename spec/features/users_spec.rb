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

  describe "link user to customer" do
    before do
      create_user "peter", "peter", "admin"
      create_user "max", "password", "customer"
      create_customer "Peter", "Mustermann"
      create_customer "Chuck", "Norris"

      login_with "peter", "peter"
      visit users_path
    end

    it "only shows linking link for customers" do
      within ".users tr", text: "peter" do
        expect(page).to_not have_content "Mit Kunde verbinden"
      end

      within ".users tr", text: "max" do
        expect(page).to have_content "Mit Kunde verbinden"
      end
    end

    it "lets user link to customers" do
      click_on "Mit Kunde verbinden"

      select "Peter Mustermann", from: "Kunde"

      click_on "Link erstellen"

      expect(UserMapper.new.fetch.last.customer.forename).to eq "Peter"
    end
  end
end
