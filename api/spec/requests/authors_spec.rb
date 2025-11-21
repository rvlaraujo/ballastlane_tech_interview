require 'rails_helper'

RSpec.describe "/authors", type: :request do
  let(:json_headers) do
    { CONTENT_TYPE: 'application/json' }
  end

  let!(:subject) { create(:author) }

  describe 'GET /authors' do
    it 'renders a successful response' do
      get authors_url
      expect(response).to have_http_status(:success)  
    end

    it 'renders all authors' do
      genre = create(:genre)
      create_list(:book, 3, author: subject, genre: genre)

      get authors_path(format: :json)
      json_response = response.parsed_body
     
      expect(response.parsed_body.count).to eq(Author.count)
      expect(json_response.first['books'].count).to eq(3)
    end
  end

  describe 'GET /authors/:id' do
    it 'renders a successful response' do
      get author_path(subject, format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'renders a author info' do
      genre = create(:genre)
      create_list(:book, 3, author: subject, genre: genre)

      get author_path(subject, format: :json)
      
      json_response = response.parsed_body
      expect(json_response['name']).to eq(subject.name)
      expect(json_response['books'].count).to eq(3)
    end
  end

  describe 'POST /authors' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          author: {
            name: 'JJ Abrams'
          }
        }.to_json
      end

      it 'must create a new author' do
        post authors_url, params: valid_params, headers: json_headers
        
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['name']).to eq('JJ Abrams'.upcase) 
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          author: {
            name: nil
          }
        }.to_json
      end

      it 'do not create a author and response with 422 status' do
        post authors_url, params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'PATCH /authors/:id' do
    context 'with valid params' do
      let(:new_author_name) { 'Drama' }
      let(:valid_params) do
        {
          author: {
            id: subject.id,
            name: new_author_name
          }
        }.to_json
      end

      it 'updates the requested author' do
        patch author_path(subject, format: :json), params: valid_params, headers: json_headers
        expect(response).to have_http_status(:success)
        subject.reload
        expect(response.parsed_body['name']).to eq(new_author_name.upcase)
        expect(subject.name).to eq(new_author_name.upcase)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          author: {
            id: subject.id,
            name: 'AB'
          }
        }.to_json
      end

      it 'do not update Author and response with 422 status' do
        patch author_path(subject, format: :json), params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'DELETE /authors/:id' do
    let!(:subject_to_destroy) { create(:author, name: 'To Destroy') }

    context 'when author have no associated books' do
      it 'must destroy the requested author' do
        delete author_path(subject_to_destroy), headers: json_headers
        expect(response).to have_http_status(:success)
        expect(Author.find_by_name('To Destroy'.upcase)).to be_nil
      end
    end
  end
end
