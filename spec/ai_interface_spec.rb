module AiInterfaceSpec
  def spec_implements_ai_interface(object)
    expect(object).to respond_to(:next_move)
  end
end
