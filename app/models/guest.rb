class Guest < User
  def has_role(role)
    false
  end
end
