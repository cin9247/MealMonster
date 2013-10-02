class Kitchen
  attr_writer :meal_source, :menu_source

  def initialize
    @meals = []
    @menus = []
  end

  def new_meal(*args)
    meal_source.call self, *args
  end

  def new_menu(*args)
    menu_source.call self, *args
  end

  def add_meal(meal)
    meal_saver.call meal
  end

  def add_menu(menu)
    menu_saver.call menu
  end

  def clean_up!
    meal_clearer.call
    menu_clearer.call
  end

  def meals
    meal_fetcher.call
  end

  def menus
    menu_fetcher.call
  end

  def menu_for_day(day)
    menus.find do |m|
      m.date == day
    end
  end

  def find_meal_by_id(id)
    meals.find do |m|
      m.id.to_s == id.to_s
    end
  end

  private
    def meal_source
      @meal_source ||= Meal.public_method(:new)
    end

    def menu_source
      @menu_source ||= Menu.public_method(:new)
    end

    def meal_fetcher
      lambda { meal_mapper.fetch }
    end

    def menu_fetcher
      lambda { menu_mapper.fetch }
    end

    def meal_saver
      lambda { |meal| meal_mapper.save meal }
    end

    def menu_saver
      lambda { |menu| menu_mapper.save menu }
    end

    def meal_clearer
      lambda { meal_mapper.clean }
    end

    def menu_clearer
      lambda { menu_mapper.clean }
    end

    def meal_mapper
      @meal_mapper ||= generic_mapper_class.new(@meals)
    end

    def menu_mapper
      @menu_mapper ||= generic_mapper_class.new(@menus)
    end

    def generic_mapper_class
      Class.new do
        def initialize(things)
          @things = things || []
        end

        def fetch
          @things
        end

        def save(thing)
          @things << thing
        end

        def clean
          @things = []
        end
      end
    end
end
