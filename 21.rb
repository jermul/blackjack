# Blackjack 21

def calculate_total(cards) # [['card', 'suit']]
  arr = cards.map { |e| e[0] }
  total = 0

  arr.each do |value|
  	if value == 'Ace'
  		total += 11
  	elsif value.to_i == 0 #Jacks, Queens, or Kings 
  		total += 10
  	else
  		total += value.to_i
  	end
  end

  # determine if Aces are 1 or 11
  arr.select { |e| e == 'Ace' }.count.times do
		total -= 10 if total > 21  
  end

  total
end

puts
puts "Welcome to Blackjack!".center(80)
puts "-------------------------------------------------------------------------------"
puts
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']

deck = cards.product(suits)
deck.shuffle!

# Deal Cards

player_cards = []
dealer_cards = []

player_cards << deck.pop
dealer_cards << deck.pop
player_cards << deck.pop
dealer_cards << deck.pop

player_total = calculate_total(player_cards)
dealer_total = calculate_total(dealer_cards)

# Show Cards

puts "Dealer has: #{dealer_cards[0]} and #{dealer_cards[1]}, for a total of #{dealer_total}"
puts "Player has: #{player_cards[0]} and #{player_cards[1]}, for a total of #{player_total}"
puts
puts "What would you like to do? 1)hit 2)stay"
move = gets.chomp
