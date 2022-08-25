class Article < ApplicationRecord
    include Visible

    has_many :comments, dependent: :destroy
    
    validates :title, presence: true
    validates :content, presence: true, length: {minimum: 10}
    validates :user_id, presence: true

    def user
        return User.find_by(id: self.user_id)
    end

    def articles_owned
        return Article.where(user_id: self.id)
    end
end
