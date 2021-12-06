lines = File.readlines("input").map &:chomp
nums = lines.shift.split(",").map &:to_i
lines = lines.find_all { |l| !l.empty? }
boards = []
lines.each_slice(5) { |b| boards.push(b.map { |r| r.split.map &:to_i }) }

# part 1 & 2
numhist = []
got_first_winner = false
nums.each do |n|
  numhist.push(n)
  break unless boards.each do |b|
    if b.any? { |r| numhist.sort & r.sort == r.sort } || b.transpose.any? { |r| numhist.sort & r.sort == r.sort }
      if boards.size == 1 || !got_first_winner
        got_first_winner = true
        puts (b.flatten - numhist).reduce(:+) * n
      end
      boards.delete(b)
    end
  end
end
