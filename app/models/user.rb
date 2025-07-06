class User < ApplicationRecord
    has_secure_password

    validates :name, { presence: true }
    validates :email, { presence: true, uniqueness: true }
    validates :password, { presence: true }
    def self.user_create(params)
        return :not_found unless params
        begin
            new_user = nil
            ActiveRecord::Base.transaction do
                new_user = User.create!(
                    params.merge(
                        name: params[:name],
                        email: params[:email],
                        password: params[:password]
                    )
                )
            end
            new_user
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("ユーザー作成失敗: #{params.inspect}, error: #{e.message}")
            nil # 失敗時に nil を返す
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            nil # 失敗時に nil を返す
        end
    end
    def self.user_update(params, user)
      return :not_found unless params && user
        begin
            ActiveRecord::Base.transaction do
              user.update!(
                name: params[:name],
                email: params[:email],
                password: params[:password]
              )
            end
            user
        rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("ユーザー更新失敗: #{params.inspect}, error: #{e.message}")
            nil # 失敗時に nil を返す
        rescue => e
            Rails.logger.error("予期しないエラー: #{params.inspect}, error: #{e.message}")
            nil # 失敗時に nil を返す
        end
    end
end
