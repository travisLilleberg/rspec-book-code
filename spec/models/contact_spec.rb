require 'rails_helper'

describe Contact do

  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end

  it "is invalid without a firstname" do
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact).to require_field(:firstname)
  end

  it "is invalid without a lastname" do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact).to require_field(:lastname)
  end

  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact).to require_field(:email)
  end

  it "is invalid with a duplicate email address" do
    fk_mail('aaron@example.com')
    contact = build(:contact, email: 'aaron@example.com')
    contact.valid?
    expect(contact).to require_unique_field(:email)
  end

  it "returns a contact's full name as a string" do
    contact = build(
      :contact,
      firstname: 'Jane',
      lastname: 'Smith'
    )
    expect(contact.name).to eq('Jane Smith')
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  describe "filter last name by letter" do
    before(:each) do
      @smith = fk_last('Smith')
      @jones = fk_last('Jones')
      @johnson = fk_last('Johnson')
    end

    subject { Contact.by_letter("J") }
    it { is_expected.to eq([@johnson, @jones]) }
    it { is_expected.not_to include(@smith) }
  end

end
