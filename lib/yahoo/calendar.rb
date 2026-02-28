module Yahoo
  require 'open-uri'
  require 'nokogiri'
  require 'date'
  require 'httparty'
  class Calendar
    def initialize
      # https://calendar.yahoo.com/unikoski/31f05293e5be4d0b947051e3c2956d12?od=131
      now = Date.today
      @start_date = nearest_sunday(now)
      @todays_sunday = @start_date
      @end_date = @start_date + 27
      @events = []
      @boxes = {}
    end
    
    def get_date_range
      [@start_date, @end_date, @todays_sunday]
    end
    
    def extract_data(scroll_to)
      if scroll_to
        @start_date = Date.strptime(scroll_to, '%Y%m%d')
        @end_date = @start_date + 27
      end
      #url =  'https://calendar.yahoo.com/unikoski/31f05293e5be4d0b947051e3c2956d12?od=131'
      #other_url = 'https://calendar.yahoo.com/ws/v3/users/unikoski/calendars/131/events/?dtstart=20240301&dtend=20240531&format=json&ymreqid=0000000d-0000-00e0-1c0f-d4000001bf00&appId=ycalendar&key=31f05293e5be4d0b947051e3c2956d12'
      from_date = @start_date.strftime("%Y%m%d")
      to_date = @end_date.strftime("%Y%m%d")

      other_url = "https://calendar.yahoo.com/ws/v3/users/unikoski/calendars/131/events/?dtstart=#{from_date}&dtend=#{to_date}&format=xml&ymreqid=0000000d-0000-00e0-1c0f-d4000001bf00&appId=ycalendar&key=31f05293e5be4d0b947051e3c2956d12"
      puts "Calendar url =  [#{other_url}]"
      doc = get_doc(other_url)
      if doc
        extract_xml(doc)
        handle_events
      end
      return 'finito'
    end
    
    def get_box_by_date(date)
      date_key = calc_date_key(date)
      @boxes[date_key]
    end
    
    def dump_by_date
      (@start_date..@end_date).each do |date|
        date_key = calc_date_key(date)
        box = @boxes[date_key]
        box.dump if box
      end
    end
    
    def get_doc(url)
      return @doc if @doc
      begin
        @doc = fetch_and_parse(url)
        if !@doc
          puts 'Failed on first attempt, trying again'
          @doc = fetch_and_parse(url)
        end
        return @doc
      rescue StandardError => e
        puts "An error in get_doc occurred: #{e.message}"
      end
    end
      
    def fetch_and_parse(url)
      begin
        response = HTTParty.get(url, headers: {
  'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
})

        if response.body.nil? || response.body.empty?
          puts "No content retrieved from the URL", url
          return nil
        end
        doc = Nokogiri::HTML(response.body)
        return doc
      rescue OpenURI::HTTPError => e
        puts "fetch_and_parse - HTTP Url: #{url} Error: #{e.message}"
        return nil
      rescue StandardError => e
        puts "fetch_and_parse - An error occurred - Url: #{url} Message: #{e.message}"
        return nil
      end
    end
      
    def extract_xml(doc)
      return if !doc
      doc.xpath('//event').each do |event|
        # Extract and print starttime, endtime, and summary
        starttime = event.at_xpath('./starttime').text
        endtime = event.at_xpath('./endtime').text
        summary = event.at_xpath('./summary').text

        @events << Yahoo::Event.new(starttime, endtime, summary)
      end
    end

    def nearest_sunday(date)
      # Find the day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
      day_of_week = date.wday

      return date if day_of_week == 0

      # Calculate the number of days to subtract to get to the nearest Sunday
      days_to_subtract = day_of_week
    
      # Subtract the days to get to the nearest Sunday
      nearest_sunday = date - days_to_subtract

      return nearest_sunday
    end

    def handle_events
      @events.each do |event|
        event.call_handler @start_date, @end_date, self
      end
    end
    
    def add_box(date, from_time, to_time, orig_summary)
      summary = decode_html_entities(orig_summary)
      date_key = calc_date_key(date)
      @boxes[date_key] = Box.new(date) if !@boxes.include?(date_key)
      box = @boxes[date_key]
      if from_time
        box.add_timed(summary, from_time, to_time)
      else
        box.add_allday(summary)
      end
    end
 
    def decode_html_entities(string)
      # Regular expression to match &#nn; pattern
      string.gsub(/&#(\d+);/) do |match|
        # Extract the decimal ASCII code from the match
        ascii_code = $1.to_i
        # Convert ASCII code to character and replace the match
        ascii_code.chr(Encoding::UTF_8)
      end
    end

    def calc_date_key(date)   
      date.strftime("%Y-%m-%d")
    end
  end #class
end #module