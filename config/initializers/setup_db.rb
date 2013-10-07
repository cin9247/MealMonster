url = ENV["DATABASE_URL"] || "postgres://localhost:5432/ear_#{Rails.env}"
DB = Sequel::Model.db
