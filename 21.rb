# Blackjack 21

def calculate_total(cards) # [['card', 'suit']]
  card_values = cards.map { |card| card[0] }
  total = 0

  card_values.each do |value|
  	if value == 'Ace'
  		total += 11
  	elsif value.to_i == 0 #Jacks, Queens, or Kings 
  		total += 10
  	else
  		total += value.to_i
  	end
  end

  # determines if Aces are 1 or 11; for each Ace if total > 21 subtract 10
  card_values.select {|card| card == 'Ace'}.count.times do
		total -= 10 if total > 21  
  end

  total
end

cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
suits = ['Spades', 'Hearts', 'Diamonds', 'Clubs']

deck = cards.product(suits)
deck.shuffle!

# Deal Cards

player_hand = []
dealer_hand = []

player_hand << deck.pop
dealer_hand << deck.pop
player_hand << deck.pop
dealer_hand << deck.pop

player_total = calculate_total(player_hand)
dealer_total = calculate_total(dealer_hand)

# Show Cards

puts
puts "Let's play Blackjack!".center(80)
puts "-------------------------------------------------------------------------------"
puts
puts "Dealer is showing #{dealer_hand[1]}."
puts "Player has: #{player_hand[0]} and #{player_hand[1]}, for a total value of #{player_total}."
puts
if dealer_total == 21
  puts "Sorry, dealer reveals #{dealer_hand[0]} and has hit blackjack. You lose." 
  exit
end

# Players Turn
card_counter = 0

while player_total < 21
	card_counter += 1
	if card_counter == 5
		puts "Player has been dealt five cards without busting, player automatically wins!"
	  break
	end
  
  puts "What would you like to do? [H]it or [S]tay?"
	move = gets.chomp.downcase

	if !['h', 's'].include?(move)
		puts 'You must enter "h" to hit or "s" to stay.'
		next
  end

  if move == 's'
  	puts 'Player choses to stay.'
  	break
  end

  if move == 'h'
  	add_card = deck.pop
  	puts "#{add_card} dealt to player."
  	player_hand << add_card
  	player_total = calculate_total(player_hand)
  	puts "Your total is now #{player_total}."
  end

  if player_total == 21
  	puts "Congratuations, you've hit Blackjack!. You win!"
  	exit
  elsif player_total > 21
  	puts "#{player_total} is over 21. Sorry, you busted."
  	exit
  end
end

# Dealer's turn

while dealer_total < 17
	new_card = deck.pop
	puts "Dealt new card to dealer: #{new_card}."
	dealer_hand << new_card
	dealer_total = calculate_total(dealer_hand)
	puts "Dealer total is now #{dealer_total}."

  if dealer_total == 21
  	puts "Sorry, dealer hit blackjack. You lose."
  	exit
  elsif dealer_total > 21
  	puts "Congratulations, dealer busted. You win!"
  	exit
  end
end

# Compare hands
puts "Dealer's hand: "
dealer_hand.each { |card| puts "#{card}" }
puts 

puts "Player's hand: "
player_hand.each { |card| puts "#{card}" }
puts

if dealer_total > player_total
	puts "Sorry, dealers #{dealer_total} beats players #{player_total}. You lose."
elsif dealer_total < player_total
	puts "Congratulations, players #{player_total} beats dealers #{dealer_total}. You win!"
else
	puts "It's a push. Dealers #{dealer_total} is equal to Players #{player_total} and results in a tie."
end

exit


  	

