require 'rails_helper'

RSpec.describe NewsRelease, :type => :model do

  it "has a valid factory" do
    expect(build(:news_release)).to be_valid
  end

  it "is invalid without a released_on" do
    contact = build(:news_release, released_on: nil)
    contact.valid?
    expect(contact).to require_field(:released_on)
  end

  it "is invalid without a title" do
    contact = build(:news_release, title: nil)
    contact.valid?
    expect(contact).to require_field(:title)
  end

  it "is invalid without a body" do
    contact = build(:news_release, body: nil)
    contact.valid?
    expect(contact).to require_field(:body)
  end

  it "returns the formatted date and title as a string" do
    news_release = NewsRelease.new(
      released_on: '2013-07-29',
      title: "BigCo hires new CEO"
    )
    expect(news_release.title_with_date).to eq("2013-07-29: BigCo hires new CEO")
  end

end

