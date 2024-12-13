require 'bigdecimal'
require 'bigdecimal/util'
require 'pry'

example = <<TXT
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279

Button A: X+13, Y+44
Button B: X+82, Y+46
Prize: X=8218, Y=14754
TXT

def parse(input)
  machine_text = input.split("\n\n")
  machine_text.map { |mt| parseMachine(mt) }
end

def parseMachine(text)
  rows = text.split("\n")
  ax, ay = rows[0].match(/Button A: X\+(\d+), Y\+(\d+)/)[1..2]
  bx, by = rows[1].match(/Button B: X\+(\d+), Y\+(\d+)/)[1..2]
  px, py = rows[2].match(/Prize: X=(\d+), Y=(\d+)/)[1..2]
  {
    a: [ax.to_d, ay.to_d],
    b: [bx.to_d, by.to_d],
    prize: [px.to_d, py.to_d]
  }
end

def solve(machine)
  prize_x, prize_y = machine[:prize]
  ax, ay = machine[:a]
  bx, by = machine[:b]

  # we want to find A and B such that
  # prize_x = A * ax + B * bx and prize_y = A * ay + B * by and we want to minimize 3*A + B
  # so, time for math:
  const_a = (prize_y - (prize_x * by / bx)) / (ay - (ax * by / bx))
  const_b = (prize_x - ax * const_a) / bx
  [const_a, const_b]
end

def part1(input)
  # why is it always math with these
  # why can't these be solved with like, complicated sql queries
  # I love complicated sql queries
  # this is literally just "solve a word problem"

  machines = parse(input)
  machines.inject(0) do |total, machine| 
    a, b = solve(machine)
    # these numbers aren't exactly round, which seems like it defeats the purpose of bigdecimal? idk.
    total += (a.round(5) % 1 == 0 && b.round(5) % 1 == 0 && a <= 100 && b <= 100) ? (3 * a.round + b.round) : 0
  end
end

def part2(input)
  # now the prize coordinates are just very large
  offset = 10000000000000
  machines = parse(input)
  machines.each { |m| px, py = m[:prize] ; m[:prize] = [px + offset, py + offset] }
  # binding.pry

  machines.inject(0) do |total, machine|
    a, b = solve(machine)
    total += (a.round(5) % 1 == 0 && b.round(5) % 1 == 0) ? (3 * a.round + b.round) : 0
  end
end

puts "Part 1"
p part1(example)

challenge = File.read("day13.txt")
p part1(challenge)

puts "Part 2"
p part2(example)
p part2(challenge)