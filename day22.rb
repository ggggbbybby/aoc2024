example = 123

@secret_cache = {}
def nextSecret(seed)
  return @secret_cache[seed] if @secret_cache.key?(seed)

  value = ((seed * 64) ^ seed) % 16777216
  #p seed
  value =  ((value / 32) ^ value) % 16777216
  # seed
  value = ((value * 2048) ^ value) % 16777216
  @secret_cache[seed] = value

  value
end

def part1(input, next_count)
  seed = input
  next_count.times { seed = nextSecret(seed) }
  seed
end

def resetSequenceCache
  @sequence_cache = Hash.new(0)
end

def warmSequenceCache(input, next_count)
  # while we are calculating the next secret, keep track of the previous 4 numbers and cache the sale price
  seen = Set.new
  seed = input
  sequence = [input % 10]
  next_count.times {
    seed = nextSecret(seed)
    sequence << seed % 10
    # p sequence
    if sequence.length == 5
      differences = sequence.each_cons(2).map { |x, y| y - x }

      # we can only add the first price change for this sequence to the cache
      # bc each buyer only buys one hiding spot
      if !seen.include?(differences)
        @sequence_cache[differences] += sequence.last
        seen << differences
      end
      
      # drop the oldest entry on the sequence before continuing
      sequence.shift
    end
  }
end

def part2(inputs, next_count)
  resetSequenceCache

  inputs.each { |input| warmSequenceCache(input, next_count) }
  puts "Done warming up the cache"

  best_sequence = @sequence_cache.max_by {|k, v| v }
  puts "Best Sequence: #{best_sequence.inspect}"

  best_sequence[1]
end

puts "Part 1"
# puts part1(example, 10)
# puts part1(1, 2000) + part1(10, 2000) + part1(100, 2000) + part1(2024, 2000)

# p part2([1, 2, 3, 2024], 2000)

challenge = File.read("day22.txt").split("\n").map(&:to_i)
p challenge.inject(0) { |total, input| total + part1(input, 2000) }

puts "Part 2"
p part2(challenge, 2000)