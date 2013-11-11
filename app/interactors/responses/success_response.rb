require_relative "./interactor_response"

class SuccessResponse < InteractorResponse
  def success?
    true
  end
end
