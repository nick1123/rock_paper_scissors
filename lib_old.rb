require 'base64'

class Game
  R = :rock
  P = :paper
  S = :scissors

  WIN  = :win
  LOSE = :lose
  TIE  = :tie

  SAME  = :same
  LEFT  = :left
  RIGHT = :right

  GAME_DIRECTION = {
    R => {SAME => R, LEFT => S, RIGHT => P},
    P => {SAME => P, LEFT => R, RIGHT => S},
    S => {SAME => S, LEFT => P, RIGHT => R},
  }

  GAME_DIRECTION_INV = {
    R => {R => SAME, S => LEFT, P => RIGHT},
    P => {P => SAME, R => LEFT, S => RIGHT},
    S => {S => SAME, P => LEFT, R => RIGHT},
  }

  SCORE_MATRIX = {
    R => {R => TIE, P => LOSE, S => WIN},
    P => {P => TIE, S => LOSE, R => WIN},
    S => {S => TIE, R => LOSE, P => WIN},
  }


  def self.new_game
    game_hash = create_new_game
    return {:encoded => encode(game_hash), :score => game_hash[:score],
      :history => game_hash[:history]}
  end

  def self.play(params)
    user_move = params['guess'].to_sym
    encoded = params['encoded']
    decoded = decode(encoded)
    puts "***********************"
    p decoded
    score = decoded[:score]
    history = decoded[:history]
    previous_play = decoded[:previous][:play]
    previous_outcome = decoded[:previous][:outcome]
    puts "previous_play #{previous_play.inspect}"
    puts "previous_outcome #{previous_outcome.inspect}"
    comp_move = predict_move(previous_play, previous_outcome, history)
    puts "user_move #{user_move.inspect}"
    puts "comp_move #{comp_move.inspect}"
    score_game(user_move, previous_play, comp_move, history, score)
    puts ""
    return {:encoded => encode(decoded), :score => score, :history => history}
  end

  def self.score_game(user_move, previous_play, comp_move, history, score)
    result = SCORE_MATRIX[user_move][comp_move]
    puts "result #{result.inspect}"

    p score

    # Update score
    score[:human]    += 1 if result == WIN
    score[:computer] += 1 if result == LOSE
    score[:tie]      += 1 if result == TIE

    # Update history
    dir = SAME
    dir = LEFT
    play_pattern = GAME_DIRECTION_INV[previous_play][user_move]
    history[result][play_pattern] += 1

    p score

  end

  def self.predict_move(previous_play, previous_outcome, history)
    hsh = history[previous_outcome]
    dir = LEFT
    dir = RIGHT if (hsh[RIGHT] > hsh[LEFT] && hsh[RIGHT] > hsh[SAME])
    dir = SAME  if (hsh[SAME]  > hsh[LEFT] && hsh[SAME]  > hsh[RIGHT])
    return GAME_DIRECTION[previous_play][dir]
  end


  def self.create_new_game
    puts "--------------------- CREATING NEW GAME"
    history = {}
    history[WIN]  = {SAME => 0, LEFT => 0, RIGHT => 0}
    history[LOSE] = {SAME => 0, LEFT => 0, RIGHT => 0}
    history[TIE]  = {SAME => 0, LEFT => 0, RIGHT => 0}

    game_hash            = {}
    game_hash[:history]  = history
    game_hash[:previous] = {:outcome => WIN, :play => R}
    game_hash[:score]    = {:computer => 0, :human => 0, :tie => 0}

    puts "game_hash[:history] 1 #{game_hash[:history].inspect}"
    return game_hash
  end

  def self.encode(obj)
    return Base64.encode64(Marshal.dump(obj))
  end

  def self.decode(str)
    return Marshal.load(Base64.decode64(str))
  end

end