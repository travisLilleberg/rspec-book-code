require 'rails_helper'

describe ContactsController do

  let(:contact) do
    create(:contact)
  end

  #********** Index/Show Access **********#
  shared_examples 'public access to contacts' do

    describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          smith = fk_last('Smith')
          jones = fk_last('Jones')
          get(:index, letter: 'S')
          expect(assigns(:contacts)).to match_array([smith])
        end

        it "renders the :index template" do
          get(:index, letter: 'S')
          expect(response).to render_template(:index)
        end
      end

      context 'without params[:letter]' do
        it "populates an array of all contacts" do
          smith = fk_last('Smith')
          jones = fk_last('Jones')
          get(:index)
          expect(assigns(:contacts)).to match_array([smith, jones])
        end

        it "renders the :index template" do
          get(:index)
          expect(response).to render_template(:index)
        end
      end #End context without params
    end #End describe GET #index

    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        get(:show, id: contact)
        expect(assigns(:contact)).to eq(contact)
      end

      it "renders the :show template" do
        get(:show, id: contact)
        expect(response).to render_template(:show)
      end
    end #End describe GET #show
  end #End shared_examples public access to contacts


  #********** Creating/Editing Access **********#
  shared_examples 'full access to contacts' do

    describe 'GET #new' do
      it "assigns a new Contact to @contact" do
        get(:new)
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it "renders the :new template" do
        get(:new)
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #edit' do
      it "assigns the requested contact to @contact" do
        get(:edit, id: contact)
        expect(assigns(:contact)).to eq(contact)
      end

      it "renders the :edit template" do
        get(:edit, id: contact)
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end

      context "with valid attributes" do
        it "saves the new contact in the database" do
          expect{
            post(
              :create,
              contact: attributes_for(
                :contact,
                phones_attributes: @phones
          ))
          }.to change(Contact, :count).by(1)
        end

        it "redirects to contacts#show" do
          post(
            :create,
            contact: attributes_for(
              :contact,
              phones_attributes: @phones
          ))
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect{
            post(
              :create,
              contact: attributes_for(:invalid_contact)
            )
          }.not_to change(Contact, :count)
        end

        it "re-renders the :new template" do
          post(
            :create,
            contact: attributes_for(:invalid_contact)
          )
          expect(response).to render_template(:new)
        end
      end #End context with invalid attributes
    end #End POST #create

    describe 'PATCH #update' do
      before(:each) do
        @contact = fk_full('Lawrence', 'Smith')
      end

      context "valid attributes" do
        it "locates the requested @contact" do
          patch(
            :update,
            id: @contact,
            contact: attributes_for(:contact)
          )
          expect(assigns(:contact)).to eq(@contact)
        end

        it "changes @contact's attributes" do
          patch(
            :update,
            id: @contact,
            contact: attributes_for(
              :contact,
              firstname: 'Larry',
              lastname: 'Smith'
          ))
          @contact.reload
          expect(@contact.firstname).to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end

        it "redirects to the updated contact" do
          patch(
            :update,
            id: @contact,
            contact: attributes_for(:contact)
          )
          expect(response).to redirect_to(@contact)
        end
      end

      context "with invalid attributes" do
        it "does not change the contact's attributes" do
          patch(
            :update,
            id: @contact,
            contact: attributes_for(
              :contact,
              firstname: 'Larry',
              lastname: nil
          ))
          @contact.reload
          expect(@contact.firstname).not_to eq('Larry')
          expect(@contact.lastname).to eq('Smith')
        end

        it "re-renders the edit template" do
          patch(
            :update,
            id: @contact,
            contact: attributes_for(:invalid_contact)
          )
          expect(response).to render_template(:edit)
        end
      end #End context with invalid attributes
    end #End describe PATCH #update

    describe 'DELETE #destroy' do
      it "deletes the contact" do
        contact
        expect {
          delete(:destroy, id: contact)
        }.to change(Contact,:count).by(-1)
      end

      it "redirects to contacts#index" do
        delete(:destroy, id: contact)
        expect(response).to redirect_to(contacts_url)
      end
    end #End describe DELETE #destroy
  end #End shared_examples full access to contacts


  #********** Administrators **********#
  describe "administrator access" do
    before :each do
      set_user_session(create(:admin))
    end

    it_behaves_like("public access to contacts")
    it_behaves_like("full access to contacts")
  end


  #********** Users **********#
  describe "user access" do
    before :each do
      set_user_session(create(:user))
    end

    it_behaves_like("public access to contacts")
    it_behaves_like("full access to contacts")
  end


  #********** Guests **********#
  describe "guest access" do
    it_behaves_like("public access to contacts")

    describe 'GET #new' do
      it "requires login" do
        get(:new)
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it "requires login" do
        get(:edit, id: contact)
        expect(response).to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        post(
          :create,
          id: contact,
          contact: attributes_for(:contact)
        )
        expect(response).to require_login
      end
    end

    describe 'PUT #update' do
      it "requires login" do
        put(
          :update,
          id: contact,
          contact: attributes_for(:contact)
        )
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete(:destroy, id: contact)
        expect(response).to require_login
      end
    end
  end #End guest access

end
