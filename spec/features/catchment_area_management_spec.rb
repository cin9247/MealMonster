require "spec_helper"

describe "catchment area management" do
  before do
    login_as_admin_web
  end

  describe "adding catchment area" do
    before do
      visit catchment_areas_path

      click_on "Neues Einzugsgebiet hinzufügen"

      fill_in "Name", with: "Else-Heydlauf-Stiftung"
      click_on "Einzugsgebiet erstellen"
    end

    it "redirects to the index page" do
      expect(current_path).to eq catchment_areas_path
    end

    it "creates the new catchment area" do
      expect(page).to have_content "Else-Heydlauf-Stiftung"
    end
  end

  describe "editing catchment area" do
    before do
      create_catchment_area "Krankenhaus"

      visit catchment_areas_path

      click_on "Editieren"
      fill_in "Name", with: "Altenheim"
      click_on "Einzugsgebiet aktualisieren"
    end

    it "redirects to index page" do
      expect(current_path).to eq catchment_areas_path
    end

    it "has edited the name of the catchment area" do
      expect(page).to_not have_content "Krankenhaus"
      expect(page).to have_content "Altenheim"
    end
  end
end
