require 'roo'
require 'date'
require_relative './date_range'
require_relative '../app/models/offering'
require_relative '../app/models/menu'
require_relative '../app/models/meal'

class OfferingImporter
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def import!
    from = cell(3, 2)
    to = cell(4, 2)

    from = parse_date from
    to = parse_date to

    range = DateRange.new(from, to)

    offerings_count_per_day = cell(8, 2).to_i
    offerings_start_at_row = 15
    range.to_a.each_with_index.map do |d, i|
      current_row = offerings_start_at_row + i * (offerings_count_per_day + 1) + 1
      date = parse_date(cell(current_row - 1, 2))

      rows = offerings_count_per_day.times.map do |j|
        offering_name = cell(current_row + j, 1)
        menu_name = cell(current_row + j, 2)
        {
          name: cell(current_row + j, 1),
          sub_name: cell(current_row + j, 2),
          kilojoules: cell(current_row + j, 9).to_f,
          bread_units: cell(current_row + j, 11).to_f
        }
      end
      soup_meal = rows.find { |r| r[:name] == "Tagessuppe" }
      desert_meal = rows.find { |r| r[:name] == "Dessert" }
      main_meal_1 = rows.find { |r| r[:name] == "Hauptgricht 1" }
      main_meal_2 = rows.find { |r| r[:name] == "Hauptgericht 2" }

      soup_meal, desert_meal, main_meal_1, main_meal_2 = [soup_meal, desert_meal, main_meal_1, main_meal_2].map do |meal|
        if meal[:sub_name]
          Meal.new(name: meal[:sub_name], bread_units: meal[:bread_units], kilojoules: meal[:kilojoules])
        else
          nil
        end
      end

      main_menu_1 = Menu.new(name: "Menü 1", meals: [soup_meal, main_meal_1, desert_meal].compact)

      if main_meal_2.nil?
        Offering.new(menu: main_menu_1, date: date)
      else
        main_menu_2 = Menu.new(name: "Menü 2", meals: [soup_meal, main_meal_2, desert_meal].compact)
        [
          Offering.new(menu: main_menu_1, date: date),
          Offering.new(menu: main_menu_2, date: date)
        ]
      end

    end.flatten

  end

  private
    def roo
      @roo ||= Roo::CSV.new(file_name)
    end

    def cell(row, column)
      roo.cell row, column
    end

    def parse_date(string)
      _, month, day, year = string.match(/(\d{1,2})\/(\d{1,2})\/(\d{4})/).to_a
      Date.new(year.to_i, month.to_i, day.to_i)
    end
end
