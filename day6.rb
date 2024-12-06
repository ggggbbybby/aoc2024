example = <<TXT
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
TXT

def parseMaze(input)
  input.split.map { |row| row.split("") }
end

def printMaze(maze)
  maze.map(&:join).join("\n")
end

def part1(input)
  maze = parseMaze(input)
  dir = 'N'
  row = maze.index { |row| row.include?("^") }
  col = maze[row].index { |col| col == "^" }

  puts "Starting at #{row}, #{col}"

  while inBounds?(row, col, maze) do
    maze[row][col] = 'X'
    row, col, dir = nextStep(maze, row, col, dir)
    # maze[row][col] = '^'
    # printMaze(maze)
  end

  maze.map { |row| row.count('X') }.sum
end

def inBounds?(row, col, maze)
  (0...maze.length).include?(row) && (0...maze[0].length).include?(col)
end

def nextStep(maze, row, col, dir)
  if dir == 'N'
    nextRow = row - 1
    nextCol = col
  elsif dir == 'E'
    nextRow = row
    nextCol = col + 1
  elsif dir == 'S'
    nextRow = row + 1
    nextCol = col
  elsif dir == 'W'
    nextRow = row
    nextCol = col - 1
  end

  if !inBounds?(nextRow, nextCol, maze)
    return [nextRow, nextCol, dir]
  end

  if maze[nextRow][nextCol] == '#'
    return [row, col, turnRight(dir)]
  else
    return [nextRow, nextCol, dir]
  end
end

def turnRight(dir)
  case dir
  when 'N'
    'E'
  when 'E'
    'S'
  when 'S'
    'W'
  when 'W'
    'N'
  end
end

puts "Part 1"
puts part1(example)

challenge = File.read('day6.txt')
puts part1(challenge)

puts "Part 2"

def part2(input)
  # first, find all of the locations that the guard visits
  maze = parseMaze(input)
  dir = 'N'
  row = maze.index { |row| row.include?("^") }
  col = maze[row].index { |col| col == "^" }
  visited = []

  while inBounds?(row, col, maze) do
    visited << [row, col]
    row, col, dir = nextStep(maze, row, col, dir)
  end
  visited = visited.uniq

  start_row, start_col = visited.shift
  visited.select { |row, col| loops?(maze, start_row, start_col, row, col) }
end

def loops?(maze, row, col, obstacle_row, obstacle_col)
  maze = parseMaze(printMaze(maze)) # make a copy so we can add an obstacle
  maze[obstacle_row][obstacle_col] = '#'
  dir = 'N'

  visits = Hash.new { |h, r| h[r] = Hash.new { |h, c| h[c] = {} } }
  while inBounds?(row, col, maze)
    if visits[row][col][dir]
      return true
    end
    
    visits[row][col][dir] = true
    row, col, dir = nextStep(maze, row, col, dir)
  end

  return false
end

p part2(example).length
p part2(challenge).length