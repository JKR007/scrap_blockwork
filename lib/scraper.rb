# class Scraper
class Scraper
	attr_accessor :url

	def initialize(url = "")
		check_for_url(url)
		@url = url
	end

	def scrap_handler
		parsed_page = get_parsed_page(@url)
		job_list = parsed_page.css('.listingCard')
		jobs = Array.new
		page_counter = 1
		jobs_per_page = job_list.length
		total_job_pages = parsed_page.css('.job-count').text.split(' ')[1].gsub(',','').to_i
		last_page = (total_job_pages.to_f/jobs_per_page.to_f).round

		while page_counter <= last_page
			pagination_url = @url + "listings?page=#{page_counter}"
			puts pagination_url
			puts "Page Num: #{page_counter}"
			pagination_parsed_page = get_parsed_page(pagination_url)
			pagination_job_list = pagination_parsed_page.css('.listingCard')
			pagination_job_list.each do |list|
				job = {
						title:    list.css('span.job-title').text,
						company:  list.css('span.company').text,
						location: list.css('span.location').text,
						url:      @url.chop + "" + list.css('a')[0].attributes['href'].value
				}
				jobs << job
			end
			page_counter += 1
		end
		byebug
	end

	private

	def get_parsed_page(url)
		unparsed_page = HTTParty.get(url)
		parsed_page = Nokogiri::HTML(unparsed_page)
	end

	def check_for_url(url)
		if url.empty? || !url.eql?("https://blockwork.cc/")
			puts "Url must be: 'https://blockwork.cc/'"
			exit!
		end
	end

end