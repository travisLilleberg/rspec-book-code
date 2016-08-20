module FakeContactMacros

  def fk_last(lastname)
    create(:contact, lastname: lastname)
  end

  def fk_first(firstname)
    create(:contact, firstname: firstname)
  end

  def fk_full(firstname, lastname)
    create(
      :contact,
      firstname: firstname,
      lastname: lastname
    )
  end

  def fk_mail(email)
    create(:contact, email: email)
  end
end
