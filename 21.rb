# Blackjack 21
require 'pry'

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

def create_deck
  amount_of_decks = 1 # number of decks you want included

  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
  suits = [' of spades', ' of hearts', ' of clubs', ' of diamonds']
  
  deck = cards.product(suits) * amount_of_decks
  deck.shuffle!
end

def add_to_account(current_amount, ante_amount)
  while current_amount < ante_amount
    
    print "How much money would you like to add to your account? "
    answer = gets.chomp
    puts

    if answer != answer.to_i.to_s
      puts "Please enter a valid number."
      puts
    elsif (current_amount + answer.to_i) < ante_amount
      print "That would not be enough money to play. "
      puts "Please enter at least the ante amount of $#{ante_amount}."
      puts
    else
      answer = answer.to_i
      current_amount += answer
      puts "adding $#{answer} to your account..."
      puts
      sleep(1)
      puts "Okay, $#{answer} have been added to your account."
      puts
    end
  end
  return current_amount
end

def wager(account, ante)
  while true
    print "How much would you like to wager (#{ante} - #{(account / ante) * ante})? "
    wager = gets.chomp
    puts

    if wager != wager.to_i.to_s
      puts "Please enter a valid number."
      puts
    elsif wager.to_i > account
      puts "You don't have enough to wager that amount. Please wager $#{account} or less."
      puts
    elsif wager.to_i % ante != 0
      puts "wager must be a multiplicative of #{ante}."
      puts
    else
      wager = wager.to_i
      puts "You wager $#{wager} of the $#{account} in your account."
      puts
      break
    end
  end
  return wager
end

def winner? (name, player_total, dealer_total)
  if dealer_total == 21
    puts
    puts "The dealer has hit Blackjack. Sorry #{name}, you lose."
    winner = "DEALER"
  elsif dealer_total > 21
    puts
    puts "The dealer busted! Congratulations #{name}, you win!"
    winner = "PLAYER"
  elsif dealer_total > player_total
    puts
    puts "The dealers total of #{dealer_total} beats your total of #{player_total}."
    puts
    puts "Sorry #{name}, you lose."
    winner = "DEALER"
  elsif dealer_total < player_total
    puts
    puts "#{name}'s total of #{player_total} beats dealers total of #{dealer_total}."
    puts
    puts "Congratulations #{name}, you win!"
    winner = "PLAYER"
  else
    puts
    puts "#{name} and the dealer have equal totals of #{player_total}. It's a tie."
    winner = nil
  end
  winner
end

wants_to_play = true
deck          = create_deck
ante          = 5
account       = 0

puts
puts "Let's play Blackjack!".center(80)
puts "-------------------------------------------------------------------------------"
puts
print "First, can you tell me what your name is? "
name = gets.chomp.downcase.capitalize
puts
puts "Ok #{name}, there is a minimum bet of $#{ante}, with no maximum bet."

while wants_to_play

  puts
  if account <= ante
    puts "You need at least $#{ante} to play."
    puts
    account += add_to_account(account, ante)
  end

  puts "...#{name} antes up with $#{ante}..."
  account -= ante
  wager = 0
  puts
  
  # replaces deck with fresh deck whenever the deck gets less than twenty cards
  if deck.count < 20
    puts "Shuffling the deck."
    deck = create_deck
    sleep(1)
  end

  puts "dealings cards..."
  sleep(1)

  # deal hands
  player_hand = []
  dealer_hand = []
  player_hand << deck.pop
  dealer_hand << deck.pop
  player_hand << deck.pop
  dealer_hand << deck.pop
  player_total = calculate_total(player_hand)
  dealer_total = calculate_total(dealer_hand)
  player_turn  = true

  # show cards
  puts
  puts "Dealer is showing '#{dealer_hand[1].join}.'"
  print "You have '#{player_hand[0].join}' and '#{player_hand[1].join},' "
  puts "for a total value of #{player_total}."
  puts
  sleep(1)

  # any auto wins?
  if player_total == 21
    puts "You've hit Blackjack! You win!"
    puts
    winner = "PLAYER"
  elsif dealer_total == 21
    print "Dealer reveals the '#{dealer_hand[0].join}.' "
    puts "Dealer has hit Blackjack. Sorry, you lose."
    puts
    winner = "DEALER"
  else
    winner = nil
  end

  # take an additional wager if no auto-win
  if winner == nil
    if account < ante 
      print "It looks like you don't have enough money in your account to "
      puts "place an additional wager."
      wager = 0
    else
      wager = wager(account, ante)
    end
  end
  
  # Players turn
  card_counter = 2

  while winner == nil
    card_counter += 1
    puts

    if player_total == 21
      puts "You just hit Blackjack. You win!"
      puts
      winner = "PLAYER"
    elsif player_total > 21
      puts "I'm sorry #{name}, you're over 21 and have busted."
      puts
      winner = "DEALER"
    else
      print "Would you like to hit or stay? "
      move = gets.chomp.upcase
      puts
  
      if move[0] == 'S'
        puts 'Player chooses to stay.'
        break
      elsif move[0] == 'H'
        sleep(1)
        add_card = deck.pop
        puts "'#{add_card.join.capitalize}' dealt to player."
        puts
        player_hand << add_card
        player_total = calculate_total(player_hand)
        puts "Your total is now #{player_total}."
      elsif move[0] == 'C'
        puts "You're holding '#{player_hand[0].join}' and '#{player_hand[1].join}.'"
        next
      else
        puts 'You must enter "h" to hit or "s" to stay. You can also look at your cards by entering "c".'
        next
      end
    end
  end
  
  if winner == nil

    # Dealer's turn
    puts
    print "Dealer reveals the '#{dealer_hand[0].join}' to go with his "
    puts "'#{dealer_hand[1].join}' for a total of #{dealer_total}."
    puts
    sleep(1)

    while dealer_total < 17
      puts "Dealer hits..."
      puts
  	  add_card = deck.pop
  	  puts "'#{add_card.join.capitalize}' dealt to dealer."
      puts
  	  dealer_hand << add_card
  	  dealer_total = calculate_total(dealer_hand)
      sleep(1)
    end
    sleep(1)
    # Compare hands
    puts "Dealer's hand: "
    dealer_hand.each { |card| puts "'#{card.join}'" }
    puts 
    
    puts "Player's hand: "
    player_hand.each { |card| puts "'#{card.join}'" }
    puts
    winner = winner?( name, player_total, dealer_total ) 
    sleep(1)
    puts 
  end

  #calculate winnings
  winnings = wager + ante

  if winner == "PLAYER"
    account += (winnings + ante)
    print "You won $#{winnings}. " 
  elsif winner == "DEALER"
    account -= wager
    print "Including your ante, you lost $#{winnings}. "
  end
    
  puts "This brings your account total to $#{account}."
  puts
  print "Would you like to play again? "
  wants_to_play = false if gets.chomp.upcase[0] !="Y"
  puts
end
  
if account > 0
  puts "You cash out with $#{account}."
  puts
  puts "Thanks for playing!"
else
  print "Sorry #{name}, you didn't win anything this time "
  puts "but please come back again!"
end


