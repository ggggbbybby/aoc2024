example = <<TXT
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
TXT

one_pair_example = <<TXT
..........
...#......
..........
....a.....
..........
.....a....
..........
......#...
..........
..........
TXT

two_pair_example = <<TXT
..........
...#......
#.........
....a.....
........a.
.....a....
..#.......
......#...
..........
..........
TXT

part2_example = <<TXT
T....#....
...T......
.T....#...
.........#
..#.......
..........
...#......
..........
....#.....
..........
TXT

challenge = File.read("day8.txt")

def parseInput(input)
  input.split("\n").map { |row| row.split("") }
end

def findAntennas(map)
  antennas = Hash.new {|h, k| h[k] = []}
  map.each.with_index do |row, row_idx|
    row.each.with_index do |col, col_idx|
      next if col == '.' || col == '#'
      antennas[col] << [row_idx, col_idx]
    end
  end

  antennas
end

def findAntinodes(a, b)
  ax, ay = *a
  bx, by = *b

  dx = (ax - bx).abs
  dy = (ay - by).abs

  # many possible directions for this line to go in
  # I feel like this should be possible to do with a min(ax, bx) but I think I need to take slope into account? hmm.
  if ax < bx 
    if ay < by
      return [[ax - dx, ay - dy], [bx + dx, by + dy]]
    elsif ay == by
      return [[ax - dx, ay], [bx + dx, by]]
    else # ay > by
      return [[ax - dx, ay + dy], [bx + dx, by - dy]]
    end
  end 

  if ax == bx
    if ay < by
      return [[ax, ay - dy], [bx, by + dy]]
    elsif ay == by # hmmm
      raise "non-uniq antenna coords???"
    else # ay > by
      return [[ax, ay + dy], [bx, by - dy]]
    end
  end

  if ax > bx
    if ay < by
      return [[ax + dx, ay - dy], [bx - dx, by + dy]]
    elsif ay == by
      return [[ax + dx, ay], [bx - dx, by]]
    else # ay > by
      [[ax + dx, ay + dy], [bx - dx, by - dy]]
    end
  end
end

def part1(input)
  # let's group the antennas by frequency first
  map = parseInput(input)
  antennas = findAntennas(map)

  maxX = map.length - 1
  maxY = map.first.length - 1

  # every pair of frequency-matched antennas creates 2 antinodes
  # (except for the ones that are out of bounds)
  locations = antennas.each_with_object(Set.new) do |(freq, locations), antinodes|
    pairs = locations.combination(2)
    pairs.flat_map {|p1, p2| findAntinodes(p1, p2).select { |x, y| (0..maxX).include?(x) && (0..maxY).include?(y) } }.each { |loc| antinodes.add(loc) }
  end
end

def inline?(p1, p2, p3)
  return true if p1 == p3 || p2 == p3

  # p1 and p2 define a line
  # how do we know if p3 is on that line?
  # y = mx + b right
  # or actually we can use the much less elegant "two point form"
  # (y - y1) / (x - x1) = (y2 - y1)/(x2 - x1)

  (p3.first - p1.first).to_f / (p3.last - p1.last) == (p2.first - p1.first).to_f / (p2.last - p1.last) 
end

def part2(input)
  map = parseInput(input)
  antennas = findAntennas(map)

  # so now every spot in the array _could_ be an antinode if it lines up with 2 or more antennas
  # that's great. that's easier math. (I hope)
  # I just need a function that takes in three points and tells me if they're all on the same line

  pairs = antennas.values.flat_map { |locations| locations.combination(2).to_a }
  locations = []
  map.each.with_index do |row, row_idx|
    row.each.with_index do |col, col_idx|
      locations << [row_idx, col_idx] if pairs.any? { |p1, p2| inline?(p1, p2, [row_idx, col_idx]) }
    end
  end

  locations
end

puts "Part 1"
p part1(one_pair_example)
p part1(two_pair_example)
p part1(example)

p part1(challenge).length

puts "Part 2"
p part2(part2_example).length
p part2(example).length
p part2(challenge).length