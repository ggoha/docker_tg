class TestTelegramController < Telegram::Bot::UpdatesController
  # use callbacks like in any other controllers
  around_action :with_locale

  def message(message)
    # message can be also accessed via instance method
    message == self.payload # true
    # store_message(message['text'])
  end

  def start!(data = nil, *)
    # do_smth_with(data)

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` if taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'
    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response
  end

  private

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      # locale for user
    elsif chat
      # locale for chat
    end
  end
end
