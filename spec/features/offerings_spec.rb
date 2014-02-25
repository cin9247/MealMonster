require "spec_helper"

describe "offerings" do
  let!(:hackbraten)  { create_meal "Hackbraten" }
  let!(:spaghetti)   { create_meal "Spaghetti" }
  let!(:nusskuchen)  { create_meal "Nusskuchen" }
  let!(:price_class) { create_price_class("Preisklasse 4") }

  before do
    login_as_admin_web
  end

  describe "viewing the offerings" do
    before do
      create_offering(Date.new(2013, 5, 6), "Menü #1", [hackbraten, spaghetti].map(&:id))
      create_offering(Date.new(2013, 5, 6), "Menü #2", [hackbraten, nusskuchen].map(&:id))
      create_offering(Date.new(2013, 5, 7), "Menü #1", [nusskuchen].map(&:id))

      visit "/offerings?from=2013-05-04&to=2013-05-08"
    end

    it "displays a list of menus for each day" do
      within(".day", text: "06.05.2013") do
        within("li", text: "Menü #1") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Spaghetti"
        end

        within("li", text: "Menü #2") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Nusskuchen"
        end
      end

      within(".day", text: "07.05.2013") do
        within("li", text: "Menü #1") do
          expect(page).to have_content "Nusskuchen"
          expect(page).to_not have_content "Spaghetti"
          expect(page).to_not have_content "Hackbraten"
        end
      end
    end
  end

  describe "offering creation" do
    before do
      visit new_offering_path(from: Date.new(2014, 2, 2), to: Date.new(2014, 2, 4))

      within("li", text: "02.02.2014") do
        fill_in "Name", with: "Vollkost"
        fill_in "Vorspeise", with: "Suppe"
        fill_in "Hauptgericht", with: "Schweinebraten"
        fill_in "Nachtisch", with: "Eis"
      end

      within("li", text: "03.02.2014") do
        fill_in "Name", with: "Spaghetti"
      end

      click_on "Angebote erstellen"
    end

    xit "redirects to the created offerings and shows a notice" do
      expect(current_path).to eq offerings_path
    end

    it "saves the offering" do
      offerings = OfferingMapper.new.fetch
      expect(offerings.size).to eq 2
      expect(offerings.first.name).to eq "Vollkost"
      expect(offerings.first.date).to eq Date.new(2014, 2, 2)
      expect(offerings.first.menu.meals[0].name).to eq "Suppe"
      expect(offerings.first.menu.meals[1].name).to eq "Schweinebraten"
      expect(offerings.first.menu.meals[2].name).to eq "Eis"

      expect(offerings.last.name).to eq "Spaghetti"
      expect(offerings.last.date).to eq Date.new(2014, 2, 3)
      expect(offerings.last.meals.size).to eq 0
    end
  end

  describe "importing an offering" do
    before do
      visit offerings_path

      click_on "Speiseplan importieren"

      attach_file "Speiseplan", "spec/fixtures/speiseplan.csv"
      click_on "Importieren"
    end

    it "redirects to offerings_path" do
      expect(page).to have_content "Kräutercremesuppe"
    end

    let(:offerings) { OfferingMapper.new.fetch }

    it "has created the imported offerings" do
      expect(offerings.size).to eq 12
      expect(offerings[0].name).to eq "Menü 1"
      expect(offerings[1].name).to eq "Menü 2"
      expect(offerings[0].date).to eq Date.new(2014, 1, 13)
      expect(offerings[11].date).to eq Date.new(2014, 1, 19)
    end

    xit "has created the nested meals in its correct order" do
      expect(offerings[0].menu.meals.map(&:name)).to eq ["Kräutercremesuppe", "Grillbratwurst auf Sauerkraut mit Kartoffelpüree", "Birnenkompott"]
      expect(offerings[1].menu.meals.map(&:name)).to eq ["Kräutercremesuppe", "Schlemmerfilet a la Bordelaise mit Kräuterauflage an Karottengemüse und Salzkartoffeln", "Birnenkompott"]
    end
  end
end
