module Yahoo
  require 'date'
  class Event
    def initialize(event_start, event_end, event_summary)
      @all_day_event = event_start.length == 8 and event_end.length == 8
      @event_start = DateTime.parse(event_start)
      @event_end = DateTime.parse(event_end)
      @event_summary = event_summary
      @handler = calc_handler
      #puts '>>>  handler', @handler
    end
    
    def calc_handler
      if @all_day_event
        return :all_day_handler
      else
        return :day_time_handler
      end
    end
    
    def all_day_handler(from_date, to_date, calendar)
      puts '>>> all_day_handler called with: ', from_date, to_date, calendar
      # TODO: limit by from_date, to_date
      (@event_start...@event_end).each do |date|
        puts '>>> all_day_handler with date: ', date
        calendar.add_box(date, nil, nil, @event_summary)
      end
    end
    
    def day_time_handler(from_date, to_date, calendar)
      puts '>>> day_time_handler called with: ', from_date, to_date, calendar
      # TODO: limit by from_date, to_date
      puts '>>> @event_start', @event_start, @event_start.class
      from_time = @event_start.strftime("%H:%M")
      to_time = @event_end.strftime("%H:%M")

      (@event_start...@event_end).each do |date|
        puts '>>> all_day_handler with date: ', date
        calendar.add_box(date, from_time, to_time, @event_summary)
      end
    end
    
    def call_handler(from_date, to_date, calendar)   
      meth = method(@handler)
      meth.call(from_date, to_date, calendar)
    end
  end #class
end #odule
      