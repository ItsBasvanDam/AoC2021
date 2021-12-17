# part 1 & 2
arr = File.readlines("input").map(&:chomp).map { |l| l.split(" -> ") }
counts1, counts2 = Hash.new(0), Hash.new(0)
arr.each do |set|
  p1 = set[0].split(",").map &:to_i
  p2 = set[1].split(",").map &:to_i
  c = p1.zip(p2)
  if p1[0] == p2[0] or p1[1] == p2[1]
    (c[0].min..c[0].max).each do |x|
      (c[1].min..c[1].max).each do |y|
        counts1[[x, y]] += 1
        counts2[[x, y]] += 1
      end
    end
  else
    a = (p2[0] - p1[0]) / (p2[1] - p1[1])
    b = -a * p1[0] + p1[1]
    (c[0].min..c[0].max).each do |x|
      counts2[[x, x * a + b]] += 1
    end
  end
end
puts counts1.count { |c| c[1] > 1 }
puts counts2.count { |c| c[1] > 1 }
