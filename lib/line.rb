require 'pg'
require 'rspec'

DB = PG.connect(:dbname => 'train_system')