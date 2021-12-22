instructions = File.readlines("input").map(&:chomp).map do |l|
  power, cube = l.split(" ")
  [cube.split(",").map { |c| eval(c[2..-1]) }, power == "on"]
end

# assumes ranges are ascending, returns the difference between the first and second range
def range_subtract(base, subtract)
  l = subtract.first
  r = subtract.last
  # there can be at most 2 parts as a result
  first = case l <=> base.first + 1
    when -1 then nil
    when 0 then base.first
    else
      l < base.last + 1 ? (base.first..(l - 1)) : base
    end
  second = case base.last <=> r + 1
    when -1 then nil
    when 0 then base.last
    else
      r + 1 > base.first ? (r + 1..base.last) : base
    end
  # convert pure integer ranges to an actual range object
  return [first, second].compact.map! { |n| n.is_a?(Integer) ? (n..n) : n }
end

def ranges_overlap?(r1, r2)
  return r2.begin <= r1.end && r1.begin <= r2.end
end

def cubes_overlap?(cube1, cube2)
  x1, y1, z1 = cube1
  x2, y2, z2 = cube2
  return ranges_overlap?(x1, x2) && ranges_overlap?(y1, y2) && ranges_overlap?(z1, z2)
end

def cube_volume(cube)
  return cube.map(&:size).reduce :*
end

def intersect_ranges(r1, r2)
  new_end = [r1.end, r2.end].min
  new_begin = [r1.begin, r2.begin].max
  return (new_begin..new_end)
end

def cube_subtract(base, subtract)
  # quick return
  return [base] unless cubes_overlap?(base, subtract)
  # actually subtract the two cubes, because we know they overlap somewhere
  cuboids = []
  x1, y1, z1 = base
  x2, y2, z2 = subtract
  xd = range_subtract(x1, x2)
  yd = range_subtract(y1, y2)
  zd = range_subtract(z1, z2)
  x_overlap = intersect_ranges(x1, x2)
  y_overlap = intersect_ranges(y1, y2)
  z_overlap = intersect_ranges(z1, z2)
  # based on the subtracted cuboid, we construct cuboids around the newly created void.
  xd.each { |xr| cuboids.push([xr, y1, z1]) }
  yd.each { |yr| cuboids.push([x_overlap, yr, z1]) }
  zd.each { |zr| cuboids.push([x_overlap, y_overlap, zr]) }
  return cuboids
end

# part 1
cubes_on = []
instructions.each do |cube, turn_on|
  break if cube[0].min < -50 || cube[0].min > 50 # skip ranges outside the -50..50 range
  # even when the cube should turn on, overlaps should still be removed, to avoid duplicates.
  cubes_on = cubes_on.flat_map { |c| cube_subtract(c, cube) }
  cubes_on.push(cube) if turn_on # add only when turning on.
end
# add the volumes of all cubes_on, effectively counting the individual cubes that are on.
puts cubes_on.map { |c| cube_volume(c) }.reduce :+

# part 2
cubes_on = []
instructions.each do |cube, turn_on|
  # even when the cube should turn on, overlaps should still be removed, to avoid duplicates.
  cubes_on = cubes_on.flat_map { |c| cube_subtract(c, cube) }
  cubes_on.push(cube) if turn_on # add only when turning on.
end
# add the volumes of all cubes_on, effectively counting the individual cubes that are on.
puts cubes_on.map { |c| cube_volume(c) }.reduce :+
