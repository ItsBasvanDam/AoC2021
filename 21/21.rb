$dice = 0
$dice_rolled = 0

def advance(player_pos, num)
  player_pos = player_pos + num
  player_pos = player_pos - 10 while player_pos > 10
  return player_pos
end

def roll
  $dice_rolled += 1
  $dice += 1
  $dice = 1 if $dice > 100
  return $dice
end

# part 1
p1, p2 = File.readlines("input").map { |l| l.chomp.chars.last.to_i }
players = [[p1, 0], [p2, 0]]
loser_score = 0
catch :done do # cheeky hack to break out of outer loop
  while true
    players.each_index do |i|
      # players[i][0] => pos
      # players[i][1] => score
      players[i][0] = advance(players[i][0], roll + roll + roll)
      players[i][1] += players[i][0]
      throw :done if players[i][1] >= 1000
      loser_score = players[i][1]
    end
  end
end
puts loser_score * $dice_rolled

# part 2
def turn_recurse(turn, pos_1, score_1, pos_2, score_2, path_count)
  if score_1 >= 21
    $wins[0] += path_count
  elsif score_2 >= 21
    $wins[1] += path_count
  else
    (3..9).each do |roll|
      if turn == 0
        new_pos = advance(pos_1, roll)
        turn_recurse(1, new_pos, score_1 + new_pos, pos_2, score_2, path_count * $roll_frequencies[roll])
      else
        new_pos = advance(pos_2, roll)
        turn_recurse(0, pos_1, score_1, new_pos, score_2 + new_pos, path_count * $roll_frequencies[roll])
      end
    end
  end
end

$roll_frequencies = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
$wins = [0, 0]
turn_recurse(0, p1, 0, p2, 0, 1)
puts $wins.max
