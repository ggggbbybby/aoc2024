small_example = "0 1 10 99 999"
medium_example = "125 17"

def parse(input)
  input.split(" ")
end

def blink(stones, count)
  while count > 0
    stones = stones.inject([]) do |memo, stone|
      if stone =~ /^0+$/
        memo.push('1')
      elsif stone.length % 2 == 0
        half = stone.length / 2
        left = stone[0...half]
        right = stone[half..].to_i.to_s
        memo.concat([left, right])
      else
        memo.push((stone.to_i * 2024).to_s)
      end
      memo
    end
    count -=1 
  end

  stones
end

def blinkTally(stones, count)
  # keep track of stone counts, not individual stones
  stone_counts = stones.tally
  
  depth = 0
  while depth < count
    depth += 1
    stone_counts = stone_counts.inject(Hash.new { |h, k| h[k] = 0 }) do |memo, (stone, stone_count)|
      if stone == '0'
        memo['1'] += stone_count
      elsif stone.length % 2 == 0
        half = stone.length / 2
        left = stone[0...half]
        right = stone[half..].to_i.to_s
        memo[left] += stone_count
        memo[right] += stone_count
      else
        memo[(stone.to_i * 2024).to_s] += stone_count
      end

      memo
    end
  end

  stone_counts
end

challenge = File.read('day11.txt')

puts "Part 1"

puts "Expect 1 2024 1 0 9 9 2021976"
p blink(parse(small_example), 1)

puts "Expect 253000 1 7"
p blink(parse(medium_example), 1)

puts "Expect 253 0 2024 14168"
p blink(parse(medium_example), 2)

puts "Expect 512072 1 20 24 28676032"
p blink(parse(medium_example), 3)

puts "Expect 512 72 2024 2 0 2 4 2867 6032"
p blink(parse(medium_example), 4)

puts "Expect 22"
p blink(parse(medium_example), 6).length

puts "Expect 55312"
p blink(parse(medium_example), 25).length

puts "Expect ??"
# p blink(parse(challenge), 25).length

puts "Part 2"

puts "Expect 1 2024 1 0 9 9 2021976"
p blinkTally(parse(small_example), 1)

puts "Expect 253000 1 7"
p blinkTally(parse(medium_example), 1)

puts "Expect 253 0 2024 14168"
p blinkTally(parse(medium_example), 2)

puts "Expect 512072 1 20 24 28676032"
p blinkTally(parse(medium_example), 3)

puts "Expect 512 72 2024 2 0 2 4 2867 6032"
p blinkTally(parse(medium_example), 4)

puts "Expect 5"
p blinkTally(parse(medium_example), 3).values.sum

puts "Expect 9"
p blinkTally(parse(medium_example), 4).values.sum

puts "5 steps"
p blink(parse(medium_example), 5)
p blinkTally(parse(medium_example), 5)

puts "Expect 22"
p blink(parse(medium_example), 6).length
p blinkTally(parse(medium_example), 6).values.sum

puts "Expect 55312"
p blinkTally(parse(medium_example), 25).values.sum

puts "Expect ??"
p blinkTally(parse(challenge), 75).values.sum