connections = {}
File.readlines("input").map do |l|
  from, to = l.chomp.split("-")
  connections[from] = [] if connections[from] == nil
  connections[from].push(to)
  connections[to] = [] if connections[to] == nil
  connections[to].push(from)
end

def walk_paths_recurse(conns, curr, path, paths, checker, has_duplicate = false, duplicate = nil)
  pa = path.dup
  duplicate = curr if pa.include?(curr) && /[[:lower:]]/.match(curr) && duplicate == nil
  has_duplicate = duplicate != nil
  pa.push(curr)
  if curr == "end"
    paths.push(pa)
    return
  end
  conns[curr].each do |out|
    walk_paths_recurse(conns, out, pa, paths, checker, has_duplicate, duplicate) if checker.call(pa, out, has_duplicate, duplicate)
  end
end

part_1_requirements = ->(pa, out, has_duplicate, duplicate) do
  large_cave = /[[:upper:]]/.match(out) != nil
  return out == "end" || large_cave || (!large_cave && !pa.include?(out))
end
part_2_requirements = ->(pa, out, has_duplicate, duplicate) do
  large_cave = /[[:upper:]]/.match(out) != nil
  return out == "end" || (out != "start" && (large_cave || (!has_duplicate || (duplicate != out && !pa.include?(out)))))
end

# part 1 & 2
[part_1_requirements, part_2_requirements].each do |r|
  paths = []
  walk_paths_recurse(connections, "start", [], paths, r)
  puts paths.size
end
