require 'rails_helper'

RSpec.describe NewsReleasesController, :type => :controller do

  let(:news_release) do
    create(:news_release)
  end


  shared_examples "public access to index/show" do
    describe "GET index" do
      it "assigns all news_releases as @news_releases" do
        get(:index)
        expect(assigns(:news_releases)).to eq([news_release])
      end
    end

    describe "GET show" do
      it "assigns the requested news_release as @news_release" do
        get(:show, :id => news_release)
        expect(assigns(:news_release)).to eq(news_release)
      end
    end
  end #End shared_examples "public access to index/show"



  shared_examples "private access to new/edit/delete" do
    describe "GET new" do
      it "assigns a new news_release as @news_release" do
        get(:new)
        expect(assigns(:news_release)).to be_a_new(NewsRelease)
      end
    end

    describe "GET edit" do
      it "assigns the requested news_release as @news_release" do
        get(:edit, :id => news_release)
        expect(assigns(:news_release)).to eq(news_release)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new NewsRelease" do
          expect {
            post(
              :create,
              news_release: attributes_for(:news_release)
            )
          }.to change(NewsRelease, :count).by(1)
        end

        it "assigns a newly created news_release as @news_release" do
          post(
            :create,
            news_release: attributes_for(:news_release)
          )
          expect(assigns(:news_release)).to be_a(NewsRelease)
          expect(assigns(:news_release)).to be_persisted
        end

        it "redirects to the index template" do
          post(
            :create,
            news_release: attributes_for(:news_release)
          )
          expect(response).to redirect_to(news_releases_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved news_release as @news_release" do
          post(
            :create,
            news_release: attributes_for(:invalid_news_release)
          )
          expect(assigns(:news_release)).to be_a_new(NewsRelease)
        end

        it "re-renders the 'new' template" do
          post(
            :create,
            news_release: attributes_for(:invalid_news_release)
          )
          expect(response).to render_template("new")
        end
      end #End describe "with invalid params"
    end #End post

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          attributes_for(
            :news_release,
            title: "Second Fake News Release",
            body: "Different, more sexy body."
          )
        }

        it "updates the requested news_release" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          news_release.reload
          expect(news_release.title).to eq("Second Fake News Release")
          expect(news_release.body).to eq("Different, more sexy body.")
        end

        it "assigns the requested news_release as @news_release" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          expect(assigns(:news_release)).to eq(news_release)
        end

        it "redirects to the news_release" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          expect(response).to redirect_to(news_release)
        end
      end

      describe "with invalid params" do
        let(:new_attributes) {
          attributes_for(
            :news_release,
            title: nil,
            body: "Different, more sexy body."
          )
        }

        it "does not update the requested news_release" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          news_release.reload
          expect(news_release.body).not_to eq("Different, more sexy body.")
        end

        it "assigns the news_release as @news_release" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          expect(assigns(:news_release)).to eq(news_release)
        end

        it "re-renders the 'edit' template" do
          put(
            :update,
            :id => news_release,
            :news_release => new_attributes
          )
          expect(response).to render_template("edit")
        end
      end #End describe "with invalid params"
    end #End PATCH #update

    describe "DELETE destroy" do
      it "destroys the requested news_release" do
        news_release
        expect {
          delete(:destroy, :id => news_release)
        }.to change(NewsRelease, :count).by(-1)
      end

      it "redirects to the news_releases list" do
        news_release
        delete(:destroy, :id => news_release)
        expect(response).to redirect_to(news_releases_url)
      end
    end #End describe "DELETE destroy"
  end #End shared_examples "private access to new/edit/delete"



  describe "administrator access" do
    before(:each) do
      set_user_session(create(:admin))
    end

    it_behaves_like("public access to index/show")
    it_behaves_like("private access to new/edit/delete")
  end



  describe "user access" do
    before(:each) do
      set_user_session(create(:user))
    end

    it_behaves_like("public access to index/show")
    it_behaves_like("private access to new/edit/delete")
  end



  describe "guest access" do
    it_behaves_like("public access to index/show")

    describe "GET new" do
      it "requires login" do
        get(:new)
        expect(response).to require_login
      end
    end

    describe "GET edit" do
      it "requires login" do
        get(:edit, id: news_release)
        expect(response).to require_login
      end
    end

    describe "POST create" do
      it "requires login" do
        post(
          :create,
          news_release: attributes_for(:news_release)
        )
        expect(response).to require_login
      end
    end

    describe "PUT update" do
      it "requires login" do
        put(
          :update,
          id: news_release,
          contact: attributes_for(:news_release)
        )
        expect(response).to require_login
      end
    end

    describe "DELETE destroy" do
      it "requires login" do
        delete(:destroy, id: news_release)
        expect(response).to require_login
      end
    end
  end #End describe "guest access"

end

