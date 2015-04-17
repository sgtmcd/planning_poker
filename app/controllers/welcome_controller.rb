class WelcomeController < ApplicationController
  include Tubesock::Hijack

  respond_to :json, only: [:vote]
  def index
  end

  def new_round
    Developer.destroy_all
    render :index
  end

  def vote
    hijack do |tubesock|
      # Listen on its own thread
      redis_thread = Thread.new do
        # Needs its own redis connection to pub
        # and sub at the same time
        Redis.new.subscribe "chat" do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        # pub the message when we get one
        # note: this echoes through the sub above
        Redis.new.publish "chat", m
      end
      
      tubesock.onclose do
        # stop listening when client leaves
        redis_thread.kill
      end
    end
  end
end
