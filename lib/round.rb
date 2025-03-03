#class file for Round class

class Round
  attr_reader :deck, :turns, :current_card_number, :number_correct, :number_correct_per_category, :number_asked_per_category

  def initialize(deck)
    @deck = deck
    @turns = []
    @current_card_number = 0
    @number_correct = 0
    @number_correct_per_category = Hash.new(0)
    @number_asked_per_category = Hash.new(0)
  end

  def current_card
    deck.cards[@current_card_number]
  end

  def take_turn(user_guess)
    current_turn = Turn.new(user_guess, current_card)
    @turns.push(current_turn)
    #Send in initial keys for the hashes that are defaulted to 0
    @number_correct_per_category[current_card.category]
    @number_asked_per_category[current_card.category]

    #Check if the guess equals the answer
    if current_turn.correct? == true
      #Added one to each correct variable
      @number_correct += 1
      @number_correct_per_category[current_card.category] += 1
    end
    #Add one to go to the next card
    @number_asked_per_category[current_card.category] += 1
    @current_card_number += 1
    current_turn
  end

  def percent_correct
    (@number_correct.to_f / @turns.size.to_f) * 100
  end

  def number_correct_by_category(cat)
    @number_correct_per_category[cat]
  end

  def percent_correct_by_category(cat)
    (@number_correct_per_category[cat].to_f / @number_asked_per_category[cat].to_f) * 100
  end

  def start
    puts "Welcome! You're playing with #{@deck.count} cards."
    puts "----------------------------"

    #Ask each question in deck until no cards remain
    until current_card == nil
      puts "This is card number #{@current_card_number + 1} out of #{@deck.count} cards."
      puts @deck.cards[@current_card_number].question
      user_guess = gets.chomp
      take_turn(user_guess)
      puts @turns.last.feedback
    end

    #Display results
    puts "****** Game over! ******"
    puts "You had #{@number_correct} correct answers out of #{@deck.count} for a total score of #{percent_correct.to_i}%"
    #Cycle through each card category and display percentage
    number_asked_per_category.each_key do |key|
      puts "#{key.to_s} - #{percent_correct_by_category(key).to_i}% correct"
    end

  end

end
