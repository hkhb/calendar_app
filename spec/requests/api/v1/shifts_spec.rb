require 'swagger_helper'

RSpec.describe 'api/v1/shifts', type: :request do
  path '/api/v1/shifts' do
    get('list shifts') do
      tags 'Shifts'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   date: { type: :string, format: :date },
                   number: { type: :integer },
                   user_id: { type: :integer },
                   name: { type: :string }
                 },
                 required: [ 'id', 'date', 'number', 'user_id', 'name' ]
               }

        run_test!
      end
    end

    post('create shift') do
      tags 'Shifts'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :shift, in: :body, schema: {
        type: :object,
        properties: {
          date: { type: :string, format: :date },
          number: { type: :integer },
          user_id: { type: :integer },
          name: { type: :string }
        },
        required: [ 'date', 'number', 'user_id', 'name' ]
      }

      response(201, 'created') do
        let(:shift) { { date: '2025-01-01', number: 1, user_id: 1, name: 'Test Shift' } }
        run_test!
      end
    end
  end

  path '/api/v1/shifts/destroy_month' do
    delete('delete shifts by month') do
      tags 'Shifts'
      parameter name: :month, in: :query, type: :string, description: 'month'

      response(204, 'no content') do
        let(:month) { '2025-01' }
        run_test!
      end
    end
  end

  path '/api/v1/shifts/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show shift') do
      tags 'Shifts'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { Shift.create(date: '2025-01-01', number: 1, user_id: 1, name: 'Test Shift').id }
        run_test!
      end
    end

    patch('update shift') do
      tags 'Shifts'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :shift, in: :body, schema: {
        type: :object,
        properties: {
          date: { type: :string, format: :date },
          number: { type: :integer },
          user_id: { type: :integer },
          name: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { Shift.create(date: '2025-01-01', number: 1, user_id: 1, name: 'Test Shift').id }
        let(:shift) { { name: 'Updated Shift' } }
        run_test!
      end
    end

    put('update shift') do
      tags 'Shifts'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :shift, in: :body, schema: {
        type: :object,
        properties: {
          date: { type: :string, format: :date },
          number: { type: :integer },
          user_id: { type: :integer },
          name: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { Shift.create(date: '2025-01-01', number: 1, user_id: 1, name: 'Test Shift').id }
        let(:shift) { { name: 'Another Updated Shift' } }
        run_test!
      end
    end

    delete('delete shift') do
      response(204, 'no content') do
        let(:id) { Shift.create(date: '2025-01-01', number: 1, user_id: 1, name: 'Test Shift').id }
        run_test!
      end
    end
  end
end





