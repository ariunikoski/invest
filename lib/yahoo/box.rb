module Yahoo
  class Box
    def initialize(date)
      puts '>>> new box created', date
      @date = date
      @alldays = []
      @timed = {}
    end
    
    def add_allday(summary)
      puts '>>> adding allday', summary
      @alldays << summary
    end
    
    def add_timed(summary, from_time, to_time)
      puts '>>> adding timed', summary, from_time, to_time
      key = "#{from_time}-#{to_time}"
      while @timed.include?(key) do
        key = key + '.'
      end
      @timed[key] = summary
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
          awk = key.split('-')
          rows << "#{awk[0]} #{@timed[key]}"
        else
          more = true
        end
      end
      [rows, more]
    end
        
        
    def dump
      puts '>>> dumping alldays'   
      @alldays.each { |allday| puts allday }
      puts '>>> dumping timed'   
      @timed.keys.sort.each do |key|
        puts "#{key} #{@timed[key]}"
      end
    end
  end #class
end #module