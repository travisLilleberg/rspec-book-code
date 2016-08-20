RSpec::Matchers.define(:redirect_to_home) do |expected|
  match do |actual|
    expect(actual).to redirect_to(
      Rails.application.routes.url_helpers.root_path
    )
  end

  failure_message do |actual|
    "expected to redirect to home"
  end

  failure_message_when_negated do |actual|
    "expected to not redirect to home"
  end

  description do
    "redirect to home"
  end
end
