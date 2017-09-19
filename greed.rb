#!/usr/bin/ruby

NUM_DICE = 5
WINNING_THRESHOLD = 2000
# Static values 
$score_ref_sheet = { 1 => 1000, 2 => 100, 3 => 300, 4 => 400, 5 => 500, 6 => 600 }
$score_ref_sheet_1_5 = { 1 => 100, 5 => 50 }
$min_score_to_enter_game = 300
$user_is_in_game = {}
$score_board = {}

# Intializes empty score variables
def init(num_users)
  (1..num_users).each do |i|
    $score_board[i] = 0
    $user_is_in_game[i] = false
  end
end

# This function emulates a turn taken by each user to roll the die
def roll(user_id)
  puts "Rolling for user #{user_id}"

  @reset_score = false
  _total_score_of_this_roll = 0
  _dice_number_to_roll = NUM_DICE
  loop do 
    dice_roll_result = roll_dice(_dice_number_to_roll)
    result_of_roll = calculate_score(user_id, _dice_number_to_roll, dice_roll_result)
    
    score_of_this_roll = result_of_roll[0]

    if result_of_roll[1] == _dice_number_to_roll
      @reset_score = true
      break
    end

    if !($user_is_in_game[user_id])
      if score_of_this_roll > $min_score_to_enter_game 
        $user_is_in_game[user_id] = true
      else
        puts "User scored #{score_of_this_roll} < 300, can't continue"
        break
      end
    end

    _total_score_of_this_roll += result_of_roll[0]
    _dice_number_to_roll = result_of_roll[1]

    if (_dice_number_to_roll == 0) && (score_of_this_roll > 0) && ($user_is_in_game[user_id])
      dice_to_roll = NUM_DICE
    end

    if _dice_number_to_roll > 0
      puts "#{_dice_number_to_roll} non-scoring dice available, want to roll? (y/n) "
      _want_to_roll = gets.chomp.downcase
      if _want_to_roll != 'y'
        break
      end
    end
    break if _dice_number_to_roll == 0 && !($user_is_in_game[user_id])
  end
  if !(@reset_score)
    $score_board[user_id] += _total_score_of_this_roll
  else
    _total_score_of_this_roll = 0
  end

	puts "user #{user_id} scored #{_total_score_of_this_roll} in this roll \n"
  puts "\n --------------------\n"
end


# Gives values of 'num_dice' number of dice rolled, ie 5 dice = 3,4,5,6,3
def roll_dice(num_dice)
	dice_roll_result = num_dice.times.map{ 1 + Random.rand(6) }
	return dice_roll_result
end


# This function calculates score of this roll based on dice roll results 
# received from roll_dice()
def calculate_score(user_id, num_dice, scores)
	@reset_score = false
	_non_scoring_dice_count = 0
	final_score = 0
	score_map = Hash.new(0)
	scores.each {|item| score_map[item] += 1}

	puts "unique scores #{score_map.to_s}"
	
	score_map.each do |key,number_of_dice|
		if number_of_dice >= 3
			final_score += $score_ref_sheet[key]
			if key ==1 or key == 5
			else
				_non_scoring_dice_count += number_of_dice - 3
      end
    elsif key == 1 || key == 5
      final_score += number_of_dice * $score_ref_sheet_1_5[key]
		elsif 
			_non_scoring_dice_count += number_of_dice
    end
  end

  puts "non scoring #{_non_scoring_dice_count} and num dice is #{num_dice}, score for this roll is #{final_score}"
	return final_score, _non_scoring_dice_count
end

# initializes values and starts the game
def start_game
  print 'Enter number of players '
  num_players = Integer(gets.chomp)
  puts "number of players #{num_players}\n\n"

  init(num_players)

  while $score_board.values.max < WINNING_THRESHOLD
    (1..num_players).step(1) do |n|
      roll(n)
    end
  end

  # One last roll before it reaches winning threshold scores
  (1..num_players).step(1) do |n|
    roll(n)
  end

  puts "max score #{$score_board.values.max}, of user #{$score_board.key($score_board.values.max)}, Winner is in the house. "
end

# Start_game
start_game
