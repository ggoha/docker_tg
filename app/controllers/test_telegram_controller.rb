class TestTelegramController < Telegram::Bot::UpdatesController
  # use callbacks like in any other controllers
  around_action :with_locale

  def start!(data = nil, *)
    # do_smth_with(data)

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` if taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'
    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response
  end

  def message(value)
    return unless value == "Выложить"

    if party[from["id"]].pop > @@min
      @@min = party[from["id"]].pop
      win if party.all? {|_key, value| value.empty? }
    else
      lose
    end
  end

  def join(*)
    party[from['id']] = [] 
  end

  def go(*)
    if party.count < 1
      respond_with :message, text: "Недостаточно игроков"
    else
      init
    end
  end

  private

  def init
    cards = (1..100).to_a.shuffle.each_slice(3).to_a
    keyboard = { keyboard: ['Выложить'], resize_keyboard: true }
    party.each_with_index do |(key, value), index|
      value = cards[index].sort.reverse
      Telegram.bots[:default].send_message(chat_id: key, text: "Ты получил #{value}", reply_markup: keyboard)
    end
    @@min = 0
  end

  def win
    party.each do |key, _value|
      Telegram.bots[:default].send_message(chat_id: key, text: "Вы выиграли")
    end
    @@party = {}
  end

  def lose
    party.each do |key, _value|
      Telegram.bots[:default].send_message(chat_id: key, text: "Вы проиграли")
    end
    @@party = {}
  end

  def party
    @@party ||= {}
  end
end
