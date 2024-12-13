require 'pry'
abcdexample = <<TXT
AAAA
BBCD
BBCC
EEEC
TXT


ox_example = <<TXT
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
TXT

large_example = <<TXT
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
TXT

ex_example = <<TXT
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
TXT

ab_example = <<TXT
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
TXT

def parse(input)
  input.split("\n").map { |row| row.split("") }
end

def find_contiguous(char, coords, map)
  # it's kind of a BFS situation. find all the reachable plots with the same letter
  visited = Set.new
  queue = [coords]
  same_letter = Set.new

  max_row = map.length
  max_col = map.first.length

  while queue.length > 0
    row, col = *(queue.shift)
    next if visited.include?([row, col])
    visited << [row, col]

    plot_type = map.dig(row, col)
    same_letter << [row, col] if plot_type == char
    
    # add any adjacent blocks with the same letter to the queue
    queue.push([row - 1, col]) if row > 0 && map.dig(row - 1, col) == char
    queue.push([row + 1, col]) if row < max_row && map.dig(row + 1, col) == char
    queue.push([row, col - 1]) if col > 0 && map.dig(row, col - 1) == char
    queue.push([row, col + 1]) if col < max_col && map.dig(row, col + 1) == char
  end

  same_letter
end

def findRegions(map)
  # how to represent these? let's start with the coords of all of the plots?
  
  accounted_for = Set.new
  regions = []

  map.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
      next if accounted_for.include?([row_idx, col_idx])

      region = find_contiguous(col, [row_idx, col_idx], map)
      accounted_for.merge(region)
      regions << region
    end
  end

  regions
end

def perimeter(region)
  # hm. I'm sure there's a smart way to do this but this is simple and it works. stupid, but simple.
  # if it has an area of 1, then it has a perimeter of 4
  # if it has an area of 2, then it has a perimeter of 7 because one edge is shared
  # and so on
  seen = Set.new
  region.inject(0) do |total, (row, col)|
    # how many areas in seen is this one adjacent to?
    shared_edges = [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]].count do |adjacent|
      region.include?(adjacent) && !seen.include?(adjacent)
    end
    total + (4 - shared_edges)
  end
end

def cornerCount(region, map)
  # fun fact: the number of sides is the same as the number of corners
  # thanks math 
  # actually fuck math. that's bullshit. 
  # don't come around here with your little proofs. your lemmas. math is dumb as hell.

  region.map { |coords| corners(coords, map) }.sum
end


def corners(coords, map)
  row, col = *coords
  region_type = map.dig(row, col)

  north = row > 0 && map.dig(row - 1, col) == region_type
  south = row < map.length && map.dig(row + 1, col) == region_type
  east = col < map.first.length && map.dig(row, col + 1) == region_type
  west = col > 0 && map.dig(row, col - 1) == region_type
  
  north_east = north && east && map.dig(row - 1, col + 1)
  north_west = north && west && map.dig(row - 1, col - 1)
  south_east = south && east && map.dig(row + 1, col + 1)
  south_west = south && west && map.dig(row + 1, col - 1)
  diagonals = [north_east, north_west, south_east, south_west].select { |d| d && d != region_type }

  case [north, south, east, west].count(&:itself)
  when 0
    4
  when 1
    2
  when 2
    if north && south || east && west
      0
    else
      # check the diagonal to see if it's part of the same region
      diagonals.length > 0 ? 2 : 1
    end
  else
    diagonals.length
  end
end

def area(region)
  region.length
end

def part1(input)
  map = parse(input)
  regions = findRegions(map)
  regions.map { |region| perimeter(region) * area(region) }.sum
end

def part2(input)
  map = parse(input)
  regions = findRegions(map)
  regions.map { |region| cornerCount(region, map) * area(region) }.sum
end

challenge = File.read("day12.txt")
puts "Part 1"
p part1(abcdexample) # 140
p part1(ox_example) # 772
p part1(large_example) # 1930
p part1(challenge) 

puts "Part 2"
p part2(abcdexample) # 80
p part2(ox_example) # 436
p part2(ex_example) # 236
p part2(ab_example) # 368
p part2(large_example) # 1206
p part2(challenge)