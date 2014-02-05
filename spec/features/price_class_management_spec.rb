require "spec_helper"

describe "price class management" do
  before do
    login_as_admin_web
  end

  describe "adding price classes" do
    before do
      visit price_classes_path

      click_on "Neue Preisklasse hinzufügen"

      fill_in "Name", with: "Preisklasse 8"
      fill_in "Preis", with: "23,7€"
      click_on "Preisklasse erstellen"
    end

    it "redirects to the index page" do
      expect(current_path).to eq price_classes_path
    end

    it "creates the new price class" do
      expect(page).to have_content "Preisklasse 8"
      expect(page).to have_content "23,70 €"
    end
  end

  describe "editing price classes" do
    before do
      create_price_class "Billig"

      visit price_classes_path

      click_on "Editieren"
      fill_in "Name", with: "Teuer"
      fill_in "Preis", with: "18€"
      click_on "Preisklasse aktualisieren"
    end

    it "redirects to index page" do
      expect(current_path).to eq price_classes_path
    end

    it "has edited the name of the price class" do
      expect(page).to_not have_content "Billig"
      expect(page).to have_content "Teuer"
      expect(page).to have_content "18,00 €"
    end
  end

  describe "removing price classes", js: true do
    before do
      create_price_class "Billig"

      visit price_classes_path

      click_on "Löschen"
      page.driver.browser.accept_js_confirms
    end

    it "is still on the index page" do
      expect(current_path).to eq price_classes_path
    end

    it "has removed the price class" do
      expect(page).to_not have_content("Billig")
    end
  end
end
