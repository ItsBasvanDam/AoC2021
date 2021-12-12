connections = {}
File.readlines("input").map do |l|
  from, to = l.chomp.split("-")
  connections[from] = [] if connections[from] == nil
  connections[from].push(to)
  connections[to] = [] if connections[to] == nil
  connections[to].push(from)
end

def single_small_cave(path, cave)
  small_caves = path.filter { |e| /[[:lower:]]/.match(e) }
  pair = small_caves.group_by { |c| c }.values.any? { |a| a.size == 2 }
  if pair
    return path.count { |c| c == cave } < 1
  else
    return true
  end
end

def walk_paths_recurse(conns, curr, path, paths, checker)
  pa = path.dup
  pa.push(curr)
  if curr == "end"
    paths.push(pa)
    return
  end
  conns[curr].each do |out|
    walk_paths_recurse(conns, out, pa, paths, checker) if checker.call(pa, out)
  end
end

part_1_requirements = ->(pa, out) do
  large_cave = /[[:upper:]]/.match(out) != nil
  return out == "end" || large_cave || (!large_cave && !pa.include?(out))
end
part_2_requirements = ->(pa, out) do
  large_cave = /[[:upper:]]/.match(out) != nil
  return out == "end" || (out != "start" && (large_cave || single_small_cave(pa, out)))
end

# part 1 & 2
[part_1_requirements, part_2_requirements].each do |r|
  paths = []
  walk_paths_recurse(connections, "start", [], paths, r)
  puts paths.size
end
