example = <<TXT
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
TXT

# Part 1
# The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. 
# So, a report only counts as safe if both of the following are true:
# - The levels are either all increasing or all decreasing.
# - Any two adjacent levels differ by at least one and at most three.


def part1(input)
  levels = parse_levels(input)
  levels.count { |level| safe?(level) }
end

def parse_levels(input)
  input.split("\n").map { |row| row.split(/\s+/).map(&:to_i) }
end

def safe?(level)
  increasing = nil
  decreasing = nil
  safe_distances = true
  # p level
  prev = level.shift

  while (increasing.nil? || decreasing.nil?) && safe_distances
    curr = level.shift
    break if curr.nil?
    
    if curr > prev
      increasing = true
    else
      decreasing = true
    end

    distance = (curr - prev).abs
    #puts "distance #{distance} is safe? #{!(distance == 0 || distance > 3)}"
    safe_distances = !(distance == 0 || distance > 3)
  
    prev = curr
  end

  # puts "increasing? #{increasing.inspect}, decreasing? #{decreasing.inspect}, safe_distances? #{safe_distances}"
  # puts "is safe? #{safe_distances && ((increasing.nil? && decreasing) || (increasing && decreasing.nil?))}"
  safe_distances && ((increasing.nil? && decreasing) || (increasing && decreasing.nil?))
end

puts "Part 1"
p part1(example)

challenge = File.read('day2.txt')
p part1(challenge)

# Part 2
# Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

# attempt #1 - unsuccessful
# this approach fails if the second element is a decrease and the third one is an increase eg [52, 51, 54, 57, 59, 62, 64]
# 52 -> 51 sets the direction to decreasing and thinks 51 is safe
# but then 54 looks unsafe to it because the direction changes
def part2(input)
  reports = parse_levels(input)
  reports.select { |report| unsafe_levels(report).length < 2 }
  #reports.count { |report| unsafe_levels(report).length < 2 }
end

def unsafe_levels(report)
  # return a list of levels that cause a report to be unsafe
  increasing = nil
  decreasing = nil
  prev = report.first
  idx = 1
  memo = []

  while idx < report.length do
    curr = report[idx]
    puts "curr is #{curr}, prev is #{prev}"
    
    distance = (curr - prev).abs
    if (distance == 0 || distance > 3) || (curr > prev && decreasing) || (curr < prev && increasing)
      puts "curr is unsafe, adding to memo"
      memo << idx
      idx += 1
      next
    end

    # if we made it to here, this level is safe
    # make sure we set increasing or decreasing & increment the index
    increasing = true if curr > prev
    decreasing = true if curr < prev
    puts "curr is safe, continuing"
    prev = curr
    idx += 1

  end

  memo
end

def part2_bruteforce(input)
  reports = parse_levels(input)
  reports.select { |report| removed = safe_if_you_remove_one(report) ; !removed.nil? }
end

def safe_if_you_remove_one(report)
  (0...report.length).detect { |idx| safe?(report[0, idx] + report[idx + 1, report.length]) }
end

puts "Part 2"
#p part2(challenge).count
#p part2_but_I_hate_it(challenge).count

#right_answer = part2_but_I_hate_it(challenge)
#wrong_answer = part2(challenge)

#false_negatives = right_answer - wrong_answer
#false_positives = wrong_answer - right_answer

#puts "false negatives: #{false_negatives.count}, false_positives: #{false_positives.count}"

# false negatives are the ones that part2 gets wrong. why?
p [52, 51, 54, 57, 59, 62, 64]
p unsafe_levels([52, 51, 54, 57, 59, 62, 64])

# p false_negatives.select { |report| unsafe_levels(report).length < 2 }.count

#problem_input = problem_children.map { |row| row.join(" ") }.join("\n")

#p problem_children.length
#p part2(problem_input).count