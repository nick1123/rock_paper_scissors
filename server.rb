require 'sinatra'
require (File.dirname(__FILE__) + '/lib.rb')

get '/' do
  game_hash = Game.new_game
  @encoded = game_hash[:encoded]
  @score   = game_hash[:score]
  @history = game_hash[:history]
  erb :index
end

get '/play' do
  puts "**********************"
  p params
  game_hash = Game.play(params)
  @encoded = game_hash[:encoded]
  @score   = game_hash[:score]
  @history = game_hash[:history]
  erb :index
end