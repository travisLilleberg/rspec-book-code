RSpec::Matchers.define(:require_field) do |expected|
  match do |actual|
    expect(actual.errors[expected]).to include("can't be blank")
  end

  failure_message do |actual|
    "expected #{expected} to be required"
  end

  failure_message_when_negated do |actual|
    "expected #{expected} to not be required"
  end

  description do
    "require a specific field"
  end
end
