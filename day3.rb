example = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

def part1(input)
  matches = input.scan(/mul\((\d+),(\d+)\)/)
  matches.inject(0) { |total, (x, y)| total + (x.to_i * y.to_i)}
end

puts "Part 1"
p part1(example)

challenge = File.read('day3.txt')
p part1(challenge)

example = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
def part2(input)
  doing = true
  i = 0
  total = 0
  
  chunks = input.split(/(do(n't)?\(\))/)
  while i < chunks.length
    #p chunks[i]
    if chunks[i] == "don't()"
      #puts "it's a dont, skipping to #{chunks[i+2]}"
      doing = false
      i += 2
      next
    end

    if chunks[i] == "do()"
      #puts "it's a do, skipping to #{chunks[i+1]}"
      doing = true
      i += 1
      next
    end
    
    #puts "it's a chunk, found #{part1(chunks[i])}" if doing
    total += part1(chunks[i]) if doing
    i += 1
  end

  total
end

puts "Part 2"
p part2(example)
p part2(challenge)