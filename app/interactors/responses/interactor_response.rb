class InteractorResponse
  attr_accessor :status

  def initialize(args={})
    args.each do |key, value|
      public_send "#{key}=", value
    end
  end
end
