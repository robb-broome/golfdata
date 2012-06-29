golfer_count = 0
match_count = 0
no_match = 0
not_active_count = 0

require 'csv'

CSV.open('golfer_data.csv', 'wb') do |csv|
File.open('golfscores.txt').each do |golfer|
  golfer_count += 1

  not_active_matcher = /(Not Active|N\/H)/
  if not_active_matcher.match(golfer)
    not_active_count += 1
    next
  end

  #golfer.gsub!(".","")
  golfer.strip!


  handicap = /(\d+\.\d)/.match golfer

  next unless handicap

  #golfer.gsub!(handicap.captures.first, '')

  name_matcher = /(\w+,\s\w+\s*\w*)\s+(\d*.\d*)\s+(\w+\s*\w*\s*\w*,*\s*\w*)/
  name_matcher = /(\w+,\s\w+\s*\w*)\s+(\d+\.\d)/
  city_match = /(.+\d+\.\d)(.*)/.match golfer
  city = city_match ? city_match.captures.last : ""

  if match = name_matcher.match(golfer)
    match_count += 1
    puts "Matched: #{match.captures.first.strip} Handicap: #{handicap.captures.first} City: #{city.strip}"
    csv << [match.captures.first.strip, handicap.captures.first, city.strip]
  else
    no_match += 1
    puts "Failed to match: #{golfer}"
  end
end
end

`open golfer_data.csv`

puts "there were #{golfer_count} golfers"
puts "there were #{match_count} matches"
puts "there were #{not_active_count} inactive golfers"
puts "there were #{no_match} match failures"
