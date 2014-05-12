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
     
    fruits = "#{fruit.name}||#{fruit.colour}||#{fruit.prickly_or_not}||#{fruit.requires_peeling}||#{fruit.country_of_origin}"
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

            # binding.pry
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

        puts "Please the fruit that you wish"
        fruit = gets.strip.chomp
        # attributes.split(" ").join(",")
        # binding.pry

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

    puts "Please type the attributes and the values that you wish to update seperated by space"
    choice = gets.strip.chomp
    choice.split(" ")

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

  def self.selection

   my_crud = Crud.new


   while(true)   

      puts "Please select the option you wish:"
      puts "1. CREATE"
      puts "2. READ"
      puts "3. UPDATE"
      puts "4. DELETE"
      puts "5. EXIT"

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

