class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true

    def articles
        return Article.where(user_id: self.id)
    end

    def articles_public
        return Article.where(user_id: self.id, status: "public")
    end
end
