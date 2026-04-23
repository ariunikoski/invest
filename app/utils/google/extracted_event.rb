module Google
  class ExtractedEvent
    def initialize(event)
      @event_id = event.id
      @summary = event.summary || ""
      puts ">>> Added summary of #{@summary}"
      @status = event.status
      @description = event.description
      @start_val = event.start.date_time || event.start.date
      @end_val   = event.end.date_time   || event.end.date
      @all_day_event = event.start.date_time.blank?
    end

    def get_summary
      @summary
    end

    def get_allday_event
      @all_day_event
    end

    def get_start_time
      @start_val
    end

    def get_end_time
      @end_val
    end

    def get_date_key
      @start_val.to_date
    end

    def set_start_date(new_start_date)
      if @all_day_event
        @start_val = new_start_date
      else
        puts ">>> before date change #{@start_val} new is #{new_start_date} #{new_start_date.day}"
        @start_val = @start_val.change(year: new_start_date.year, month: new_start_date.month, day: new_start_date.day)
        puts ">>> AFTER date change #{@start_val}"
      end
    end

    def debug_print
      puts '-' * 60
      puts "event_id #{@event_id}"
      puts "summary #{@summary}"
      #puts "description #{@description}"
      puts "start_val #{@start_val}"
      puts "end_val #{@end_val}"
      puts "all_day_event #{@all_day_event}"
      puts "date key: #{get_date_key}"
    end
  end
end