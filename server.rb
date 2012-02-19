require 'sinatra'
require (File.dirname(__FILE__) + '/lib.rb')

get '/' do
  @encoded = Game.new_game
  erb :index
end

get '/play' do
  puts "**********************"
  p params
  game_hash = Game.play(params)
  @encoded = game_hash[:encoded]
  erb :index
end