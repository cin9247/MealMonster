require "spec_helper"

describe "authorization" do
  before do
    user = User.new name: "hans", password: "secret"
    UserMapper.new.save user
  end

  describe "login" do
    context "successful" do
      before do
        visit "/login"

        fill_in "Username", with: "hans"
        fill_in "Password", with: "secret"

        click_on "Login"
      end

      it "redirects to the homepage" do
        expect(page).to have_content "Dashboard"
      end

      it "shows a success message" do
        expect(page).to have_content "erfolgreich eingeloggt"
      end

      it "displays the user's login handle" do
        within ".header" do
          expect(page).to have_content "Eingeloggt als hans"
        end
      end
    end

    describe "unsuccessful" do
      before do
        visit login_path

        fill_in "Username", with: "hans"
        fill_in "Password", with: "secret_wrong"

        click_on "Login"
      end

      it "shows an error message" do
        expect(page).to have_content "Falcher Benutzername oder falsches Passwort"
      end

      it "does not log in user" do
        expect(page).to have_content "Einloggen"
      end
    end
  end

  describe "logout" do
    before do
      visit login_path
      fill_in "Username", with: "hans"
      fill_in "Password", with: "secret"

      click_on "Login"

      visit root_path

      click_on "Ausloggen"
    end

    it "is logged out" do
      expect(page).to have_content "Einloggen"
      expect(page).to have_content "erfolgreich ausgeloggt."
    end
  end

  describe "registration" do
    before do
      visit "/register"

      fill_in "Name", with: "peter"
      fill_in "Password", with: "secret"

      click_on "Register"
    end

    it "creates a new user" do
      users = UserMapper.new.fetch
      expect(users.size).to eq 2
      expect(users.last.name).to eq "peter"
      expect(page).to have_content "erfolgreich registriert"
    end

    it "logs the user in" do
      within ".header" do
        expect(page).to have_content "Eingeloggt als peter"
      end
    end
  end
end
