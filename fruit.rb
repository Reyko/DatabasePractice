require 'sqlite3'

class Fruit
  attr_accessor :name
  attr_accessor :colour
  attr_accessor :prickly_or_not
  attr_accessor :requires_peeling
  attr_accessor :country_of_origin



  def self.make_from_user_questions
   
    f = Fruit.new

    # Prompt the user for input
    puts "What fruit would you like to add?"
    f.name = gets.strip.chomp

    puts "What colour is the fruit that you wish to add?"
    f.colour = gets.strip.chomp

    puts "Is your fruit prickly?"
    f.prickly_or_not = gets.strip.chomp.to_i

    puts "Does it require peeling?"
    f.requires_peeling = gets.strip.chomp.to_i

    puts "What is the country of origin?"
    f.country_of_origin = gets.strip.chomp


    db = SQLITE3::Database.new 'fruits.db'
  
    begin

      sql = "CREATE TABLE fruits(id integer primary key autoincrement,name text,
         colour text, prickly_or_not integer, requires_peeling integer, country_of_origin text)"

      db.execute(sql)

      sql = "INSERT INTO fruits (name text, 
        colour text, prickly_or_not integer, requires_peeling integer, country_of_origin text) 
        VALUES(?,?,?,?,?)"
      db.execute(sql,f.name,f.colour,f.prickly_or_not,f.requires_peeling,f.country_of_origin)



    rescue

       sql = "SELECT * FROM fruits"
       
       db.execute(sql) 


    end  

  end



end


class Crud

    puts "Please select the option you wish:"
    puts "1. CREATE"
    puts "2. READ"
    puts "3. UPDATE"
    puts "4. DELETE"

    choice = gets.strip.chomp.to_i


    case choice

      when 1
        Fruit.make_from_user_questions
      when 2
        puts "hello"
      when 3
        puts "hello"
      when 4
        puts "hello"
    end

end



