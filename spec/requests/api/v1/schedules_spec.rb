require 'swagger_helper'

RSpec.describe 'api/v1/schedules', type: :request do
  path '/api/v1/schedules/show_by_date' do
    get('show schedule by date') do
      tags 'Schedules'
      produces 'application/json'
      parameter name: :date, in: :query, type: :string, description: 'date'

      response(200, 'successful') do
        let(:date) { '2025-01-01' }
        run_test!
      end
    end
  end

  path '/api/v1/schedules' do
    get('list schedules') do
      tags 'Schedules'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   event: { type: :string },
                   start_time: { type: :string, format: :datetime },
                   start_date: { type: :string, format: :date },
                   finish_date: { type: :string, format: :date },
                   end_time: { type: :string, format: :datetime },
                   user_id: { type: :integer },
                   number: { type: :integer },
                   regular_schedule: { type: :boolean }
                 },
                 required: [ 'id', 'name', 'event', 'start_time', 'start_date', 'finish_date', 'end_time', 'user_id', 'number', 'regular_schedule' ]
               }

        run_test!
      end
    end

    post('create schedule') do
      tags 'Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :schedule, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          event: { type: :string },
          start_time: { type: :string, format: :datetime },
          start_date: { type: :string, format: :date },
          finish_date: { type: :string, format: :date },
          end_time: { type: :string, format: :datetime },
          user_id: { type: :integer },
          number: { type: :integer },
          regular_schedule: { type: :boolean }
        },
        required: [ 'name', 'event', 'start_time', 'start_date', 'finish_date', 'end_time', 'user_id', 'number', 'regular_schedule' ]
      }

      response(201, 'created') do
        let(:schedule) { { name: 'Test Schedule', event: 'Test Event', start_time: '2025-01-01T09:00:00Z', start_date: '2025-01-01', finish_date: '2025-01-01', end_time: '2025-01-01T17:00:00Z', user_id: 1, number: 1, regular_schedule: false } }
        run_test!
      end
    end
  end

  path '/api/v1/schedules/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show schedule') do
      tags 'Schedules'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { Schedule.create(name: 'Test Schedule', event: 'Test Event', start_time: '2025-01-01T09:00:00Z', start_date: '2025-01-01', finish_date: '2025-01-01', end_time: '2025-01-01T17:00:00Z', user_id: 1, number: 1, regular_schedule: false).id }
        run_test!
      end
    end

    patch('update schedule') do
      tags 'Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :schedule, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          event: { type: :string },
          start_time: { type: :string, format: :datetime },
          start_date: { type: :string, format: :date },
          finish_date: { type: :string, format: :date },
          end_time: { type: :string, format: :datetime },
          user_id: { type: :integer },
          number: { type: :integer },
          regular_schedule: { type: :boolean }
        }
      }

      response(200, 'successful') do
        let(:id) { Schedule.create(name: 'Test Schedule', event: 'Test Event', start_time: '2025-01-01T09:00:00Z', start_date: '2025-01-01', finish_date: '2025-01-01', end_time: '2025-01-01T17:00:00Z', user_id: 1, number: 1, regular_schedule: false).id }
        let(:schedule) { { name: 'Updated Schedule', start_time: '2025-01-01T10:00:00Z' } }
        run_test!
      end
    end

    put('update schedule') do
      tags 'Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :schedule, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          event: { type: :string },
          start_time: { type: :string, format: :datetime },
          start_date: { type: :string, format: :date },
          finish_date: { type: :string, format: :date },
          end_time: { type: :string, format: :datetime },
          user_id: { type: :integer },
          number: { type: :integer },
          regular_schedule: { type: :boolean }
        }
      }

      response(200, 'successful') do
        let(:id) { Schedule.create(name: 'Test Schedule', event: 'Test Event', start_time: '2025-01-01T09:00:00Z', start_date: '2025-01-01', finish_date: '2025-01-01', end_time: '2025-01-01T17:00:00Z', user_id: 1, number: 1, regular_schedule: false).id }
        let(:schedule) { { name: 'Another Updated Schedule', start_time: '2025-01-01T11:00:00Z' } }
        run_test!
      end
    end

    delete('delete schedule') do
      tags 'Schedules'

      response(204, 'no content') do
        let(:id) { Schedule.create(name: 'Test Schedule', event: 'Test Event', start_time: '2025-01-01T09:00:00Z', start_date: '2025-01-01', finish_date: '2025-01-01', end_time: '2025-01-01T17:00:00Z', user_id: 1, number: 1, regular_schedule: false).id }
        run_test!
      end
    end
  end
end

