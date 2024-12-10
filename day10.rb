score2 = <<TXT
...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9
TXT

score4 = <<TXT
..90..9
...1.98
...2..7
6543456
765.987
876....
987....
TXT

score3 = <<TXT
10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01
TXT

score36 = <<TXT
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
TXT

rating3 = <<TXT
.....0.
..4321.
..5..2.
..6543.
..7..4.
..8765.
..9....
TXT

rating13 = <<TXT
...0..9
...1.98
...2..7
6543456
765.987
876....
987....
TXT

rating227 = <<TXT
012345
123456
234567
345678
4.6789
56789.
TXT

def parse(input)
  input.split("\n").map { |row| row.split("").map { |col| col == '.' ? '.' : col.to_i } }
end

def findTrailheads(map)
  [].tap do |points|
    map.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        points << [row_i, col_i] if col == 0
      end
    end
  end
end

def trailscore(trailhead, map)
  # how many 9s can I reach from this trailhead?
  visited = []
  queue = [trailhead]
  trailtails = Set.new
  max_row = map.length - 1
  max_col = map[max_row].length - 1

  while queue.length > 0
    row, col = *(queue.shift)
    altitude = map.dig(row, col)
    if altitude == 9
      trailtails << [row, col]
    else
      # check if we can move in any direction
      queue.push([row - 1, col]) if row > 0 && map.dig(row - 1, col) == altitude + 1 # north
      queue.push([row + 1, col]) if row < max_row && map.dig(row + 1, col) == altitude + 1 # south
      queue.push([row, col - 1]) if col > 0 && map.dig(row, col - 1) == altitude + 1 # west
      queue.push([row, col + 1]) if col < max_col && map.dig(row, col + 1) == altitude + 1 # east
    end
  end

  trailtails.length
end

def trailrating(trailhead, map)
  # now it wants us to keep track of paths. booooooo.

  visited = []
  queue = [[trailhead, []]]
  trailpaths = Set.new
  max_row = map.length - 1
  max_col = map[max_row].length - 1

  while queue.length > 0
    (row, col), path_so_far = *(queue.shift)
    path_so_far << [row, col]
    altitude = map.dig(row, col)
    if altitude == 9
      trailpaths << path_so_far.clone
    else
      # check if we can move in any direction
      queue.push([[row - 1, col], path_so_far.clone]) if row > 0 && map.dig(row - 1, col) == altitude + 1 # north
      queue.push([[row + 1, col], path_so_far.clone]) if row < max_row && map.dig(row + 1, col) == altitude + 1 # south
      queue.push([[row, col - 1], path_so_far.clone]) if col > 0 && map.dig(row, col - 1) == altitude + 1 # west
      queue.push([[row, col + 1], path_so_far.clone]) if col < max_col && map.dig(row, col + 1) == altitude + 1 # east
    end
  end

  trailpaths.length
end


# yay it's search day
def part1(input)
  map = parse(input)
  trailheads = findTrailheads(map)
  trailheads.map { |point| trailscore(point, map) }.sum
end

def part2(input)
  map = parse(input)
  trailheads = findTrailheads(map)
  trailheads.map { |point| trailrating(point, map) }.sum
end


challenge = File.read("day10.txt")
puts "Part 1"

puts "Expect: Score 2"
p part1(score2)

puts "Expect: Score 3"
p part1(score3)

puts "Expect: Score 4"
p part1(score4)

puts "Expect: Score 36"
p part1(score36)

puts "Expect: ??"
p part1(challenge)

puts "Part 2"
puts "Expect: 3"
p part2(rating3)

puts "Expect: 13"
p part2(rating13)

puts "Expect: 227"
p part2(rating227)

puts "Expect: 81"
p part2(score36)

puts "Expect: ??"
p part2(challenge)