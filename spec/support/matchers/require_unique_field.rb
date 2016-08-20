RSpec::Matchers.define(:require_unique_field) do |field|
  match do |actual|
    expect(actual.errors[field]).to include('has already been taken')
  end

  failure_message do |actual|
    "expected #{field} to be required to be unique"
  end

  failure_message_when_negated do |actual|
    "expected #{field} to not be required to be unique"
  end

  description do
    "require a field to be unique"
  end
end
