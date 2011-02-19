require 'sinatra'
require './cards.rb'
require './blackjack.rb'

# Set up the game.
before do
  @id = 1
  @dealer = 0
  @player = 1
  @deck = Deck.new(@id)
  @my_hand = BlackjackHand.new(@id,@player)
  @dealer_hand = BlackjackHand.new(@id,@dealer)
end

get '/blackjack/hit' do
  @my_hand.hit(@deck.deal(1))
  haml :play
end

get '/blackjack/stay' do
  until @dealer_hand.count > 16
    @dealer_hand.hit(@deck.deal(1))
  end
  haml :stay
end
  
get '/blackjack' do
  @deck.shuffle!
  @my_hand.hit(@deck.deal(2))
  @dealer_hand.hit(@deck.deal(2))
  @blackjack = @my_hand.blackjack?
  haml :play
end
