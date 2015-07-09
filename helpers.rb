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