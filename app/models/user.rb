class User < ApplicationRecord
    has_secure_password

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    def articles
        return Article.where(user_id: self.id)
    end

    def articles_public
        return Article.where(user_id: self.id, status: "public").order(created_at: :desc)
    end
end
