require 'anemone'
require 'mongo'

# Patterns
POST_WITHOUT_SLASH  = %r[\d{4}\/\d{2}\/[^\/]+$]   # http://isbullsh.it/2012/66/here-is-a-title  (301 redirects to slash)
POST_WITH_SLASH     = %r[\d{4}\/\d{2}\/[\w-]+\/$] # http://isbullsh.it/2012/66/here-is-a-title/
ANY_POST            = Regexp.union POST_WITHOUT_SLASH, POST_WITH_SLASH 
ANY_PAGE            = %r[page\/\d+]               # http://isbullsh.it/page/4 
ANY_PATTERN         = Regexp.union ANY_PAGE, ANY_POST
SITE = 'http://www.ghin.com/lookup.aspx'

# MongoDB
db = Mongo::Connection.new.db("golf")
golfers_collection = db["golfers"]
tournaments_collection = db["tournaments"]
golfer_performance_collection = db["golfer_performance"]

# id of the input for ghin lookup
lookup_id = "ctl00_bodyMP_tcLookupModes_tpSingle_tbGHIN"
# id of the name
golfer_name_id = "ctl00_bodyMP_lblName"
golfer_ghin_id = "ctl00_bodyMP_tdGHINNumber"
golfer_ghin_span_id = "ctl00_bodyMP_lblGHIN"
score_history_table_id = "ctl00_bodyMP_tcItems_tpMostRecent_slMostRecent_grdScores"


Anemone.crawl("SITE") do |anemone|

  anemone.focus_crawl do |page| 
    page.links.keep_if { |link| link.to_s.match(ANY_PATTERN) } # crawl only links that are pages or blog posts
  end

  anemone.on_pages_like(POST_WITH_SLASH) do |page|
    title = page.doc.at_xpath("//div[@role='main']/header/h1").text rescue nil
    tag = page.doc.at_xpath("//header/div[@class='post-data']/p/a").text rescue nil

    if title and tag
      post = {title: title, tag: tag}
      puts "Inserting #{post.inspect}"
      posts_collection.insert post
    end
  end
end
