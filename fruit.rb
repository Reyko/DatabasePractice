require 'sqlite3'

class Fruit
  attr_accessor :name
  attr_accessor :colour
  attr_accessor :prickly_or_not
  attr_accessor :requires_peeling
  attr_accessor :country_of_origin


  db = SQLITE3::Database.new 'fruits.db'
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

  def self.read_from_user_questions

    f = Fruit.new

    puts "What attribute would you like to read?"
    puts "1. I want to read all the attributes of the table"
    puts "2. I want to read specific attributes of the table"
    
    choice = gets.chomp

    case choice

      when 1

        sql = "SELECT * FROM fruits"
        db.execute(sql)

      when 2 

        puts "Please select the attributes you wish to read seperated by space"
        attributes = gets.strip.chomp
        attributes.split(" ").join(",")!

        sql = "SELECT ? FROM fruits"
        db.execute(sql,attributes)

      end
  end

  def self.update_from_user_questions

    f = Fruit.new

    puts "Please type the attributes and the values that you wish to update seperated by space"
    choice = gets.strip.chomp
    choice.split(" ")!

    choice.each do |attribute|

        sql = "UPDATE fruits SET ?"
        db.execute(sql,attribute)

    end      
  end

  def self.delete_from_user_questions
    f = Fruit.new

    puts "Please select an option"
    puts "1. I want to delete all the entries of the table"
    puts "2. I want to delete a specific entry of the table"

    choice = gets.strip.chomp.to_i


    case choice

      when 1
        sql = "DELETE FROM fruits"
        db.execute(sql)
      when 2
        puts "Please select the id you wish to delete"

        sql = "SELECT * FROM fruits"
        db.execute(sql)

        selection = gets.chomp.to_i

        sql = "DELETE FROM fruits where id = ?"
        db.execute(sql,selection)

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



