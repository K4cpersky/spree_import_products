class Sheet::ParseResult
  attr_reader :errors, :rows

  def initialize(errors: [], rows: [])
    @errors = errors
    @rows = rows
  end

  def success?
    errors.empty?
  end
end
