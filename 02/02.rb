arr = File.readlines('input').map do |x|
  a, b = x.split
  [a, b.to_i]
end

# part 1
x = 0
y = 0
arr.each do |dir, n|
  case dir
  when 'up'       then y -= n
  when 'down'     then y += n
  when 'forward'  then x += n
  end
end

puts x * y

# part 2
x = 0
y = 0
a = 0
arr.each do |dir, n|
  case dir
  when 'up'       then a -= n
  when 'down'     then a += n
  when 'forward'  then x += n
                       y += a * n
  end
end

puts x * y
