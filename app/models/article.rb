class Article < ApplicationRecord
    include Visible

    has_many :comments, dependent: :destroy
    has_rich_text :content
    
    validates :title, presence: true
    validates :content, presence: true, length: {minimum: 10}
    validates :user_id, presence: true

    def user
        return User.find_by(id: self.user_id)
    end
end
