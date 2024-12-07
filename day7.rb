example = <<TXT
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
TXT

small_example = <<TXT
190: 10 19
TXT

def parseEquations(input)
  input.split("\n").map do |row|
    total, parts = row.split(": ")
    [total.to_i, parts.split(" ").map(&:to_i)]
  end
end

def canTotal?(total, parts)
  # ah it's our first recursive solution
  return total == parts[0] if parts.length == 1

  canTotal?(total, [parts[0] + parts[1], *parts[2..]]) || canTotal?(total, [parts[0] * parts[1], *parts[2..]])
end

def part1(input)
  eqns = parseEquations(input)
  eqns.select { |total, parts| canTotal?(total, parts) }.map(&:first).sum
end

puts "Part 1"
p part1(example)

challenge = File.read("day7.txt")
p part1(challenge)

puts "Part 2"


def part2(input)
  eqns = parseEquations(input)
  eqns.select { |total, parts| canTotalPart2?(total, parts) }.map(&:first).sum
end

def canTotalPart2?(total, parts)
  return total == parts[0] if parts.length == 1

  canTotalPart2?(total, [parts[0] + parts[1], *parts[2..]]) || 
  canTotalPart2?(total, [parts[0] * parts[1], *parts[2..]]) || 
  canTotalPart2?(total, [(parts[0].to_s + parts[1].to_s).to_i, *parts[2..]])
end


p part2(example)
p part2(challenge)
