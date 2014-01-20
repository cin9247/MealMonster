class InteractorFactory
  def self.execute(use_case, request, user)
    interactor_class = Interactor.const_get use_case.to_s.camelize

    policy_class = if Policy.const_defined? "#{use_case.to_s.camelize}Policy"
      Policy.const_get "#{use_case.to_s.camelize}Policy"
    else
      Class.new(Struct.new(:user)) do
        def can?(request)
          true
        end
      end
    end

    if policy_class.new(user).can? request
      interactor_class.new(request).run
    else
      raise Policy::NotAuthorized
    end
  end
end
