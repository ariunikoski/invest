require 'google/apis/calendar_v3'
require 'signet/oauth_2/client'
module Google
  class Events < WithFreshToken

    # >>> SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'
  
    def events_between(start_date, end_date)
      time_min = start_date.beginning_of_day.iso8601
      time_max = end_date.end_of_day.iso8601
      puts ">>> time_min: #{time_min}"
      puts ">>> time_max: #{time_max}"
      with_fresh_token do |service|
        Log.info(">>> inside with_fresh_token body")
        results = []
        ['primary', 'en.australian#holiday@group.v.calendar.google.com', 'en-gb.judaism#holiday@group.v.calendar.google.com'].each do |name|
          results.concat(get_list(service, name, time_min, time_max))
        end
        # >>> begin
          # >>> results.concat(service.list_events(
            # >>> 'primary',
            # >>> time_min: time_min,
            # >>> time_max: time_max,
            # >>> single_events: true,
            # >>> order_by: 'startTime'
          # >>> ).items)
        # >>> rescue => e
          # >>> puts 'Google Client Failure with: ', e. status_code, e.body
        # >>> end
        results
      end
    end
  
    private
  
    def get_list(service, name, time_min, time_max)
      begin
        items = service.list_events(
          name,
          time_min: time_min,
          time_max: time_max,
          single_events: true,
          order_by: 'startTime'
        ).items
        items.each do |it|
          it.define_singleton_method(:calendar_id) { name }
        end
        items
      rescue => e
        puts 'Google Client Failure with: ', name, e.status_code, e.body
      end
    end
  
  end
end