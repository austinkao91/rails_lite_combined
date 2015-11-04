# rails_lite_combined

An MVC web server built from scratch using WEBrick, ruby, and SQLite3. Currently, all folders ending in #_object signify
the overarching classes used to create their respective counterparts. In order to use/ modify this, an sql file with
the desired tables should be added to the database folder. Ensure that all other .db and .sql files are removed.

To create models, all model class names must be singular of the table name, and inherit fromm SQLObject.
ActiveSupport's inflection is used to associate a model with a SQL table. The table_name can be overwritten in
case the pluralization method fails. 

To create controllers, they need to be inherited from ControllerBase. flash and flash.now are usable by the 
controller.

View folders must match the controller class name joined to underscore and controller i.e. CatsController -> cats_controller
The file names must match the action from the controller.

Routes are added and run in the start_server/server_index.rb. Using router.draw, routes can be given in the format
verb, regex matcher, controller class, and action.

The server can be run by navigating to start_server folder and running ruby server_index.rb in the command line console.

Challenges: 
Extracting parameters for the controller was pretty challenging, and required some creativity to figure out how to
create the nested params hash. Starting from a sample input of 

cat%5Bname%5D=name&cat%5Bowner_id%5D=id, 

I had to end up with 

{cat: {name: name, owner_id: id}}. 

I first converted my input using URI::decode_www_form and regex splitting to turn the hash format into

{["cat","name] => "name", ["cat", "owner_id"] => "id"}

This way, I could easily access all of the nested parameter paths in an array quickly, and also know what
value it should be assigned to at the end. From here, I modeled the problem as a linked list, and decided  to  
create the nested parameters from the highest level down. 

def parse_to_hash_improved(hashes)
    h = Hash.new
    hashes.keys.each do |keys|
      pointer = h
      keys[0..-2].each do |key|
        pointer[key] ||= {}
        pointer = pointer[key]
      end
      pointer[keys.last] = hashes[keys]
    end
    h
  end
  
Pointer starts off pointing to a new hash container, and as I iterate through an array like ["cat", "name"],
I create a hash with the name cat, and set the pointer to equal the new hash cat that was created.
