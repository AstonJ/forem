module Forem
  class Notifier < ActionMailer::Base
    default from: "from@example.com"
  
    def post_made_in_topic(topic, user)
      mail(:to => user.email,
           :subject => "Someone replied to: #{topic.name}")
    end
  end
end
