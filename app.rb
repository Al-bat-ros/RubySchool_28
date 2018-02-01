require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
     @db = SQLite3::Database.new 'leprosorium.db'
     @db.results_as_hash = true
end

# "before" вызывается каждый раз при перезагрузке любой страницы
before do

    # инециализация БД
     init_db
end

# "configure" вызывается каждый раз при конфигурации приложения:
# когда изменился код программы и перезагрузилась страница
configure do

    # инециализация БД
    init_db

    # создаем таблику если её нет
    @db.execute 'CREATE TABLE IF NOT EXISTS Posts 
      (
         id  INTEGER PRIMARY KEY AUTOINCREMENT,
         created_date  DATE,
         content TEXT
      )'
end

#обровотчик get-запроса '/'
get '/' do

  #выбираем список постов из БД
  @results = @db.execute 'select * from Posts order by id desc'

  erb :index
end

#обровотчик get-запроса '/new'
#(браузер получает страницу с сервера)
get '/new' do
  erb :new
end

#оброботчик post-запроса /new
#(браузер отправляет данные на сервер)
post '/new' do

  #получаем переменную из post-запроса
  content = params[:cont]

# прверка ввода текста в форму
    if content.length <= 0
      @error = 'Type post text'
      return erb :new
    end
  #сохранение в БД контнента
    @db.execute 'insert into Posts (content,created_date) values (?,datetime())',[content]

  #перенаправление на главную страницу
  redirect to '/'
  
end

#вывод информации о посте
get '/details/:post_id' do


   # получаем переменную из url'a
   post_id = params[:post_id]

   # получаем список постов
   # (у нас будет только один пост)
   results = @db.execute 'select * from Posts where id = ?',[post_id.to_i]

   # записываем этот один пост в переменную @row
   @row = results[0]
   
   # возвращаем представление details.erb
   erb :details

    #erb "добавили пост № : #{post_id}"
end

#оброботчик post-запроса /details/...
#(браузер отправляет данные на сервер, мы их принемаем)
post '/details/:post_id' do

   # получаем переменную из url'a
   post_id = params[:post_id]

   #получаем переменную из post-запроса
   content = params[:cont]

   erb "You typed comment #{content} for post #{post_id}"

end