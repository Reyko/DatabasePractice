require 'sqlite3'
require 'pry'


class Fruit
  attr_accessor :id
  attr_accessor :name
  attr_accessor :colour
  attr_accessor :prickly_or_not
  attr_accessor :requires_peeling
  attr_accessor :country_of_origin



  def self.connect_to_db
    db = SQLite3::Database.new 'fruits.db' 
    yield db
  end


  def self.to_s(fruit) 
    fruits = "#{fruit.id}||#{fruit.name}||#{fruit.colour}||#{fruit.prickly_or_not}||#{fruit.requires_peeling}||#{fruit.country_of_origin}"
    fruits
  end

  def self.make_from_user_questions
   
    f = Fruit.new

    # Prompt the user for input
    puts "What fruit would you like to add?"
    f.name = gets.strip.chomp

    puts "What colour is the fruit that you wish to add?"
    f.colour = gets.strip.chomp

    puts "Is your fruit prickly?"
    f.prickly_or_not = gets.strip.chomp

    puts "Does it require peeling?"
    f.requires_peeling = gets.strip.chomp

    puts "What is the country of origin?"
    f.country_of_origin = gets.strip.chomp

   

     connect_to_db do |db|
      begin
        sql = "CREATE TABLE fruits(id integer primary key autoincrement,name text,
           colour text, prickly_or_not integer, requires_peeling integer, country_of_origin text)"
        db.execute(sql)     
      rescue Exception => e 
        sql = "INSERT INTO fruits (name,colour,prickly_or_not,requires_peeling,country_of_origin) VALUES(?,?,?,?,?)"
        db.execute(sql,f.name,f.colour,f.prickly_or_not,f.requires_peeling,f.country_of_origin)

        Crud.selection
      ensure
        sql = "INSERT INTO fruits (name,colour, prickly_or_not, requires_peeling, country_of_origin) VALUES(?,?,?,?,?)"
        db.execute(sql,f.name,f.colour,f.prickly_or_not,f.requires_peeling,f.country_of_origin)
      end  
    end
  end

  def self.read_from_user_questions

    f = Fruit.new

    puts "Please select an option:"
    puts "1. I want all fruits to be displayed"
    puts "2. I want to a specific fruit"
    
    choice = gets.chomp.to_i

    case choice
    when 1
      connect_to_db do |db|
        sql = "SELECT * FROM fruits"
        result = db.execute(sql)
        # binding.pry
        result.each do |row|
          f.id = row[0]
          f.name = row[1]
          f.colour = row[2]
          f.prickly_or_not = row[3]
          f.requires_peeling = row[4]
          f.country_of_origin = row[5]
          yield f
        end
      end
    when 2 
      puts "Please type the name of the fruit that you wish"
      fruit = gets.strip.chomp
      
      connect_to_db do |db|
        sql = "SELECT * FROM fruits WHERE name = ?"
        result = db.execute(sql,fruit)

        result.each do |row|
            f.id = row[0]
            f.name = row[1]
            f.colour = row[2]
            f.prickly_or_not = row[3]
            f.requires_peeling = row[4]
            f.country_of_origin = row[5]
            yield f
        end
      end
    end
  end

  def self.update_from_user_questions
    f = Fruit.new

    puts "Please type the id of the fruit that you wish to update"
    id = gets.strip.chomp
    f.id = id

    puts "Please type the number of the attribute you wish to update"

    puts "1. Name"
    puts "2. Colour"
    puts "3. Prickly"
    puts "4. Peeling"
    puts "5. Country"

    attribute = gets.strip.chomp.to_i
    
    puts "Please type the value you wish"
    value = gets.strip.chomp
    
    case attribute
    when 1
      f.name = value
      sql = "UPDATE fruits SET name = '#{f.name}' WHERE id = #{id}"
    when 2
      f.colour = value
      sql = "UPDATE fruits SET Colour = '#{f.colour}' WHERE id = #{id}"
    when 3
      f.prickly_or_not = value.to_i
      sql = "UPDATE fruits SET prickly_or_not = #{f.prickly_or_not} WHERE id = #{id}"
    when 4
      f.requires_peeling = value.to_i
      sql = "UPDATE fruits SET requires_peeling = #{f.requires_peeling} WHERE id = #{id}"
    when 5
      f.country_of_origin = value
      sql = "UPDATE fruits SET country_of_origin = '#{f.country_of_origin}' WHERE id = #{id}"                
    end  

    connect_to_db do |db|
      db.execute(sql)   
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
    when 2
      puts "Please select the fruit you wish to delete by typing its id"
      selection = gets.chomp.to_i
      
      sql = "DELETE FROM fruits WHERE id = #{selection}"
    end
    connect_to_db do |db|
      db.execute(sql)
    end
  end 
end


class Crud
  def self.selection
    my_crud = Crud.new

    while(true)   
      puts "\n"
      puts "Please select the option you wish:"
      puts "1. CREATE"
      puts "2. READ"
      puts "3. UPDATE"
      puts "4. DELETE"
      puts "5. EXIT"
      puts "\n"
      choice = gets.strip.chomp.to_i

      case choice
      when 1
        Fruit.make_from_user_questions
      when 2
        Fruit.read_from_user_questions do |fruit|
          puts Fruit.to_s(fruit)
        end
      when 3
        Fruit.update_from_user_questions
      when 4
        Fruit.delete_from_user_questions
      when 5
        break
      end
    end  
  end
end

Crud.selection

