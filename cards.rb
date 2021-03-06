require 'rubygems'
require 'redis'
require 'uri'

class Card

  RANKS = %w(2 3 4 5 6 7 8 9 10 j q k a)
  SUITS = %w(spades hearts clubs diamonds)

  attr_accessor :name, :rank, :suit, :number 

  def name
      # This is the format for the playing card images
      # from http://www.eludication.org/playingcards.html
      return "#{suit}-#{rank}-75.png"
  end

  def initialize(id)
    @rank = RANKS[id % 13]
    @suit = SUITS[id % 4]
    @number = id 
  end

end


class Deck

  attr_accessor :cards
   
  def initialize()
    @id = settings.id
    @deck = "game:#{@id}:deck"
  end

  def shuffle!
    # Make sure the deck is empty from any previous games.
    keys = settings.redis.keys "game:#{@id}:*"
    if keys.length > 0 then
        settings.redis.del *keys
    end
    # shuffle array and init each Card
    @cards = (0..51).to_a.shuffle.collect { |i| settings.redis.rpush @deck, i}
  end

  def deal(n)
    cards = []
    n.times do 
      cards.push(settings.redis.lpop @deck)
    end
    return cards
  end

end


class Hand

  attr_accessor :cards

  def initialize(player)
    @hand = "game:#{settings.id}:player:#{player}:hand"
  end

  def cards
    cards = []
    raw_cards = settings.redis.lrange @hand, 0, -1 
    raw_cards.each do |card|
      cards.push(Card.new(card.to_i))
    end
    return cards
  end

  def hit(cards)
    cards.each do |card|
      settings.redis.rpush @hand, card
    end
  end

  def length
    return settings.redis.llen @hand
  end

  def show(num=self.length)
    num.times do |i|
      puts cards[i].name 
    end
  end

end


class Array

  # knuth-fisher-yates shuffle algorithm
  def shuffle
    n = length
    for i in 0...n
      r = rand(n-i)+i
      self[r], self[i] = self[i], self[r]
    end
    return self
  end

end
