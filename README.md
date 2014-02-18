Vagrant and Oracle VM Setup Installer Thingy
===========================
(I'm open to a better name.)

### Dependencies:

* Mac OS X
* [Homebrew](http://brew.sh "http://brew.sh") 🍺
* the following homebrew packages:
    * virtualbox (through [homebrew cask](https://github.com/phinze/homebrew-cask "https://github.com/phinze/homebrew-cask"))
    * vagrant (through [homebrew cask](https://github.com/phinze/homebrew-cask "https://github.com/phinze/homebrew-cask"))
    * ansible
* [Oracle XE](http://www.oracle.com/technetwork/products/express-edition/downloads "http://www.oracle.com/technetwork/products/express-edition/downloads")

### Instructions:

1. Download Oracle XE from [here](http://www.oracle.com/technetwork/products/express-edition/downloads "http://www.oracle.com/technetwork/products/express-edition/downloads"), and put the file (should be a something like: oracle-xe-11.2.0-1.0.x86_64.rpm.zip) into the /provisioning/ folder
2. Copy /provisioning/config.yml.example to /provisioning/config.yml and make any changes you'd like.
    * **oracle_password**: the password for your databases
    * **vm_name**: name of the vm in VirtualBox
    * **create_test_databases**: if true, will create a test database for each database created (cc_pers will create cc_pers_test, for example)
3. [_optionally_] To create a development database, put a dump file with the name of the database into /provisioning/roles/oracle/extra/dump/. Ex: /provisioning/roles/oracle/extra/dump/cc_admin.dmp
4. [_optionally_] Add any custom SQL commands you want to run after the database is setup to /provisioning/roles/oracle/sql/[name of the database you want to use]/[file.sql]. Ex: /provisioning/roles/oracle/sql/cc_pers/change_everyones_password.sql
    * You can also use the "system" folder for more complex commands. Ex: /provisioning/roles/oracle/sql/system/complicated_stuff.sql
5. Type **vagrant up** and go enjoy a snack. It might be about 15 minutes. 😐
6. Enjoy! 🎉

### Notes:

* You can re-import your databases from fresh dmp files by deleting the log files in /provisioning/roles/oracle/extra/dump/

