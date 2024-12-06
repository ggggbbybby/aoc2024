example = <<TXT
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
TXT

def part1(input)
  rules_rows, updates_rows = input.split("\n\n")
  rules = parseRules(rules_rows)
  updates = parseUpdates(updates_rows)

  updates.inject(0) do |total, update|
    rules_broken = rulesBroken(update, rules)
    if rules_broken.empty?
      midpoint = update.length / 2
      total + update[midpoint].to_i
    else
      total
    end
  end
end

def parseRules(rules_input)
  rules_input.split("\n").map { |rule_row| rule_row.split("|") }
end

def parseUpdates(updates_input)
  updates_input.split("\n").map { |row| row.split(",") }
end

def breaksAnyRule?(page, rest, rules)
  rest.any? do |next_page|
    rules.any? do |before, after|
      before == next_page && after == page
    end
  end
end

def breaksThisRule?(page, rest, rule)
  before, after = rule
  rest.any? { |next_page| before == next_page && after == page }
end

def rulesBroken(update, rules)
  rules.select do |rule|
    !update.select.with_index { |page, idx| breaksThisRule?(page, update[idx+1..], rule) }.empty?
  end
end

puts "Part 1"
p part1(example)

challenge = File.read("day5.txt")
#p part1(challenge)

very_small_example = <<TXT
29|13

61,13,29
TXT

def part2(input)
  rules_rows, updates_rows = input.split("\n\n")
  rules = parseRules(rules_rows)
  updates = parseUpdates(updates_rows)

  # find the updates that are incorrect
  # and fix them
  # then get the midpoints

  fixed_updates = updates.map do |update|
    rules_broken = rulesBroken(update, rules)
    next if rules_broken.empty?

    new_order = update
    while !rules_broken.empty?
      # try swapping the before & after in the array
      before, after = rules_broken.first
      new_order[update.index(before)] = after
      new_order[update.index(after)] = before

      rules_broken = rulesBroken(new_order, rules)
    end
    new_order
  end

  fixed_updates.compact.inject(0) do |total, update|
    midpoint = update.length / 2
    total + update[midpoint].to_i
  end
end

puts "Part 2"
p part2(very_small_example)
p part2(example)
p part2(challenge)