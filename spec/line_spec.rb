require 'line'
require 'pg'

DB = PG.connect(:dbname => 'train_system')

RSpec.configure do |config|
	config.after(:each) do
		DB.exec("DELETE FROM lines *;")
	end
end