module Google
  class Box
    def initialize(date)
      @date = date
      @alldays = []
      @timed = {}
    end
    
    def add_event(event) 
      event.get_allday_event ? add_allday(event) : add_timed(event, event.get_start_time, event.get_end_time)
    end
    
    def add_allday(summary)
      @alldays << summary
    end
    
    def add_timed(event, from_time, to_time)
      key = "#{from_time.strftime('%H:%M')}-#{to_time.strftime('%H:%M')}"
      while @timed.include?(key) do
        key = key + '.'
      end
      @timed[key] = event
    end
 
    def get_alldays
      @alldays
    end
 
    def get_timed
      @timed
    end
 
    def get_4_rows
      more = false
      rows = []
      @alldays.each do |allday|
        if rows.length < 4
          rows << allday
        else
          more = true
        end
      end
        
      @timed.keys.sort.each do |key|
        if rows.length < 4
          #awk = key.split('-')
          #rows << "#{awk[0]} #{@timed[key]}"
          rows << @timed[key]
        else
          more = true
        end
      end
      [rows, more]
    end
        
        
    def dump
      @alldays.each { |allday| puts allday.summary }
      @timed.keys.sort.each do |key|
        puts "#{key} #{@timed[key].summary}"
      end
    end
  end #class
end #module