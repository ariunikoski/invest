module Google
  class CreateEvent < WithFreshToken
    def create_event(summary:, description:, start_time:, end_time: nil, all_day: false, calendar_id: 'primary')
    
      with_fresh_token do |service|
    
        event = Google::Apis::CalendarV3::Event.new(
          summary: summary,
          description: description
        )
    
        if all_day
          # start_time is expected to be a Date
          event.start = Google::Apis::CalendarV3::EventDateTime.new(
            date: start_time.to_date.to_s
          )
    
          event.end = Google::Apis::CalendarV3::EventDateTime.new(
            date: (start_time.to_date + 1).to_s   # Google requires end = next day
          )
        else
          raise ArgumentError, "end_time required for timed events" unless end_time
    
          event.start = Google::Apis::CalendarV3::EventDateTime.new(
            date_time: start_time.in_time_zone.iso8601
          )
    
          event.end = Google::Apis::CalendarV3::EventDateTime.new(
            date_time: end_time.in_time_zone.iso8601
          )
        end
    
        created_event = service.insert_event(calendar_id, event)
    
        created_event
      end
    end
  end
end