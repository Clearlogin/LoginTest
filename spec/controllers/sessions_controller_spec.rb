require 'rails_helper'

describe SessionsController do
  let(:username) { 'dhh' }
  let(:password) { 'rails is great' }
  let(:user) { FactoryBot.create(:user, username: username, password: password)}
  let(:ip_address) { '192.168.1.1' }
  
  let(:params) do
    {
      user: {
          username: user.username, 
          password: password
        }
    }
  end

  let(:invalid_params) do
   {
      user: {
          username: user.username, 
          password: 'wrong_password'
        }
    }
  end
  
  describe 'create' do
    context 'invalid user' do
      subject { post :create, invalid_params }
      it 'returns http status :unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders the login screen again' do
        subject
        expect(response.body).to match(/Sign into Test Login/)
        expect(response.body).to match(/user_username/)
        expect(response.body).to match(/user_password/)
      end
      
    end # context 'invalid user'

    context 'valid user' do
      subject { post :create, params }
      it 'returns http status :found' do
        subject
        expect(response).to have_http_status(:found)
      end

      it 'redirects to home' do
        expect(subject).to redirect_to('/')
      end
    end # context 'valid user'
  end
end

