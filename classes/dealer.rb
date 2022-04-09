# frozen_string_literal: true

require_relative '../classes/player'

class Dealer < Player
  def initialize
    super(type: :dealer, name: 'Dealer')
  end

  def show_dealer_cards
    cards.count.times.map { '***' }.join(', ')
  end
end
