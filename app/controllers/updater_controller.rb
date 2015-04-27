class UpdaterController < ApplicationController
  include ActionController::Live

  def msg
    response.headers['Content-Type'] = 'text/event-stream'
    Message.connection.execute "LISTEN new_message_available"
    loop do
      Message.connection.raw_connection.wait_for_notify do |channel, pid, payload|
        response.stream.write(sse({message: payload}, {event: 'new_message_available'}))
      end
    end
  rescue IOError
    # client disconnected
  ensure
    response.stream.close
  end


  private
    def sse(object, options = {})
      (options.map{|k,v| "#{k}: #{v}" } << "data: #{JSON.dump object}").join("\n") + "\n\n"
    end
end
