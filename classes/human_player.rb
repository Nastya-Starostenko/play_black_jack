# frozen_string_literal: true

require_relative '../classes/player'

class HumanPlayer < Player
  def initialize(name:)
    super(type: :player, name: name)
  end

  def skip
    puts 'Dealer\'s step'
  end
end
