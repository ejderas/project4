require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should allow users to create comments on grams" do
      gram = FactoryBot.create(:gram) #creating a gram in the db


      user = FactoryBot.create(:user) #creating a user in the db
      sign_in user #user signs in


      post :create, params: { gram_id: gram.id, comment: { message: 'awesome gram' } }
      #triggers a gram to the create action and specifies a message of "awesome gram"


      expect(response).to redirect_to root_path 
      #server's response should be a redirect to the root path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq "awesome gram"
      #ensure a single comment had been created in the db w/message "awesome gram"
    end

    it "should require a user to be logged in to comment on a gram" do
      gram = FactoryBot.create(:gram) #create gram in db
      #no user needs to be logged in because we're testing non-logged in users
      post :create, params: { gram_id: gram.id, comment: { message: 'awesome gram' } }
      #triggers a gram to the create action with a specific message
      expect(response).to redirect_to new_user_session_path
      #redirects user to sign in page
    end

    it "should return http status code of not found if the gram isn't found" do
      user = FactoryBot.create(:user)
      sign_in user 
      #creates a user in the db
      post :create, params: { gram_id: 'YOLOSWAG', comment: { message: 'awesome gram' } }
      #triggers a gram to the create action with a specific message
      #but the gram_id is non existant
      expect(response).to have_http_status :not_found
      #server responds with the HTTP Response of 404 Not Found
    end
  end

end
