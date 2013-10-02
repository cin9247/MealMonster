class MealMapper
  def save(record)
    klass.create(name: record.name)
  end

  def fetch
    klass.all.map do |m|
      klass.new name: m.name
    end
  end

  def clean
    klass.delete_all
  end

  def find(id)
    klass.find id
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private
    def meals
      @meals ||= []
    end

    def klass
      Class.new(ActiveRecord::Base) do
        self.table_name = "meals"
      end
    end
end
