# spec/requests/events_spec.rb
require 'rails_helper'

RSpec.describe 'Events API' do
  # Initialize the test data
  let!(:user) { create(:user) }
  let!(:events) { create_list(:event, 20, user_id: user.id, start_at: Date.today, duration: 30) }
  let(:user_id) { user.id }
  let(:id) { events.first.id }

  # Test suite for GET /users/:user_id/events
  describe 'GET /users/:user_id/events' do
    before { get "/users/#{user_id}/events" }

    context 'when user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user events' do
        expect(json.size).to eq(20)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for GET /users/:user_id/events/:id
  describe 'GET /users/:user_id/events/:id' do
    before { get "/users/#{user_id}/events/#{id}" }

    context 'when user event exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the event' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user event does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/events
  describe 'POST /users/:user_id/events' do
    let(:valid_attributes) { { name: 'Visit Narnia', description: 'Local Weeding', duration: 10, start_at: Date.today } }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/events", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request attributes are valid but not completed' do
      before { post "/users/#{user_id}/events", params: valid_attributes.merge(status: 'published') }

      it 'saves draft status' do
        event = Event.last 
        expect(event.status).to eq('draft')
      end
    end

    context 'when an invalid request' do
      before { post "/users/#{user_id}/events", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end

    # Specific validation
    context 'when an invalid request with some valid params' do
      before { post "/users/#{user_id}/events", params: { name: 'Vicente'} }

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: More data is needed to establish a duration. At least two values ​​of start_at, end_at or duration./)
      end
    end
  end
  
  # Test suite for PUT /users/:user_id/events/:id
  describe 'PUT /users/:user_id/events/:id' do
    let(:valid_attributes) { { name: 'Mozart', start_at: Date.today } }

    before { put "/users/#{user_id}/events/#{id}", params: valid_attributes }

    context 'when event exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the event' do
        updated_event = Event.find(id)
        expect(updated_event.name).to match(/Mozart/)
      end

      it 'updates dates from start_at' do
        updated_event = Event.find(id)
        expect(updated_event.end_at).to eq(Date.today + 30)
      end
    end

    context 'when the event does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}/events/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'softdelete user' do
      event = Event.find_by(id: user_id)
      expect(event).to eq(nil)
    end

    it 'updated delete_at for user' do
      event = Event.unscoped.find_by(id: user_id)
      expect(event.deleted_at.to_date.to_s).to eq(Time.now.to_date.to_s)
    end
  end
end