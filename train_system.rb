require 'pg'
require './lib/line'
require './lib/train_station'
require './lib/stop'

DB = PG.connect(:dbname => 'train_system')

def log_in
	puts "Welcome to the Train System information guide"
	puts "Press 'p' if you're a passenger or 'o' if you're an operator"
	puts "Press 'x' to exit"
	log_in_choice = gets.chomp

	if log_in_choice == 'p'
		passenger_menu
	elsif log_in_choice == 'o'
		operator_menu
	elsif log_in_choice == 'x'
		puts "Goodbye!"
	else
		puts "Sorry, that wasn't a valid option."
		log_in
	end
end

def passenger_menu
	puts "Welcome, passenger."
	puts "Press 't' to see a list of train stations, 'l' to see a list of lines."
	puts "Press 'x' to exit."
	passenger_choice = gets.chomp

	if passenger_choice == 't'
		station_list
	elsif passenger_choice == 'l'
		line_list
	elsif passenger_choice == 'x'
		puts "Goodbye!"
	else
		puts "Sorry, that wasn't a valid option."
		passenger_menu
	end
end

def station_list
	stations = DB.exec("SELECT * FROM stations;")
	stations.each do |station|
		puts "#{station['id']}. #{station['name']}, #{station['location']}"
	end

	station_list_menu
end

def station_list_menu
	puts "Type the number for a station to see the lines that stop there."
	puts "Press 'm' to go back to the menu, or press 'x' to exit."
	station_list_choice = gets.chomp

	if station_list_choice == 'm'
		passenger_menu
	elsif station_list_choice == 'x'
		puts "Goodbye!"
	else
		lines = Stop.all_at_one_station(station_list_choice)
		lines.each do |line|
			puts line.name
		end
		passenger_menu
	end
end

def line_list
	lines = DB.exec("SELECT * FROM lines;")
	lines.each do |line|
		puts "#{line['id']}. #{line['name']}"
	end

	line_list_menu
end

def line_list_menu
	puts "Type the number for a line to see which stations it visits."
	puts "Press 'm' to go back to the menu, or press 'x' to exit."
	line_list_choice = gets.chomp

	if line_list_choice == 'm'
		passenger_menu
	elsif line_list_choice == 'x'
		puts "Goodbye!"
	else
		stations = Stop.all_on_one_line(line_list_choice)
		stations.each do |station|
			name_to_add = station.name
			location_to_add = station.location
			puts "#{name_to_add}, #{location_to_add}"
		end
		passenger_menu
	end
end

def operator_menu
	puts "Welcome, operator."
	puts "Press 't' to add a train station, 'l' to add a line or 's' to add a stop."
	puts "Press 'x' to exit."
	operator_choice = gets.chomp

	if operator_choice == 't'
		train_station_add
	elsif operator_choice == 'l'
		line_add
	elsif operator_choice == 's'
		stop_add
	elsif operator_choice == 'x'
		puts "Goodbye!"
	else
		puts "Sorry, that wasn't a valid option."
		operator_menu
	end
end

def train_station_add
	puts "Type the name of the station"
	station_name = gets.chomp
	puts "Type the location of the station"
	station_location = gets.chomp

	station = TrainStation.new(name: station_name, location: station_location)
	station.add

	puts "Station added!"
	operator_menu
end

def line_add
	puts "Type the name of the line"
	line_name = gets.chomp

	line = Line.new(name: line_name)
	line.add

	puts "Line added!"
	operator_menu
end

def stop_add
	puts "Here's a list of stations. Type the number of the station where your stop takes place."
	stations = DB.exec("SELECT * FROM stations;")
	stations.each do |station|
		puts "#{station['id']}. #{station['name']}, #{station['location']}"
	end

	station_choice = gets.chomp

	puts "Here's a list of lines. Type the number of the line making the stop."
	lines = DB.exec("SELECT * FROM lines;")
	lines.each do |line|
		puts "#{line['id']}. #{line['name']}"
	end

	line_choice = gets.chomp

	new_stop = Stop.new(station_id: station_choice, line_id: line_choice)
	new_stop.add
	puts "Stop added!"

	operator_menu
end

log_in