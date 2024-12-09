small_example = "12345"
example = "2333133121414131402"

challenge = File.read("day9.txt")

def parse(input)
  input.split("").map(&:to_i)
end

def pretty_print(blocks)
  blocks.inject("") do |str, block|
    str + (block[:id] || ".").to_s * block[:length]
  end
end

def expand(digits)
  id = 0
  file = true

  # I don't think representing these as a string is actually a great idea. 
  # we are going to have multi-digit ids and those will be hard to track in a compacted string
  digits.each_with_object([]) do |digit, memo|
    memo << {id: (file ? id : nil), length: digit}
    
    # update loop state because we have loop state >:|
    id += file ? 1 : 0
    file = !file
  end
end

def compact(blocks)
  # remove any empty blocks at the end of the list because we don't need to keep track of them anymore
  while blocks.last[:id].nil? || blocks.last.length <= 0
    blocks.pop
  end
  
  # we want to move as much of the last file to the first gap in the list
  first_gap_idx = blocks.index { |block| block[:id].nil? && block[:length] > 0 }
  return blocks if first_gap_idx.nil?

  last_file_idx = blocks.length - 1

  gap_remaining = blocks[first_gap_idx][:length] - blocks[last_file_idx][:length]

  # we're always going to fill in the first gap with the new ID so do that & update the length on the last block
  blocks[first_gap_idx][:id] = blocks[last_file_idx][:id]
  blocks[first_gap_idx][:length] = [blocks[first_gap_idx][:length], blocks[last_file_idx][:length]].min
  blocks[last_file_idx][:length] -= blocks[first_gap_idx][:length]

  # remove the last block if we've moved it completely
  blocks.pop if blocks[last_file_idx][:length] <= 0

  # insert a new block after the old "first gap" if we have any gap remaining
  blocks.insert(first_gap_idx + 1, {id: nil, length: gap_remaining}) if gap_remaining > 0
  
  # and do it again until it's finished
  # puts pretty_print(blocks)
  compact(blocks)
end

def compact_without_fragmentation(blocks)
  # for each file, try to find a gap where it fits
  # if it can't fit in any gaps, don't move it

  # we still don't need to keep track of any empty blocks at the end of the array
  while blocks.last[:id].nil? || blocks.last.length <= 0
    blocks.pop
  end

  last_file_idx = blocks.length - 1
  last_file_id = blocks[last_file_idx][:id]

  while last_file_id > 0 do
    last_file = blocks[last_file_idx]
    last_file_id = blocks[last_file_idx][:id]

    # find the first gap large enough for this file
    first_gap_idx = blocks.index { |block| block[:id].nil? && block[:length] >= last_file[:length] }
    if !first_gap_idx.nil? && first_gap_idx < last_file_idx
      # there is a gap large enough for the file to move to
      # puts "Moving block with ID #{last_file_id} and length #{blocks[last_file_idx][:length]} to index #{first_gap_idx}"

      gap_remaining = blocks[first_gap_idx][:length] - last_file[:length]
      blocks[first_gap_idx][:id] = last_file[:id]
      blocks[first_gap_idx][:length] = [last_file[:length], blocks[first_gap_idx][:length]].min
      blocks[last_file_idx][:id] = nil
      blocks.insert(first_gap_idx + 1, {id: nil, length: gap_remaining}) if gap_remaining > 0
    end

    last_file_id -= 1
    last_file_idx = blocks.index { |block| block[:id] == last_file_id }

    # p pretty_print(blocks)
  end
  blocks 
end

def checksum(blocks)
  # you _cannot_ use pretty print here. duh.

  # turn our blocks into an expanded array that we can sum up
  blocks.inject([]) do |memo, block|
    memo + [block[:id] || 0] * block[:length]
  end.each_with_index.inject(0) do |sum, (block, idx)|
    sum + (block * idx)
  end
end

def part1(input)
  # we're ... fragging their elf harddrives
  # ok. sure. why not.

  checksum(compact(expand(parse(input))))
end

def part2(input)
  checksum(compact_without_fragmentation(expand(parse(input))))
end

puts "Part 1"
p part1(small_example)
puts
p part1(example)
# p part1(challenge)

puts "Part 2"
p part2(example)
p part2(challenge)