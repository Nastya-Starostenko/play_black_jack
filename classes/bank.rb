# frozen_string_literal: true

class Bank
  DEFAULT_AMOUNT = 0

  attr_accessor :amount

  def initialize(amount = 0)
    @amount = amount || self::DEFAULT_AMOUNT
  end

  def top_up(amount)
    self.amount += amount
  end

  def withdraw(amount)
    self.amount -= amount
    amount
  end
end
