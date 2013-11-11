require_relative "./interactor_response"

class FailureResponse < InteractorResponse
  def success?
    false
  end
end
