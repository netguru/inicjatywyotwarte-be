# frozen_string_literal: true

shared_examples 'returns 200' do
  it 'responds with HTTP OK' do
    subject
    expect(response).to have_http_status(:ok)
  end
end

shared_examples 'returns 201' do
  it 'responds with HTTP CREATED' do
    subject
    expect(response).to have_http_status(:created)
  end
end

shared_examples 'returns 400' do
  it 'responds with HTTP BAD REQUEST' do
    subject
    expect(response).to have_http_status(:bad_request)
  end

  it 'returns proper response body' do
    subject
    expect(response_json).to eq(expected_json)
  end
end

shared_examples 'returns 401' do
  it 'responds with HTTP UNAUTHORIZED' do
    subject
    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples 'returns 403' do
  it 'responds with HTTP FORBIDDEN' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  let(:expected_json) do
    {
      errors: [
        {
          code: 'forbidden',
          detail: 'this action is forbidden'
        }
      ]
    }
  end

  it 'returns proper response body' do
    subject
    expect(response_json).to eq(expected_json)
  end
end

shared_examples 'returns 404' do
  it 'responds with HTTP NOT FOUND', aggregate_failures: true do
    subject
    expect(response).to have_http_status(:not_found)
  end

  let(:expected_json) do
    {
      errors: [
        {
          code: 'not_found',
          detail: 'the specified resource couldn\'t be found'
        }
      ]
    }
  end

  it 'returns proper response body' do
    subject
    expect(response_json).to eq(expected_json)
  end
end

shared_examples 'returns 422' do
  it 'responds with UNPROCESSABLE ENTITY' do
    subject
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'returns proper response body' do
    subject
    expect(response_json).to eq(expected_json)
  end
end

shared_examples 'returns 500' do
  it 'responds with HTTP INTERNAL SERVER ERROR' do
    subject
    expect(response).to have_http_status(:internal_server_error)
  end
end
