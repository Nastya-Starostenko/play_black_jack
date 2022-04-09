# frozen_string_literal: true

require_relative 'human_player'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'

class Game
  MAX_CARDS_ON_HANDS = 3
  DEAL_CONDITIONS_POINTS = 17
  MAX_GAME_POINT = 21
  DEFAULT_BET = 10

  def initialize
    create_user
    create_dealer
    start
  end

  def start
    loop do
      new_game

      loop do
        show_deck
        user_move
        dealer_move
        break unless game_continue?
      end
      open_cards

      puts 'loop 1 finished'
      puts "Do you want play again?\n  Y - yes, Other - no"
      continue_game = gets.chomp.to_s
      if continue_game != 'Y' || player.deposit < DEFAULT_BET
        puts 'Game over'
        break
      end
    end
  end

  private

  attr_accessor :player, :dealer, :deck, :game_bank

  def create_user
    puts 'Hi, put your name:'
    name = gets.chomp
    @player ||= HumanPlayer.new(name: name)
    puts "Hello, #{name}, game started\n *****************"
  end

  def create_dealer
    @dealer ||= Dealer.new
  end

  def new_game
    @cards_opened = false
    player.cards = []
    dealer.cards = []
    deal_cards
    make_bets
  end

  def deal_cards
    @deck = Deck.new
    [player, dealer].each { |user| 2.times { user.take_card(deck.deal_card) } }
  end

  def make_bets
    @game_bank ||= Bank.new(DEFAULT_BET * 2)
    player.make_bet
    dealer.make_bet
  end

  def game_continue?
    return false if [player.cards.count, dealer.cards.count].all?(3) || @cards_opened

    true
  end

  def show_deck
    puts '###### INFO ######'
    puts "Your cards: #{player.show_cards}\n"
    puts "Dealear cards #{dealer.show_dealer_cards}"
    puts ''
  end

  def user_move
    puts '*******'
    puts 'What you want do?'
    puts '1. Skip' if dealer.cards.count != 3 && player.cards.count == 2
    puts '2. Open cards'
    puts '3. Add card' if player.cards.count == 2

    choice = gets.chomp.to_i

    case choice
    when 1 then skip_move(player)
    when 2 then @cards_opened = true
    when 3 then player.take_card(deck.deal_card)
    end
  end

  def dealer_move
    skip_move(dealer) if dealer.points >= DEAL_CONDITIONS_POINTS
    dealer.take_card(deck.deal_card) if can_take_card?
    puts 'Pass move to user'
    puts ''
  end

  def skip_move(user)
    puts "#{user.name}: I skip move"
  end

  def can_take_card?
    dealer.points < DEAL_CONDITIONS_POINTS && dealer.cards.count < MAX_CARDS_ON_HANDS
  end

  def open_cards
    @cards_opened = true

    puts "Dealer: #{dealer.show_cards}"
    puts "Player: #{player.show_cards}"
    total_points
  end

  def total_points
    if (player.points > dealer.points && player.points <= MAX_GAME_POINT) ||
      (player.points < dealer.points && player.points >= MAX_GAME_POINT)
      puts 'Player win'
      pay_to_winner(player)
    elsif player.points == dealer.points
      puts 'Dead heat'
      pay_to_winner(dealer, game_bank.amount / 2)
      pay_to_winner(player)
    else
      puts 'Dealer win'
      pay_to_winner(dealer)
    end
    puts ''
    puts "Dealer money #{dealer.deposit}, Your money: #{player.deposit}"
  end

  def pay_to_winner(winner, amount = game_bank.amount)
    winner.deposit += game_bank.withdraw(amount)
  end
end
