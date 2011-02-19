require './cards.rb'

class BlackjackCard < Card
    
    VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]

    attr_accessor :value

    def value
        @value = VALUES[@number % 13]
    end
end

class BlackjackHand < Hand

    def cards
      cards = []
      raw_cards = @redis.lrange @db, 0, -1
      raw_cards.each do |card|
        cards.push(BlackjackCard.new(card.to_i))
      end
      return cards
    end

    def count 
        score = 0
        # Sort the cards so that aces come last.
        # This way we know whether to count them as 11 or 1.
        sorted_hand = cards.sort_by {|card| card.value}
        sorted_hand.each do |card|
            # Aces are worth 11 points, unless the total would
            # be over 21.  Then count them as 1 point.
            if card.value == 11 and score + card.value > 21 then
                score += 1  
            else 
                # It's not an ace.  Just add it up.
                score += card.value
            end
        end
        return score
    end

   def blackjack?
     if self.count == 21 then
        true
     else
        false
     end
   end

   def bust?
     if self.count > 21 then
       true
     else
       false
     end
   end

end

