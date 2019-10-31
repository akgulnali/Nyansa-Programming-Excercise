require 'time'

def get_parsed_values(file_name)
	begin
		hit_count_hash = {}
		# Read a file without loading into memory.
		File.foreach("./Files/#{file_name}.txt") do |line| 
			parsed_line = line.split("|")
			epoc_time = parsed_line[0].to_i
			url = parsed_line[1].strip
			# Convert date into 'mm/dd/yyyy GMT' format.
			gmt_time = Time.at(epoc_time).utc.strftime("%m/%d/%Y GMT")
			# Put values into nested hash.
			if hit_count_hash[gmt_time]
				if hit_count_hash[gmt_time][url]
					hit_count_hash[gmt_time][url] += 1
				else
					hit_count_hash[gmt_time][url] = 1
				end
			else
				hit_count_hash[gmt_time] = { url => 1}
			end
		end
  	return hit_count_hash
	rescue Exception => e
		puts "Exception occurred: #{e}"
	end
end

def sort_hit_count(hit_count_hash)
	begin
		# Sort nested hash by hit count values
		sorted_hit_count_hash = {}
		hit_count_hash.each do |key,val|
			sorted_hit_count_hash[key] = val.sort_by { |k,v| v }.reverse.to_h
		end
		return sorted_hit_count_hash
	rescue Exception => e
		puts "Exception occurred: #{e}"
	end
end

def print_hit_count(sorted_hit_count_hash)
	begin
		# Print out sorted hash values in newline.
		sorted_hit_count_hash.sort.map do |key,val|
			puts key
			val.map {|k,v| puts "#{k} #{v}"}
		end
	rescue Exception => e
		puts "Exception occurred: #{e}"
	end
end

puts "====================== Welcome To Nyansa Hit Count Exercise ======================"
puts "Press 'Enter' to continue, Type 'quit to exit at any time."
choice = STDIN.gets.chomp # It helps to get inputs from user.

loop do
  case choice
  when ""
  	print "Please enter a file name: "
  	file_name = STDIN.gets.chomp
  	begin
  		hit_count_hash = get_parsed_values(file_name)
  		raise "File couldn't parsed!" if hit_count_hash.nil?
  		# Print out values sorted by key(date).
  		print_hit_count(sort_hit_count(hit_count_hash))
  		puts "Press 'Enter' to type another file or type 'quit' to exit."
  		choice = STDIN.gets.chomp
  	rescue Exception => e
  		puts "Exception occurred: #{e}"
  	end
  	
  when "quit"
    puts "Thank you for using Nyansa Hit Count Exercise."
    exit 0
  else
    puts "Invalid command! Press 'Enter' to continue, Type 'quit to exit at any time."
    choice = STDIN.gets.chomp
  end
end
