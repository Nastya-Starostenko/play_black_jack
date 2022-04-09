# frozen_string_literal: true

require_relative '../classes/card'

class Deck
  SUITS = %w[♠ ♥ ♦ ♣].freeze
  RANKS = [*(2..10), 'ace', 'king', 'queen', 'jack'].freeze

  attr_accessor :cards, :dealt_cards

  def initialize
    @cards = create_cards
    @dealt_cards = []
  end

  def create_cards
    SUITS.flat_map do |suit|
      RANKS.map do |rank|
        value = rank.instance_of?(Integer) ? rank : 10
        value = 11 if rank == 'ace'
        Card.new(rank: rank, suit: suit, value: value)
      end
    end
  end

  def deal_card
    card = remaining_cards.sample
    @dealt_cards << card
    card
  end

  def remaining_cards
    cards - dealt_cards
  end
end
