require 'rails_helper'

RSpec.describe "/books", type: :request do
  let(:json_headers) do
    { CONTENT_TYPE: 'application/json' }
  end

  let!(:subject) { create(:book) }

  describe 'GET /books' do
    it 'renders a successful response' do
      get books_url
      expect(response).to have_http_status(:success)
    end

    it 'render all books' do
      create_list(:book, 3)

      get books_path(format: :json)
      json_response = response.parsed_body

      expect(json_response.count).to eq(4)
      expect(json_response.first['title']).to eq(subject.title)  
    end
  end

  describe 'GET /books/:id' do
    it 'renders a successful response' do
      get book_path(subject, format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'renders a Book info' do
      get book_path(subject, format: :json)
      json_response = response.parsed_body
      
      expect(json_response['title']).to eq(subject.title)
    end
  end

  describe 'POST /books' do
    let!(:author) { create(:author) }
    let!(:genre) { create(:genre) }

    context 'with valid params' do
      let(:title) { 'JavaScript, the Good Parts' }
      let(:isbn) { '1111111111111' }
      let(:valid_params) do
        {
          book: {
            title: title,
            isbn: isbn,
            author_id: author.id,
            genre_id: genre.id
          }
        }.to_json
      end

      it 'must create a new Book' do
        post books_path, params: valid_params, headers: json_headers
        json_response = response.parsed_body

        expect(response).to have_http_status(:success)
        expect(json_response['title']).to eq(title)
        expect(json_response['isbn']).to eq(isbn)
        expect(json_response['genre_id']).to eq(genre.id)
        expect(json_response['author_id']).to eq(author.id)
      end
    end

    context 'with invalid params' do
      let(:title) { 'JavaScript, the Good Parts' }
      let(:invalid_params) do
        {
          book: {
            title: title,
            isbn: '123456789',
            author_id: author.id,
            genre_id: genre.id
          }
        }.to_json
      end

      it 'do not crete a Book and response with 422 status' do
        post books_path, params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity)  
      end
    end
  end

  describe 'PATCH /books/:id' do
    context 'with valid params' do
      let(:new_title) { 'The Ruby handbook' }
      let(:valid_params) do
        {
          book: {
            id: subject.id,
            title: new_title
          }
        }.to_json
      end

      it 'must updates the requested Book' do
        patch book_path(subject, format: :json), params: valid_params, headers: json_headers
        json_response = response.parsed_body
        subject.reload

        expect(response).to have_http_status(:success)
        expect(json_response['title']).to eq(new_title)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          book: {
            id: subject.id,
            isbn: '111111011111111110111110111'
          }
        }.to_json
      end

      it 'do not update Book and response with 422 status' do
        patch book_path(subject, format: :json), params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'DELETE /authors/:id' do
    let!(:subject_to_destroy) { create(:book, title: 'To Destroy') }

    it 'must destroy the requested book' do
      delete book_path(subject_to_destroy), headers: json_headers
      expect(response).to have_http_status(:success)
      expect(Book.find_by_title('To Destroy')).to be_nil
    end
  end
end
