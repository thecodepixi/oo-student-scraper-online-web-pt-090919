require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = [] 
    html = open(index_url)
    students_page = Nokogiri::HTML(html)
    students_page.css("div.student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css('a')[0]['href']
      }
    end 
    students 
  end

  def self.scrape_profile_page(profile_url)
    profile_contents = { } 
    html = open(profile_url)
    profile_page = Nokogiri::HTML(html)
    
    profile_page.css("div.social-icon-container").each do |content|
      content.css("a").each do |link|
        if link.first.last.include?("twitter")
          profile_contents[:twitter] = link.first.last 
        elsif link.first.last.include?("linkedin")
          profile_contents[:linkedin] = link.first.last 
        elsif link.first.last.include?("github")
          profile_contents[:github] = link.first.last
        else
          profile_contents[:blog] = link.first.last
        end 
      end 
    end 
    profile_contents[:profile_quote] = profile_page.css("div.profile-quote").text
    profile_contents[:bio] = profile_page.css("div.description-holder p").text
    profile_contents 
  end

end

