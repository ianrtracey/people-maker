class Import

def initialize
puts "Importing to Neo4j..."
success = system("cd importer && sh import-mvn.sh")
if success
	puts "Import Successful"
end
puts "done"

puts "Enjoy your Neo4j dataset."
end

end
