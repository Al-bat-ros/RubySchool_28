require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
     @db = SQLite3::Database.new 'leprosorium.db'
     @db.results_as_hash = true
end

before do
     init_db
end

configure do
     init_db
    @db.execute 'CREATE TABLE IF NOT EXISTS Posts 
      (
         id  INTEGER PRIMARY KEY AUTOINCREMENT,
         created_data  DATE,
         content TEXT
      )'
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:cont]

  erb "You typed #{content}"
end

