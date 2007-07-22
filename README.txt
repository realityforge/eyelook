How to setup Eyelook
--------------------

1. Download source from subversion
2. Copy config/database.yml.example to config/database.yml and modify
   for your database. (Mysql and Postgres have been tested)
3. Install RMagic gem via

   >> gem install rmagick

4. Run 'rake migrate' to setup initial database.
5. Add in user by running './script/console' (or 'ruby script\console' 
   under windows) and then entering the following command replacing
   values as appropriate.

   >> User.create!(:name => 'myusername', :password => 'mypass')

6. Run ./script/server (or 'ruby script\server' under windows) and point
   your browser at http://127.0.0.1:3000/admin and login. The method for
   creating the albums should be largely self-explanatory.
7. Have fun playing!
