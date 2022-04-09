# frozen_string_literal: true

require_relative 'game'

class Player
  USER_TYPE = {
    player: :player,
    dealer: :dealer
  }.freeze
  DEPOSIT_AMOUNT = 100

  attr_accessor :type, :name, :deposit, :cards

  def initialize(**kwargs)
    @type = kwargs[:type]
    @name = kwargs[:name]
    @deposit = DEPOSIT_AMOUNT
    @cards = []
  end

  def make_bet
    self.deposit -= Game::DEFAULT_BET
  end

  def take_card(card)
    @cards << card
  end

  def show_cards
    cards.map(&:show).join(', ').concat(' total points: ', points.to_s)
  end

  def points
    card_points = 0
    cards.sort_by(&:value).each do |card|
      card_points += (card.rank == 'ace') && (card_points > 21) ? 1 : card.value
    end
    card_points
  end
end
