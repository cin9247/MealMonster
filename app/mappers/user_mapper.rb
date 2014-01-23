require 'bcrypt'
require 'yaml'

class UserMapper < BaseMapper
  def hash_from_object(record)
    if record.password
      record.password_digest = BCrypt::Password.create(record.password)
    end
    {
      name: record.name,
      password_digest: record.password_digest,
      roles: YAML.dump(record.roles),
      customer_id: record.customer.try(:id)
    }
  end

  def object_from_hash(hash)
    roles = YAML.load(hash[:roles])
    User.new(name: hash[:name], password_digest: hash[:password_digest]).tap do |u|
      roles.each { |r| u.add_role r }
      u.customer = CustomerMapper.new.find(hash[:customer_id]) if hash[:customer_id]
    end
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
