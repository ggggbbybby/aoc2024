require 'pry'

small_example = <<TXT
..X...
.SAMX.
.A..A.
XMAS.S
.X....
TXT

example = <<TXT
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
TXT

def parseChars(input)
  parseRows(input).map { |row| row.split("") }
end

def parseRows(input)
  input.split("\n")
end

def parseCols(input)
  chars = parseChars(input)
  count = chars.length
  (0...count).map { |i| chars.map { |row| row[i] }.join }
end

def parseDiagTLBR(input)
  chars = parseChars(input)

  # a diagonal can start at any letter without another letter NW of it
  # so letter on the top row, and letter on the left side

  # 0,0 1,1 2,2 3,3 4,4
  # 1,0 2,1 3,2 4,3
  # 2,0 3,1 4,2
  # 3,0 4,1
  # 4,0

  left_side = (0...chars.length).map do |i|
    # p (0...(chars.length - i)).map.with_index { |j, offset| [i+offset, j] }
    (0...(chars.length - i)).map.with_index { |j, offset| chars[i+offset][j] }.join
  end
  # p left_side

  # 0,1 1,2 2,3 3,4 4,5
  # 0,2 1,3 2,4 3,5
  # 0,3 1,4 2,5
  # 0,4 1,5
  # 0,5
  top_side = (1...chars[0].length).map do |j|
    # p (0..(chars.length - j)).map.with_index { |i, offset| [i, j+offset] }
    (0..(chars.length - j)).map.with_index { |i, offset| chars[i][j+offset] }.join
  end

  left_side + top_side
end

def parseDiagBLTR(input)
  chars = parseChars(input)

  # diagonals can start on the left or on the bottom

  # 0,0
  # 1,0 0,1
  # 2,0 1,1 0,2
  # 3,0 2,1 1,2 0,3
  # 4,0 3,1 2,2 1,3 0,4
  left_side = (0...chars.length).map do |i|
    # p (0..i).map.with_index { |j, offset| [i - offset, j] }
    (0..i).map.with_index { |j, offset| chars[i - offset][j] }.join
  end

  # 4,1 3,2 2,3 1,4 0,5
  # 4,2 3,3 2,4 1,5
  # 4,3 3,4 2,5
  # 4,4 3,5
  # 4,5
  bottom_side = (1...chars[0].length).map do |j|
    # p (chars.length-1).downto(j-1).map.with_index { |i, offset| [i, j + offset]}
    (chars.length-1).downto(j-1).map.with_index { |i, offset| chars[i][j + offset] }.join 
  end
  
  left_side + bottom_side
end

def part1(input)
  # going to try something slightly different than usual
  # we're going to scan strings instead of 2D arrays
  # each parseX method returns an array of strings we can scan for XMAS or SMAX
  rows = parseRows(input)
  cols = parseCols(input)
  diagTLBR = parseDiagTLBR(input)
  diagBLTR = parseDiagBLTR(input)

  search_space = rows + cols + diagTLBR + diagBLTR
  search_space.map { |str| str.scan("XMAS").length + str.scan("SAMX").length }.sum
end

puts "Part 1"
puts part1(small_example)
puts part1(example)

challenge = File.read('day4.txt')
puts part1(challenge)

# part 2
# aw dang nothing carries over
# scanning for chunks that look like one of these four

# M.S  S.S  S.M  M.M
# .A.  .A.  .A.  .A.
# M.S  M.M  S.M  S.S

def part2(input)
  chars = parseChars(input)

  count = 0
  (0...(chars.length - 2)).each do |i|
    (0...(chars[0].length - 2)).each do |j|
      count += 1 if (chars[i][j] == 'M') && (chars[i][j+2] == 'S') && (chars[i+1][j+1] == 'A') && (chars[i+2][j] == 'M') && (chars[i+2][j+2] == 'S')
      count += 1 if (chars[i][j] == 'S') && (chars[i][j+2] == 'S') && (chars[i+1][j+1] == 'A') && (chars[i+2][j] == 'M') && (chars[i+2][j+2] == 'M')
      count += 1 if (chars[i][j] == 'S') && (chars[i][j+2] == 'M') && (chars[i+1][j+1] == 'A') && (chars[i+2][j] == 'S') && (chars[i+2][j+2] == 'M')
      count += 1 if (chars[i][j] == 'M') && (chars[i][j+2] == 'M') && (chars[i+1][j+1] == 'A') && (chars[i+2][j] == 'S') && (chars[i+2][j+2] == 'S')
    end
  end

  count
end

puts "\nPart 2"
puts part2(example)
puts part2(challenge)