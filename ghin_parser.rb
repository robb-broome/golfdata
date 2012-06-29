golfer_count = 0
match_count = 0
no_match = 0
not_active_count = 0

# a library needed for creating comma separated variable files.
require 'csv'

# open the destination file and prepare it to receive CSV data
CSV.open('ghin_golfer_data.csv', 'wb') do |csv|

  # open the data file you made by pasting in from the golf handicap site
  # Handle one line from the file at a time in the variable called 'golfer'
  golf_data_file = File.open('ghin_raw_data.txt')

  while true
    golfer = golf_data_file.gets
    line_number = 1

    break unless golfer
    
    # count all golfers
    golfer_count += 1

    # get rid of leading and trailing blanks
    golfer.strip!


    # the first line is the name and club.
    # we may try to parse out later
    name_club = golfer

    # get the next line, which is association and handicap
    assn_and_handicap = golf_data_file.gets

    handicap_match = /HDCP Index: (\d+\.\d)/.match assn_and_handicap
    handicap = handicap_match ? handicap_match.captures.first : nil

    association_match = /(.+)\s+(HDCP Index:)/.match assn_and_handicap
    association = association_match ? association_match.captures.first : nil

    # the next line is just the date
    effective_date_line = golf_data_file.gets
    effective_date_match = /Eff Date: (\d\d\/\d\d\/\d\d\d\d)/.match effective_date_line
    effective_date = effective_date_match ? effective_date_match.captures.first : nil


    if name_club
      # count the match
      match_count += 1
      # write to the screen
      puts "Matched name and club: #{name_club}, Association: #{association},  Handicap: #{handicap}, Effective Date: #{effective_date}"
      # write to the CSV File
      csv << [name_club, association, handicap, effective_date]

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
`open ghin_golfer_data.csv`

# write statuses to the screen, for fun!
puts "there were #{golfer_count} golfers"
puts "there were #{match_count} matches"
puts "there were #{not_active_count} inactive golfers"
puts "there were #{no_match} match failures"
