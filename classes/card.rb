# frozen_string_literal: true

class Card
  attr_reader :rank, :suit, :value

  def initialize(rank:, suit:, value:)
    @rank = rank
    @suit = suit
    @value = value
  end

  def show
    "#{rank} #{suit}"
  end
end
