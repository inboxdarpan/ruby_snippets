#!/usr/bin/ruby


#Start
$grid_size = {}
$direction_table = {"e" => 0, "n" => 1, "w" => 2, "s" => 3}
$rovers = Array.new


# logic to move rover as per given directions
def move_rover(location, direction)
  case direction
    when 'l'
      location[2] = (location[2] + 1) % 4
    when 'r'
      location[2] = (location[2] - 1) % 4
    when 'm'
      if (location[2] == 0) && (location[0] < $grid_size[0])
        location[0] += 1
      elsif (location[2] == 1) && (location[0] < $grid_size[1])
        location[1] += 1
      elsif (location[2] == 2) && (location[0] > 0)
        location[0] -= 1
      elsif (location[2] == 3) && (location[0] > 0)
        location[1] -= 1
      end
  end
  return location
end

# read inputs from STDIN
def get_input_data()
  print 'Enter Grid size '
  $grid_size = gets.split(" ").map(&:to_i) #Integer(gets.chomp)
  while (true) do
    puts "Enter rover location "
    input = gets
    break if input.chomp.to_s.downcase == 'no'
    
    rover = {}
    rover['location'] = input.split(" ").map(&:to_s)
    rover['location'][2] = $direction_table[rover['location'][2].downcase]
    rover['location'].map!(&:to_i)

    puts "Enter rover directions "
    rover['directions'] = gets.split("").map(&:to_s.downcase)

    $rovers.push(rover)
    puts "#{$rovers.to_s}"

  end
end

# final location of each rover
def show_results
  $rovers.each do |rover|
    puts "final location #{rover['location'].to_s}"
  end
end

# Initialize the values
def init()
  get_input_data()
  $rovers.each do |rover|
    location = rover['location']
    directions = rover['directions']

    directions.each do |direction|
      location = move_rover(location, direction)
    end
    location[2] = $direction_table.key(location[2])
    rover['location']  = location
  end
  show_results
end

# Start
init()

