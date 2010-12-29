class Card

  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(Spade Heart Club Diamond)

  attr_accessor :rank, :suit, :number 

  def initialize(id)
    @rank = RANKS[id % 13]
    @suit = SUITS[id % 4]
    @number = id 
  end

end


class Deck

  attr_accessor :cards

  def initialize(card_type)
    # shuffle array and init each Card
    @cards = (0..51).to_a.shuffle.collect { |id| card_type.new(id) }
  end
 
  def deal(n)
    return @cards.pop(n)
  end

end


class Hand

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def hit(num_cards)
    @cards.push(num_cards)
    @cards.flatten!
  end

  def length
    @cards.to_a.length
  end

  def show(num=@cards.length)
    num.times do |i|
        puts "#{@cards[i].rank} #{@cards[i].suit}"
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
