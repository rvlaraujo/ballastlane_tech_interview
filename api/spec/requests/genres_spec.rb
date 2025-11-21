require 'rails_helper'

RSpec.describe "/genres", type: :request do
  let(:json_headers) do
    { CONTENT_TYPE: 'application/json' }
  end

  let(:subject) { create(:genre, name: 'Action') }
  let(:other_genres) { create_list(:genre, 3) }

  describe 'GET /genres' do
    it 'renders a successful response' do
      get genres_url
      expect(response).to have_http_status(:success)  
    end

    it 'renders all genres' do
      author = create(:author)
      create_list(:book, 3, author: author, genre: subject)

      get genres_path(format: :json)
      json_response = response.parsed_body

      expect(json_response.count).to eq(Genre.count)
      expect(json_response.first['books'].count).to eq(3)
    end
  end

  describe 'GET /genres/:id' do
    it 'renders a successful response' do
      get genre_path(subject, format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'renders a Genre info' do
      author = create(:author)
      create_list(:book, 3, author: author, genre: subject)
      
      get genre_path(subject, format: :json)
      json_response = response.parsed_body
      
      expect(response.parsed_body['name']).to eq(subject.name)
      expect(json_response['books'].count).to eq(3)
    end
  end

  describe 'POST /genres' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          genre: {
            name: 'Action'
          }
        }.to_json
      end

      it 'must create a new Genre' do
        post genres_url, params: valid_params, headers: json_headers
        
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['name']).to eq('Action'.upcase) 
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          genre: {
            name: nil
          }
        }.to_json
      end

      it 'do not create a Genre and response with 422 status' do
        post genres_url, params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'PATCH /genres/:id' do
    context 'with valid params' do
      let(:new_genre_name) { 'Drama' }
      let(:valid_params) do
        {
          genre: {
            id: subject.id,
            name: new_genre_name
          }
        }.to_json
      end

      it 'updates the requested Genre' do
        patch genre_path(subject, format: :json), params: valid_params, headers: json_headers
        expect(response).to have_http_status(:success)
        subject.reload
        expect(response.parsed_body['name']).to eq(new_genre_name.upcase)
        expect(subject.name).to eq(new_genre_name.upcase)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          genre: {
            id: subject.id,
            name: nil
          }
        }.to_json
      end

      it 'do not update Genre and response with 422 status' do
        patch genre_path(subject, format: :json), params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'DELETE /genres/:id' do
    let!(:subject_to_destroy) { create(:genre, name: 'To Destroy') }

    context 'when Genre have no associated books' do
      it 'must destroy the requested Genre' do
        delete genre_path(subject_to_destroy), headers: json_headers
        expect(response).to have_http_status(:success)
        expect(Genre.find_by_name('To Destroy'.upcase)).to be_nil
      end
    end

  end
end
