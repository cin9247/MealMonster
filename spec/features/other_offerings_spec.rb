require "spec_helper"

describe "other offerings not bound to date" do
  describe "listing of all offerings" do
    before do
      login_as_admin_web
      create_all_time_offering("Abendessen", Money.new(220, "EUR"))
      visit all_time_offerings_path
    end

    it "lists the offering" do
      expect(page).to have_content "Abendessen"
      expect(page).to have_content "2.20 EUR"
    end
  end

  describe "new offering" do
    before do
      create_price_class "Preisklasse 1"

      login_as_admin_web
      visit new_all_time_offering_path

      fill_in "Name", with: "Abendessen"
      select "Preisklasse 1", from: "Preisklasse"

      click_on "Angebot erstellen"
    end

    it "redirects to the offerings path" do
      expect(current_path).to eq all_time_offerings_path
    end

    it "has created the offering" do
      expect(page).to have_content "Abendessen"
    end

    it "displays a notification" do
      expect(page).to have_content "Angebot erfolgreich erstellt."
    end
  end

  describe "editing an offering" do
    before do
      create_all_time_offering("Abendessen", Money.new(245))

      login_as_admin_web
      visit all_time_offerings_path

      within "tr", text: "Abendessen" do
        click_on "Editieren"
      end

      fill_in "Name", with: "Abendessen 2"
      click_on "Angebot aktualisieren"
    end

    it "redirects to the list of offerings" do
      expect(current_path).to eq all_time_offerings_path
    end

    it "has updated the offering" do
      expect(page).to have_content "Abendessen 2"
    end
  end
end
