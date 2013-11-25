require 'bcrypt'

class UserMapper < BaseMapper
  def hash_from_object(record)
    record.password_digest = BCrypt::Password.create(record.password)
    {
      name: record.name,
      password_digest: record.password_digest
    }
  end

  def object_from_hash(hash)
    User.new name: hash[:name],
             password_digest: hash[:password_digest]
  end

  def find_by_name(name)
    u = schema_class.filter(name: name).first
    return unless u
    convert_to_object_and_set_id u
  end

  private
    def schema_class
      Schema::User
    end
end
