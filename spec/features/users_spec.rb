feature 'User management' do

  scenario "adds a new user" do
    admin = create(:admin)
    mail = "newuser@example.com"
    pass = "secret123"

    sign_in(admin)
    visit(root_path)
    expect {
      click_link('Users')
      click_link('New User')
      fill_in('Email', with: mail)
      find('#password').fill_in('Password', with: pass)
      find('#password_confirmation').fill_in('Password confirmation', with: pass)
      click_button('Create User')
    }.to change(User, :count).by(1)
    expect(current_path).to eq(users_path)
    expect(page).to have_content('New user created')
    within 'h1' do
      expect(page).to have_content('Users')
    end
    expect(page).to have_content(mail)
  end # End scenario adds a new user

end
