# day 1
require 'pry'

example = <<TXT
3   4
4   3
2   5
1   3
3   9
3   3
TXT

# part 1
# Pair up the smallest number in the left list with the smallest number in the right list, then the second-smallest left number with the second-smallest right number, and so on.

def parse_lists(input)
  rows = input.split("\n")
  rows.each_with_object([[], []]) do |row, (left, right)| 
    lr, rr = row.split(/\s+/)
    left << lr.to_i
    right << rr.to_i
  end
end

def part1(input)
  left_list, right_list = parse_lists(input).map(&:sort)
  zipped_lists = left_list.zip(right_list)
  #binding.pry
  zipped_lists.map { |left, right| (left - right).abs }.sum
end

puts "Part 1"
#puts parse_lists(example).inspect
puts part1(example).inspect

challenge_input = File.read('input1.txt')
puts part1(challenge_input).inspect

# part 2
# Calculate a total similarity score by adding up each number in the left list after multiplying it by the number of times that number appears in the right list.

def part2(input)
  left_list, right_list = parse_lists(input)
  frequencies = right_list.each_with_object(Hash.new { |h, k| h[k] = 0 }) { |item, memo| memo[item] += 1 }
  left_list.inject(0) { |total, item| total + (item * frequencies[item]) }
end

puts "Part 2"

p part2(example)
p part2(challenge_input)