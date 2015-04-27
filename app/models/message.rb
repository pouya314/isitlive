class Message < ActiveRecord::Base
  after_save :notify_about_new_message

  def notify_about_new_message
    self.class.connection.execute "NOTIFY new_message_available, #{self.class.connection.quote self.body}"
  end

  # def self.on_new_message
    # self.class.connection.execute "LISTEN #{channel}"
    # loop do
    #   self.class.connection.raw_connection.wait_for_notify do |event, pid, msg|
    #     puts "AHA! got the notification."
    #     yield msg
    #   end
    # end
  # ensure
  #   self.class.connection.execute "UNLISTEN #{channel}"
  # end

  # private
  #   def channel
  #     "new_message_available"
  #   end
end
