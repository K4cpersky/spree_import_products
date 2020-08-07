# frozen_string_literal: true

class Sheet::Validator < Dry::Validation::Contract
  params do
    required(:sheet)
  end
end
