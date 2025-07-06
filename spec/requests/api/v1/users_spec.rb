require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/{id}/authenticate_form' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('authenticate form') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/authenticate' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    post('authenticate user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        let(:user) { { email: 'test@example.com', password: 'password' } }
        run_test!
      end
    end
  end

  path '/api/v1/users' do
    get('list users') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   email: { type: :string }
                 },
                 required: [ 'id', 'name', 'email' ]
               }

        run_test!
      end
    end

    post('create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: [ 'name', 'email', 'password', 'password_confirmation' ]
      }

      response(201, 'created') do
        let(:user) { { name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        run_test!
      end
    end

    patch('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        let(:user) { { name: 'updateduser' } }
        run_test!
      end
    end

    put('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
        }
      }

      response(200, 'successful') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        let(:user) { { name: 'anotherupdateduser' } }
        run_test!
      end
    end

    delete('delete user') do
      tags 'Users'

      response(204, 'no content') do
        let(:id) { User.create(name: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password').id }
        run_test!
      end
    end
  end
end
