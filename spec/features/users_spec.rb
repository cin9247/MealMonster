require "spec_helper"

describe "users" do
  def logout
    click_on "Ausloggen"
  end

  before do
    login_as_admin_web
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

  describe "remove link to customer from user" do
    before do
      create_user "admin", "admin", "admin"
      login_with "admin", "admin"

      user = create_user "peter", "peter", "customer"
      customer = create_customer "Peter", "Mustermann"
      link_user_to_customer user.id, customer.id

      visit users_path
    end

    it "lets user unlink to the accounts" do
      click_on "Verbindung mit Peter Mustermann löschen"

      expect(UserMapper.new.fetch.all? { |u| !u.is_linked? }).to eq true
    end
  end

  describe "updating user" do
    before do
      user = create_user "user", "password", "manager"
      login_with "user", "password"

      visit edit_user_path(user)

      fill_in "Name", with: "new user"
      fill_in "Passwort", with: "password2"
      fill_in "Passwort-Bestätigung", with: "password2"

      click_on "Benutzer aktualisieren"
    end

    it "redirects to users" do
      expect(current_path).to eq users_path
    end

    it "shows a flash notice" do
      expect(page).to have_content "Benutzer erfolgreich aktualisiert."
    end

    it "lets the user login with its new password" do
      logout

      login_with "new user", "password2"

      expect(page).to have_content "erfolgreich eingeloggt"
    end
  end
end
