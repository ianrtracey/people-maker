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
		  manager.merge!(managerId: @ceo[:id])
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