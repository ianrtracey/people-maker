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