arr = File.readlines('input').map do |x|
  x.chomp.chars.map(&:to_i)
end

# part 1
len = arr[0].length
foo = (0..len - 1).collect { |x| arr.collect { |b| b[x] }.group_by(&:itself).values.max_by(&:size).first }.join
puts foo.to_i(2) * foo.tr('0', '2').tr('1', '0').tr('2', '1').to_i(2)

# part 2
arr = File.readlines('input').map(&:chomp)
(0...arr[0].length).each do |n|
  break if arr.length == 1

  hash = arr.group_by { |s| s[n] }
  res = [hash.values_at('0')[0].length, hash.values_at('1')[0].length]
  selected = res.all? { |q| res.first == q } ? 1 : res.find_index { |r| res.max == r }
  arr = arr.select { |s| s[n] == selected.to_s }
end
o2 = arr[0]
arr = File.readlines('input').map(&:chomp)
(0...arr[0].length).each do |n|
  break if arr.length == 1

  hash = arr.group_by { |s| s[n] }
  res = [hash.values_at('0')[0].length, hash.values_at('1')[0].length]
  selected = res.all? { |q| res.first == q } ? 0 : res.find_index { |r| res.min == r }
  arr = arr.select { |s| s[n] == selected.to_s }
end
co2 = arr[0]

puts o2.to_i(2) * co2.to_i(2)