require 'sinatra'
require 'redis'
require './cards.rb'
require './blackjack.rb'

use Rack::Session::Pool,
  :expire_after => 60*60*24*365 # In seconds

configure do
  set :redis, Redis.new
end

# Set up the game.
before do
  set :id, request.cookies['rack.session']
  @dealer = 0
  @player = 1
  @deck = Deck.new
  @my_hand = BlackjackHand.new(@player)
  @dealer_hand = BlackjackHand.new(@dealer)
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

