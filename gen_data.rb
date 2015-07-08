require 'rubygems'
require 'json'
require 'FFaker'
require 'set'
require 'benchmark'
require 'csv'
require 'ruby-progressbar'


# Set the number of people to what you want for your database
DATASETSIZE = 100_000


class UserId
  def initialize
	@unique_user_ids = Set.new
  end
  def generate_userid(first,last)
	if first.nil?
		first = "none"
	end
	if last.nil?
		last = "none"
	end
	userid = first[0..1]+last[0..4]
	while @unique_user_ids.include?(userid)
		userid = userid + Random.rand(0..100).to_s
	end
	@unique_user_ids.add(userid)
	return userid.downcase.gsub(/\s+/, "")
  end
end
# Takes the first person and makes that person the CEO
# looks at the first subset of 5,000 people, making 10% managers randomly
# links the remainding people to the managers by passing over each manager and randomly
# selecting between 100..500 at each pass
# shoves the managers into a hash starting with a 'level-1' relationship, linking the first
# managers to the CEO
class ReportingChain
	def initialize
		@current_managers = []
		@ceo = nil
		@manager_percentage = 0.90
		@reporting_chain = []
	end

	def generate_reporting_chain(people)
		@ceo = people.slice!(0)
		@reporting_chain << @ceo.merge!(managerId: @ceo[:id]) # CEO works for himself 
		# handles the first level manually in order to link to CEO
		level = people.slice!(0..DATASETSIZE/2000.floor)
		managers = level.slice!(0..((@manager_percentage*level.size).floor))
		managers.each do |manager|
		  manager.merge!(managerId: @ceo[:id].userId)
		end
		@current_managers = managers
		@reporting_chain += @current_managers
		level.each do |l|
		 l.merge!(managerId: @current_managers[Random.rand(0..@current_managers.size-1)][:id])
		 @reporting_chain << l
		end
		@manager_percentage -= 0.04
		i = 1
		while !people.empty?
			i += 1
			if people.size < DATASETSIZE/20.floor
			level = people.slice!(0..people.size)
			else
			level = people.slice!(0..DATASETSIZE/20.floor)
			end
			managers = level.slice!(0..((@manager_percentage*level.size).floor))
				managers.each do |manager|
		  		manager.merge!(managerId: @current_managers[Random.rand(0..@current_managers.size-1)][:id])
				end
			@current_managers = managers
			@reporting_chain += @current_managers
			level.each do |l|
		 	l.merge!(managerId: @current_managers[Random.rand(0..@current_managers.size-1)][:id])
			 @reporting_chain << l
			end
			@manager_percentage -= 0.04
		end
		return @reporting_chain
	end
end

def getCountry
	prob = rand(0..100)
	if 0 <= prob && prob < 55
		return "United States"
	elsif 55 <= prob && prob < 90
		return "India"
	elsif 90 <= prob && prob < 96
		return "China"
	elsif 96 <= prob && prob <= 100
		return "United Kingdom"
	end
end

def getActiveStatus
	prob = rand(0..100)
	if 0 <= prob && prob < 85
		return true
	else
		return false
	end
end

def getPhoto
	prob = rand(0..100)
	if prob <= 15
		return "profile0.jpg"
	else
		return "profile#{rand(1..11)}.jpg"
	end
end

def getStatus
  status = ["Employee", "Contractor"]
  return status[rand(0..1)]
end



begin_time = Time.now
puts "Parsing JSON File..."
file = File.read('export_names.json')
data_hash = JSON.parse(file)
puts "done"

first_names = []
last_names = []

array_progress_bar = ProgressBar.create(:title => "Building Arrays... ", :starting_at => 0, :total => data_hash['items'].size)
data_hash['items'].each do |name|
	first_names << name['first_name']
	last_names << name['last_name']
	array_progress_bar.increment
end
puts "done"



shuffle_progress_bar = ProgressBar.create(:title => "Shuffling Data... ", :total => DATASETSIZE)
shuffled_data_hash = []

first_names_size = first_names.size.to_i
last_names_size = last_names.size.to_i
uid = UserId.new
i = 0
DATASETSIZE.times do
	first_rand = Random.rand(0..first_names_size)
	last_rand = Random.rand(0..last_names_size)
	userid = uid.generate_userid(first_names[first_rand],last_names[last_rand])
	shuffled_data_hash << {:id => i,"l:label".to_sym => "Person,Person", :firstName => first_names[first_rand],:lastName => last_names[last_rand],:userId=>userid,:title=>"#{FFaker::Job.title}",:city=>"#{FFaker::Address.city}",:country=> getCountry,
	  					   :phone=>FFaker::PhoneNumber.phone_number,:email=>userid+"@directoryx.com", :status=> getStatus, :photo=> getPhoto, :org=> "IT", :active => getActiveStatus}
	first_names.delete_at(first_rand)
	last_names.delete_at(last_rand)
	first_names_size -= 1
	last_names_size -= 1
	shuffle_progress_bar.increment
	i += 1
end
# # Adds Tucson Developers
shuffled_data_hash << {:id => i,"l:label".to_sym => "Person,Person", :first_name => "Ian",:last_name => "Tracey",:userid=>"iatracey",:title=>"IT Engineer Intern",:city=>"Tucson",:country=> "United States",
	  					   :phone=>FFaker::PhoneNumber.phone_number,:email=>"iatracey@directoryx.com", :status=> "Employee", :photo=> "ian_profile.jpg", :org=> "CITS", :active => true}

shuffled_data_hash << {:id => i +=1,"l:label".to_sym => "Person,Person", :first_name => "Stephen",:last_name => "Varjabedian",:userid=>"svarjabe",:title=>"IT Engineer Intern",:city=>"Tucson",:country=> "United States",
 	  					   :phone=>FFaker::PhoneNumber.phone_number,:email=>"svarjabe@directoryx.com", :status=> "Employee", :photo=> "stephen_profile.jpg", :org=> "CITS", :active => true}

shuffled_data_hash << {:id => i +=1,"l:label".to_sym => "Person,Person", :first_name => "Sachin",:last_name => "Jain",:userid=>"sachija3",:title=>"IT Engineer Intern",:city=>"San Jose",:country=> "United States",
 	  					   :phone=>FFaker::PhoneNumber.phone_number,:email=>"sachija3@directoryx.com", :status=> "Employee", :photo=> "stephen_profile.jpg", :org=> "CITS", :active => true}
puts "done"

puts "Generating Reporting Chain..."
reporting_chain = ReportingChain.new
data = reporting_chain.generate_reporting_chain(shuffled_data_hash)
puts "done"

rel = []

puts "converting file to csv..."
csv_string = CSV.generate do |csv|
	csv << ["id", "l:label","firstName","lastName","userId","title","city","country","phone","email","status","photo","org","active","managerId"]
  JSON.parse(data.to_json).each do |hash|
    csv << hash.values
    rel << {:id => hash[:id], :managerId => hash[:id]}
  end
end

puts "done"
puts "Writing File to CSV..."
File.open('../data/directoryx_sample2.csv', 'w') do |f|
	f.puts csv_string
end
puts "done -- wrote directoryx_sample.csv"

puts "Writing rel.csv ..."
csv_string = CSV.generate do |csv|
	csv << ["start","end","type"]
  JSON.parse(data.to_json).each do |hash|
    csv << [hash.values[0],hash.values[14],"WORKS_FOR"]
  end
end
File.open('../data/directoryx_rel2.csv', 'w') do |f|
	f.puts csv_string
end
puts "done"


end_time = Time.now
puts "Time taken is #{end_time - begin_time}."

