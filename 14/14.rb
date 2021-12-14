info = File.readlines("input").map &:chomp
ops = info[2..-1].map { |i| a, b = i.split(" -> "); [a.split(""), b] }

# part 1 & 2
start = info[0].split("")
pairs_lookup, pairs, amounts = {}, Hash.new(0), Hash.new(0)
ops.each { |o| pairs_lookup[o[0].join] = o[1] }
start[0...-1].each_index { |i| pairs["#{start[i]}#{start[i + 1]}"] += 1 }
start[0..-1].each { |c| amounts[c] += 1 }
(1..40).each do |s|
  new_pairs = Hash.new(0)
  pairs_lookup.entries.each do |pair, char|
    # not all pairs result in polymer extension, check if this one does
    if pairs[pair] != nil
      new_pairs["#{pair[0]}#{char}"] += pairs[pair]
      new_pairs["#{char}#{pair[1]}"] += pairs[pair]
      amounts[char] += pairs[pair]
    end
  end
  pairs = new_pairs
  if s == 10 || s == 40
    min, max = amounts.values.minmax
    puts max - min
  end
end
