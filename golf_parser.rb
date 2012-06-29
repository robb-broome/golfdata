golfer_count = 0
match_count = 0
no_match = 0
not_active_count = 0

# a library needed for creating comma separated variable files.
require 'csv'

# open the destination file and prepare it to receive CSV data
CSV.open('golfer_data.csv', 'wb') do |csv|

  # open the data file you made by pasting in from the golf handicap site
  # Handle one line from the file at a time in the variable called 'golfer'
  File.open('golfscores.txt').each do |golfer|

    # count all golfers
    golfer_count += 1

    # eliminate golfers that are not active or N/H right away
    not_active_matcher = /(Not Active|N\/H)/
      if not_active_matcher.match(golfer)
        not_active_count += 1
        next
      end

    # get rid of leading and trailing blanks
    golfer.strip!

    # pull out the handicap, which should be the only digits in the data
    # right now, rejecting handicaps that do not have a digit after the decimal
    # This is using a regular expression (\d+\.\d) that says:
    # find one or more digits (d+) followed by a '.', followed by one digit
    handicap_match = /(\d+\.\d)/.match golfer
    handicap = handicap_match ? handicap_match.captures.first : nil

    # skip to the next golfer if there is no handicap listed
    next unless handicap


    # matchers for the name and city
    name_match = /(\w+,\s\w+\s*\w*)\s+(\d+\.\d)/.match golfer
    city_match = /(.+\d+\.\d)(.*)/.match golfer
    # get the name and the city, or a blank if the don't exist
    name = name_match ? name_match.captures.first.strip : nil
    city = city_match ? city_match.captures.last.strip : ""

    if name
      # count the match
      match_count += 1
      # write to the screen
      puts "Matched: #{name} Handicap: #{handicap} City: #{city}"
      # write to the CSV File
      csv << [name, handicap, city]

    else
      # count the no_match
      no_match += 1
      # say something to the screen
      puts "Failed to match: #{golfer}"
    end
  end
end

# this makes Mac OS X open the csv file. It will usually use Numbers to do that,
# so you should see Numbers magically open.
`open golfer_data.csv`

# write statuses to the screen, for fun!
puts "there were #{golfer_count} golfers"
puts "there were #{match_count} matches"
puts "there were #{not_active_count} inactive golfers"
puts "there were #{no_match} match failures"
