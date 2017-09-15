#!/usr/bin/ruby


NUM_DICE = 5
$score_board = {}
$score_ref_sheet = {1=>1000, 2=>100, 3=>300, 4=>400, 5=>500, 6=>600}
$score_ref_sheet_1_5 = {1=>100, 5=>50}
print "------"

def init(num_users)
	(1..num_users).each do |i|
		$score_board[i] = 0
	end
end

def roll_dice(num_dice)
	dice_roll_result = num_dice.times.map{ 1 + Random.rand(6) }
	return dice_roll_result
end

def calculate_score(scores)
	_non_scoring = 0
	final_score = 0
	score_map = Hash.new(0)
	scores.each {|item| score_map[item] += 1}

	puts "unique scores #{score_map.to_s}"
	
	score_map.each do |key,value|
		if value >=3
			final_score += $score_ref_sheet[key]
			if key ==1 or key == 5
			else
				_non_scoring += value-3
			end
		elsif (key ==1 or key == 5)
			final_score += value*$score_ref_sheet_1_5[key]
		elsif 
			_non_scoring +=value
		end	
	end
	return final_score
end

def roll(user_id)
	puts "Rolling for user #{user_id}"
	dice_roll_result = roll_dice(NUM_DICE)
	puts "player #{user_id} rolls : #{dice_roll_result.to_s}"
	score_of_this_roll = calculate_score(dice_roll_result)
	$score_board[user_id] += score_of_this_roll
	puts "user #{user_id} scored #{score_of_this_roll} in this roll \n\n"
end


# (0..5).each do |i|

#start game
print "Enter number of players "
num_players = Integer(gets.chomp)
puts "number of players #{num_players}\n\n"

init(num_players)

while ($score_board.values.max < 1500)
	(1..num_players).step(1) do |n|
		roll(n)
	end
	puts "max score #{$score_board.values.max}, 
	of user #{$score_board.key($score_board.values.max)}"
	# puts 'game is over'
end
