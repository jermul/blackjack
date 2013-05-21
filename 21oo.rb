
class Card
  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit  = suit
  end
  
  def show_suit
    case suit
      when 'D' then '♦'
      when 'C' then '♣'
      when 'H' then '♥'
      when 'S' then '♠'
    end
  end
  
  def show_card
    "#{value} of #{show_suit}"
  end
  
  def to_s
    show_card
  end
  
end

class Deck
  attr_accessor :cards
  
  def initialize
    @cards = []
    ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |value|
      ['S', 'H', 'C', 'D'].each do |suit|
        @cards << Card.new(value, suit)
      end
    end
    shuffle!
  end
  
  def shuffle!
    cards.shuffle!
  end
  
  def deal_card
    cards.pop
  end
  
  def size
    cards.size
  end
  
end


module Hand

  def show_hand
    puts "#{name}'s hand:"
    cards.each do |card|
      puts "#{card}"
    end
    puts "Total value of: #{total}"
  end

  def total
    points = cards.map{ |card| card.value }
    
    total = 0
    points.each do |value|
      if value == "A"
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end
      
    points.select{ |value| value == "A" }.count.times do
      total -= 10 if total > 21
    end
    
    total
  end
  
  def append_card(new_card)
    cards << new_card
  end
  
  def busted?
    total > Blackjack::BLACKJACK
  end
  
  def natural_21?
    cards.count == 2 && total == Blackjack::BLACKJACK
  end

end

class Player
  include Hand
  
  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end
  
  def display_deal
    show_hand
  end
  
end

class Dealer
  include Hand
  
  attr_accessor :name, :cards
  
  def initialize
    @name = "Dealer"
    @cards = []
  end
  
  def display_deal
    puts "The dealer shows:"
    puts "#{cards[0]}"
    puts "Hole Card"
  end
  
  def display_hole_card
    puts "Hole Card is #{cards[1]}"
  end
  
end

class Blackjack
  BLACKJACK = 21
  DEALER_STAND = 17
  
  attr_accessor :deck, :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new("Player1")
  end
  
  def welcome
    #puts "\e[H\e[2J"
    puts <<-PARAGRAPH
    Welcome!  The game is Blackjack.
    The object of the game is to reach 21 points,
    or to reach a score higher than the dealer
    without exceeding 21.

    Cards 2 - 10 are worth face value,
    Face cards are worth 10,
    Aces are worth 1 or 11.
    The dealer stands on 17.
    
    PARAGRAPH
  end
  
  def inst_player
    puts "To play, please enter your name:"
    prompt
    player.name = gets.chomp
    puts ""
    puts "Shuffle up and deal!"
    puts ""
  end
  
  def initial_deal
    player.append_card(deck.deal_card)
    dealer.append_card(deck.deal_card)
    player.append_card(deck.deal_card)
    dealer.append_card(deck.deal_card)
  end

  def display_deal
    player.display_deal
    dealer.display_deal
    
    if player.natural_21?
      puts "#{player.name} has blackjack! The player wins!"
      another_hand?
    elsif dealer.natural_21?
      dealer.display_hole_card
      puts "The dealer has blackjack. The house wins."
      another_hand?
    elsif player.natural_21? and dealer.natural_21?
      puts "Push."
      another_hand?
    end
  end
  
  def player_action
    if player.natural_21?
      another_hand?
    else
      puts "Action is on #{player.name}"
      while player.total < BLACKJACK
        puts "Does the player 1) Hit or 2) Stand?"
        prompt
        action = gets.chomp
        if action == "1"
          puts "Dealing card to #{player.name}..."
          player.append_card(deck.deal_card)
          player.show_hand
        elsif action == "2"
          break
        else
          puts "#{player.name}, please enter 1) to Hit or 2) to Stand."
        end
      end
    end
    
    if player.busted?
      puts "The player's hand is busted."
    else
      puts "#{player.name} stands on #{player.total}"
    end
  end

  def dealer_action
    if player.busted?
      puts "The house wins."
      another_hand?
    else
      dealer.show_hand
      while dealer.total < DEALER_STAND and !player.busted?
        puts "The dealer hits..."
        dealer.append_card(deck.deal_card)
        dealer.show_hand
      end
      
      if dealer.total > BLACKJACK
        puts "The dealer's hand is busted."
        puts "The player wins!"
      else
        puts "The dealer stands on #{dealer.total}"
      end
    end
  end
  
  def determine_winner
    if (player.total > dealer.total) and (player.total <= BLACKJACK)
      puts "#{player.name} wins!"
    elsif (dealer.total > player.total) and (dealer.total <= BLACKJACK)
      puts "The house wins."
    elsif dealer.total == player.total
      puts "Push."
    end
    another_hand?
  end
  
  def another_hand?
    play_game = nil
    
    while play_game == nil
      puts ""
      puts "Would you like to play another hand [Y/N]?"
      prompt
      play_game = gets.chomp.downcase
      if play_game == 'y'
        puts "Dealing another hand..."
        puts ""
        self.deck = Deck.new
        player.cards = []
        dealer.cards = []
        initial_deal
        display_deal
        player_action
        dealer_action
        determine_winner
      elsif play_game == 'n'
        puts "Thank you for playing!"
        puts "Goodbye."
        exit
      else
        play_game = nil
        puts "Please enter Y or N."
      end
    end
  end

  def start
    welcome
    inst_player
    initial_deal
    display_deal
    player_action
    dealer_action
    determine_winner
  end

  def prompt
  print "> "
  end
  
end

game = Blackjack.new
game.start