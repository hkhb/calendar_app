require 'swagger_helper'

RSpec.describe 'api/v1/regular_schedules', type: :request do
  path '/api/v1/regular_schedules' do
    get('list regular_schedules') do
      tags 'Regular Schedules'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   day_of_week: { type: :string },
                   start_time: { type: :string, format: :time },
                   end_time: { type: :string, format: :time },
                   user_id: { type: :integer }
                 },
                 required: [ 'id', 'day_of_week', 'start_time', 'end_time', 'user_id' ]
               }

        run_test!
      end
    end

    post('create regular_schedule') do
      tags 'Regular Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :regular_schedule, in: :body, schema: {
        type: :object,
        properties: {
          day_of_week: { type: :string },
          start_time: { type: :string, format: :time },
          end_time: { type: :string, format: :time },
          user_id: { type: :integer }
        },
        required: [ 'day_of_week', 'start_time', 'end_time', 'user_id' ]
      }

      response(201, 'created') do
        let(:regular_schedule) { { name: 'Test Regular Schedule', event: 'Test Event', user_id: 1, number: 1, start_time: '09:00', days: 1, finish_time: '17:00' } }
        run_test!
      end
    end
  end

  path '/api/v1/regular_schedules/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show regular_schedule') do
      tags 'Regular Schedules'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { RegularSchedule.create(name: 'Test Regular Schedule', event: 'Test Event', user_id: 1, number: 1, start_time: '09:00', days: 1, finish_time: '17:00').id }
        run_test!
      end
    end

    patch('update regular_schedule') do
      tags 'Regular Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :regular_schedule, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          event: { type: :string },
          user_id: { type: :integer },
          number: { type: :integer },
          start_time: { type: :string, format: :time },
          days: { type: :integer },
          finish_time: { type: :string, format: :time }
        }
      }

      response(200, 'successful') do
        let(:id) { RegularSchedule.create(name: 'Test Regular Schedule', event: 'Test Event', user_id: 1, number: 1, start_time: '09:00', days: 1, finish_time: '17:00').id }
        let(:regular_schedule) { { name: 'Updated Regular Schedule', start_time: '10:00', finish_time: '18:00' } }
        run_test!
      end
    end

    put('update regular_schedule') do
      tags 'Regular Schedules'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :regular_schedule, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          event: { type: :string },
          user_id: { type: :integer },
          number: { type: :integer },
          start_time: { type: :string, format: :time },
          days: { type: :integer },
          finish_time: { type: :string, format: :time }
        }
      }

      response(200, 'successful') do
        let(:id) { RegularSchedule.create(name: 'Test Regular Schedule', event: 'Test Event', user_id: 1, number: 1, start_time: '09:00', days: 1, finish_time: '17:00').id }
        let(:regular_schedule) { { name: 'Another Updated Regular Schedule', start_time: '11:00', finish_time: '19:00' } }
        run_test!
      end
    end

    delete('delete regular_schedule') do
      tags 'Regular Schedules'

      response(204, 'no content') do
        let(:id) { RegularSchedule.create(name: 'Test Regular Schedule', event: 'Test Event', user_id: 1, number: 1, start_time: '09:00', days: 1, finish_time: '17:00').id }
        run_test!
      end
    end
  end
end
