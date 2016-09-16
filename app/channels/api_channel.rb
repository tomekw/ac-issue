class ApiChannel < ApplicationCable::Channel
  def subscribed
    stream_from("api:#{SecureRandom.uuid}")

    # It looks like broadcasting in subscribe block
    # causes the issue. Moving this code to the background
    # i. e. Celluloid::Future "solves" the issue.
    20.times do
      ActionCable.server.broadcast("api:#{SecureRandom.uuid}", subscribe: true)
    end
  end

  def foo
    ActionCable.server.broadcast("api:#{SecureRandom.uuid}", foo: true)
  end

  protected

  def extract_action(_data)
    "foo"
  end
end
