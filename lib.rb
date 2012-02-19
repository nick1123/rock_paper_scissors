require 'base64'

class Game
  R = :rock
  P = :paper
  S = :scissors

  WIN  = :win
  LOSE = :lose
  TIE  = :tie
  
  SAME = :same
  UP   = :up 
  DOWN = :down
  
  MAPPER = 
  {
    R => {SAME => R, UP => P, DOWN => S},
    P => {SAME => P, UP => S, DOWN => R},
    S => {SAME => S, UP => R, DOWN => P},
  }
  
  def self.new_game
    game = create_new_game
    return encode(game)
  end
  
  def self.play(params)
    guess = params['guess']
    encoded = params['encoded']
    decoded = decode(encoded)
    p decoded
    return {:encoded => encoded}
  end
  
  
  def self.create_new_game
    data = {}
    previous_play = {}
    previous_play[WIN]  = {SAME => 0, UP => 0, DOWN => 1}
    previous_play[LOSE] = {SAME => 0, UP => 1, DOWN => 0}
    previous_play[TIE]  = {SAME => 1, UP => 0, DOWN => 0}
    
    data[:previous_play] = previous_play
    data[:score] = {:computer => 0, :human => 0}
    return data
  end
  
  def self.encode(obj)
    return Base64.encode64(Marshal.dump(obj))
  end
  
  def self.decode(str)
    return Marshal.load(Base64.decode64(str))
  end
  
end