
class Generate

def initialize

begin_time = Time.now

uid = UserId.new
i = 0
people = []
shuffle_progress_bar = ProgressBar.create(:title => "Making People... ", :total => DATASETSIZE)
DATASETSIZE.times do
	first_name = FFaker::Name.first_name
	last_name = FFaker::Name.last_name
	userid = uid.generate_userid(first_name,last_name)
	people << {:id => i,"l:label".to_sym => "Person,Person", :firstName => first_name,:lastName => last_name,:userId=>userid,:title=>"#{FFaker::Job.title}",:city=>"#{FFaker::Address.city}",:country=> getCountry,
	  					   :phone=>FFaker::PhoneNumber.phone_number,:email=>userid+"@peoplemaker.com", :status=> getStatus, :photo=> getPhoto, :org=> "IT", :active => getActiveStatus}
	shuffle_progress_bar.increment
	i += 1
end
puts "done"


puts "Generating Reporting Chain..."
reporting_chain = ReportingChain.new
data = reporting_chain.generate_reporting_chain(people)
puts "done"

rel = []

puts "Converting Nodes to CSV...\n"
csv_string = CSV.generate do |csv|
	csv << ["id", "l:label","firstName","lastName","userId","title","city","country","phone","email","status","photo","org","active","managerId"]
  JSON.parse(data.to_json).each do |hash|
    csv << hash.values
    rel << {:id => hash[:id], :managerId => hash[:id]}
  end
end
puts "done"
puts "Writing Nodes to CSV...\n"
File.open('data/nodes.csv', 'w') do |f|
	f.puts csv_string
end
puts "done -- wrote data/nodes.csv"


puts "Converting Relationships to CSV...\n"
csv_string = CSV.generate do |csv|
	csv << ["start","end","type"]
  JSON.parse(data.to_json).each do |hash|
    csv << [hash.values[0],hash.values[14],"WORKS_FOR"]
  end
end
puts "done"
puts "Writing Relationships to CSV...\n"
File.open('data/rel.csv', 'w') do |f|
	f.puts csv_string
end
puts "done -- wrote data/rels.csv"


end_time = Time.now
puts "Time Elapsed For Generation: #{end_time - begin_time}."
end

end