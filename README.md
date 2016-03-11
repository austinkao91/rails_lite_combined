# rails\_lite\_combined

An MVC web server built from scratch using WEBrick, ruby, and SQLite3. A simple cat application can be run by cloning this repository, navigating to the start_server folder and running

    ruby server_index.rb

in the command console. The application can be quickly viewed by entering localhost:3000 into your browser.

**Challenges:**

One of the biggest challenges in writing rails is writing the associations between models (has\_many and belongs\_to). This was especially intriguing to write as it show cases one of Ruby's most powerful features: metaprogramming.



      define_method("#{name}") do

        data = DBConnection.execute(<<-SQL, self.send(opts.primary_key) )
          SELECT
            #{opts.class_name.constantize.table_name}.*
          FROM
            #{opts.class_name.constantize.table_name}
          WHERE
          #{opts.class_name.constantize.table_name}.#{opts.foreign_key} = ?
        SQL

        opts.model_class.parse_all(data)
      end

Above, we have used ruby's define\_method and heredocs to generate Rail's has\_many association.

As it is fairly difficult to understand all of the name abstractions, above, consider the example of a human who has\_many cats.

The method would look like such

    def cats
       data = DBConnection.execute(<<-SQL, self.send(id) )
         SELECT
           Cats.*
         FROM
           Cats
         WHERE
           Cats.human_id = id
         SQL
       Cats.parse_all(data)
    end
