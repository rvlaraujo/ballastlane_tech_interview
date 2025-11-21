require 'rails_helper'

RSpec.describe "/genders", type: :request do
  let(:json_headers) do
    { CONTENT_TYPE: 'application/json' }
  end

  let(:model) { create(:gender, name: 'Action') }
  let(:other_genders) { create_list(:gender, 3) }

  describe 'GET /genders' do
    it 'renders a successful response' do
      get genders_url
      expect(response).to have_http_status(:success)  
    end

    it 'renders all genders' do
      get genders_path(format: :json)
      expect(response.parsed_body.count).to eq(Gender.count) 
    end
  end

  describe 'GET /genders/:id' do
    it 'renders a successful response' do
      get gender_path(model, format: :json)
      expect(response).to have_http_status(:success)
    end

    it 'renders a gender info' do
      get gender_path(model, format: :json)
      expect(response.parsed_body['name']).to eq(model.name) 
    end
  end

  describe 'POST /genders' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          gender: {
            name: 'Action'
          }
        }.to_json
      end

      it 'must create a new Gender' do
        post genders_url, params: valid_params, headers: json_headers
        
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['name']).to eq('Action'.upcase) 
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          gender: {
            name: nil
          }
        }.to_json
      end

      it 'do not create a Gender and response with 422 status' do
        post genders_url, params: invalid_params, headers: json_headers
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe 'PATCH /genders/:id' do
    context 'with valid params' do
      let(:new_gender_name) { 'Drama' }
      let(:valid_params) do
        {
          gender: {
            id: model.id,
            name: new_gender_name
          }
        }.to_json
      end

      it 'updates the requested Gender' do
        patch gender_path(model, format: :json), params: valid_params, headers: json_headers
        expect(response).to have_http_status(:success)
        model.reload
        expect(response.parsed_body['name']).to eq(new_gender_name.upcase)
        expect(model.name).to eq(new_gender_name.upcase)
      end
    end
  end

  describe 'DELETE /genders/:id' do
    let!(:model_to_destroy) { create(:gender, name: 'To Destroy') }

    context 'when Gender have no associated books' do
      it 'must destroy the requested Gender' do
        delete gender_path(model_to_destroy), headers: json_headers
        expect(response).to have_http_status(:success)
        expect(Gender.find_by_name('To Destroy')).to be_nil
      end
    end

  end
end
