example = <<TXT
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
TXT

def parse(input)
  input.split("\n").map { |row| parseRobot(row) }
end

def parseRobot(row)
  px, py, vx, vy = row.match(/p=(\d+),(\d+) v=(-?\d+),(-?\d+)/)[1..4]
  {
    pos: [px, py],
    vel: [vx, vy]
  }
end

def printMap(robots, row_count, col_count)
  Array.new(row_count) { Array.new(col_count) { '.' } }.tap do |map|
    robots.each do |robot|
      robot_col, robot_row = *robot[:pos]
      
      if map[robot_row.to_i][robot_col.to_i] == '.'
        map[robot_row.to_i][robot_col.to_i] = 1
      else
        map[robot_row.to_i][robot_col.to_i] += 1
      end

    end
  end.map(&:join).join("\n")
end

def robotStep(robots, cycles, dimensions)
  robots.map do |robot|
    px, py = *robot[:pos]
    vx, vy = *robot[:vel]
    rows, cols = *dimensions

    {
      pos: [(px.to_i + (vx.to_i * cycles)) % cols, (py.to_i + (vy.to_i * cycles)) % rows],
      vel: robot[:vel]
    }
  end
end

def safetyFactor(robots, dimensions)
  rows, cols = *dimensions
  mid_row = rows / 2
  mid_col = cols / 2

  north_west = robots.count { |robot| robot[:pos][0].to_i < mid_col && robot[:pos][1].to_i < mid_row }
  south_west = robots.count { |robot| robot[:pos][0].to_i < mid_col && robot[:pos][1].to_i > mid_row }
  north_east = robots.count { |robot| robot[:pos][0].to_i > mid_col && robot[:pos][1].to_i < mid_row }
  south_east = robots.count { |robot| robot[:pos][0].to_i > mid_col && robot[:pos][1].to_i > mid_row }
  [north_west, south_west, north_east, south_east].inject(&:*)
end

def part1(input, cycles = 100, dimensions = [103, 101])
  robots = parse(input)
  # puts printMap(robots, *dimensions)

  after_waiting = robotStep(robots, cycles, dimensions)
  puts 
  # puts printMap(after_waiting, *dimensions)
  safetyFactor(after_waiting, dimensions)
end

def part2(input)
  rows = 103
  cols = 101
  # so a christmas tree looks like ....
  # according to reddit we're looking for the first position where no robots are overlapping
  # >:[

  robots = parse(input)
  move_count = nil
  10_000.times do |cycle|
    state = robotStep(robots, cycle, [rows, cols])
    
    positions = state.map { |r| r[:pos] }.tally
    unless positions.values.any? { |v| v > 1 }
      move_count = cycle
      puts printMap(state, rows, cols)
      break
   end
  end

  move_count
end

puts "Part 1"
# p part1(example, 100, [7, 11])

challenge = File.read("day14.txt")
p part1(challenge, 100, [103, 101])

puts "Part 2"
p part2(challenge)