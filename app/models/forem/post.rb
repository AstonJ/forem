module Forem
  class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user, :class_name => Forem.user_class.to_s
    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent => :nullify

    delegate :forum, :to => :topic

    scope :by_created_at, order("created_at asc")

    validates :text, :presence => true
    after_create :send_subscription_emails
    
    def send_subscription_emails
       (self.topic.subscriptions - [self.user]).each do |user|
        Notifier.post_made_in_topic(self.topic, self.user).deliver
      end
    end

    def owner_or_admin?(other_user)
      self.user == other_user || other_user.forem_admin?
    end
  end
end
