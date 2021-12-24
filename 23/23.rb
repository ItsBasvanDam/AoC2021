def parse_part_1
  lines = File.readlines("input").map(&:chomp).map! { |l| l.ljust(13).split("") }.transpose
  parsed = []
  lines.each do |l|
    str = ""
    l.each do |c|
      str += c if c == "."
      if /[A-D]/.match(c)
        str.sub!(".", "")
        str += c
      end
    end
    parsed.push(str) if str.size > 0
  end
  return parsed
end

def parse_part_2
  addins = ["DD", "CB", "BA", "AC"]
  parsed = []
  parse_part_1.each do |l|
    if l == "."
      parsed.push(l)
      next
    end
    parsed.push(l[0] + addins.shift + l[1])
  end
  return parsed
end

def get_first_room_unit(room)
  return room.chars.find { |c| c != "." }
end

def valid_move?(board, from, to)
  valid = true
  from_t, to_t = [from, to].minmax
  (from_t..to_t).each do |i|
    next if i == from
    next if $targets.values.include?(i)
    valid = false unless board[i] == "."
  end
  return valid
end

def room_contains_only_valid_units?(board, unit, room_index)
  room = board[room_index].chars
  return room.count(".") + room.count(unit) == room.size
end

def determine_valid_moves(board, pos)
  unit = board[pos]
  # first, attempt to slot in a unit into its correct room, if there is space
  unless $targets.values.include?(pos)
    dest_index = $targets[unit.to_sym]
    return [dest_index] if valid_move?(board, pos, dest_index) && room_contains_only_valid_units?(board, unit, dest_index)
    return []
  end

  moving_unit = get_first_room_unit(unit)
  # stop if the unit is already in its correct room
  return [] if pos == $targets[moving_unit.to_sym] && room_contains_only_valid_units?(board, moving_unit, pos)

  valid_moves = []
  (0...board.size).each do |dest|
    next if pos == dest
    next if $targets[moving_unit.to_sym] != dest && $targets.values.include?(dest)
    if $targets[moving_unit.to_sym] == dest
      next unless room_contains_only_valid_units?(board, moving_unit, dest)
    end
    valid_moves.push(dest) if valid_move?(board, pos, dest)
  end
  return valid_moves
end

def add_to_room(room, unit)
  room = room.chars
  steps = room.count(".")
  room[steps - 1] = unit
  return room.join, steps
end

# move the unit. returns the resulting board as a copy and the cost of the move
def do_move(board, from, to)
  board_copy = board.dup
  moving_unit = get_first_room_unit(board[from])
  steps = 0

  # process from
  board_copy[from] = board[from].sub(/[A-D]/, ".")
  # count the extra steps needed to walk out of a room
  steps += board_copy[from].count(".") if board_copy[from].size > 1

  # move along the hallway
  steps += (from - to).abs

  # process to
  board_copy[to], more_steps = add_to_room(board[to], moving_unit)
  steps += more_steps if board_copy[to].size > 1

  return board_copy, steps * $energy_costs[moving_unit.to_sym]
end

def determine_all_boards(board)
  boards = Hash.new(Float::INFINITY)
  boards[board.join] = 0
  queue = [board]
  while queue.size > 0
    board = queue.pop
    board.each_with_index do |unit, pos|
      next if get_first_room_unit(unit) == nil
      valid_moves = determine_valid_moves(board, pos)
      valid_moves.each do |move|
        board_copy, move_cost = do_move(board, pos, move)
        new_cost = boards[board.join] + move_cost
        board_copy_signature = board_copy.join
        if new_cost < boards[board_copy_signature]
          boards[board_copy_signature] = new_cost
          queue.push(board_copy)
        end
      end
    end
  end
  return boards
end

# represent the board as a one-dimensional array of strings (the depth of rooms is represented as longer strings)
# like so: ['.', '.', 'AA', '.', 'BB', '.', 'CC', '.', 'DD', '.', '.']
# to solve, we simply cycle through every possible (and valid) board configuration, and cache their costs.
# it is slow, but guaranteed to find the cheapest solution.

$targets = { 'A': 2, 'B': 4, 'C': 6, 'D': 8 }
$energy_costs = { 'A': 1, 'B': 10, 'C': 100, 'D': 1000 }

# part 1
boards = determine_all_boards(parse_part_1)
puts boards["..AA.BB.CC.DD.."]

# part 2
boards = determine_all_boards(parse_part_2)
puts boards["..AAAA.BBBB.CCCC.DDDD.."]
