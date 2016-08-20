require 'rails_helper'

describe Phone do
  before(:each) do
    @contact = create(:contact)
    create(
      :home_phone,
      contact: @contact,
      phone: '785-555-1234'
    )
  end

  it "does not allow duplicate phone numbers per contact" do
    mobile_phone = build(
      :mobile_phone,
      contact: @contact,
      phone: '785-555-1234'
    )

    mobile_phone.valid?
    expect(mobile_phone).to require_unique_field(:phone)
  end

  it "allows two contacts to share a phone number" do
    expect(build(:home_phone, phone: '785-555-1234')).to be_valid
  end

end
