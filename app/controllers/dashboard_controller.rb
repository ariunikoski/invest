class DashboardController < ApplicationController
  before_action :ensure_google_connected!

  def index
    # Your logic here if needed
    
    # Render the index view
    @from_date, @to_date, @todays_sunday = calc_date_range(params[:scroll_to])
    #- prev_date = @from_date - 3.weeks
    #- next_date = @to_date - 1.weeks + 1.day
    #- @last_month = ''
    #- @this_month = Date.today.month
    #- @prev_month = @this_month - 1
    #- @prev_month = 12 if @prev_month == 0
    #- @next_month = @this_month + 1
    #- @next_month = 1 if @next_month == 13
    boxes = {}
    @events = get_events
    puts '>>> post events commences'
    debug_events(@events.items, true)
    @events.items.each do |item|
      # TODO - still have bug that i need to keep logging in all the time - perhaps needs to be stored in session data?
      #  - looks like i have to go to the database solution, however currently the bad migration puts it on user, and instead i need it on
      #  - holder. Then Current.get_oauth_credentials can return Holder.find_by(default: true) and then search for references to get_oauth_credentials
      #  - and adjst accordingly - most places wont need change, maybe to add save! after its updated. Also, get read of oauth_credentials as not needed
      # TODO - next/prev buttons
      # TODO - create calendar event 
      # TODO - todays calendar box empty
      # TODO - MULTIDATE doesnt appear - look at the xxx debugs first to learn how to distinguish....
      # TODO - consider adding aussie/israel holiday calendars
      # TODO - dpnt see taks or appointments...
      # TODO - can i get rid of the cause of the warning (mo longer need get...get?)
      # TODO - in space below weather - some international clocks?
      event = Google::ExtractedEvent.new(item)
      date_key = event.get_date_key
      boxes[date_key] = Google::Box.new(date_key) if !boxes.include?(date_key)
      boxes[date_key].add_event(event)
      #event.debug_print
    end
    render 'index', locals: { is_mobile: is_mobile?, boxes: boxes }
  end

  def get_events
    puts '>>> get_events commences'
    service = Google::Events.new
    service.events_between(@from_date, @to_date)
  end

  def debug_events(events, xxx_only)
    puts "Total events: #{events.size}"
    puts "-" * 60
  
    events.each_with_index do |e, i|
      next if xxx_only && !e.summary.starts_with?("xxx")
      puts "Event ##{i + 1}"
      puts "  id: #{e.id}"
      puts "  summary: #{e.summary.inspect}"
      puts "  status: #{e.status}"
      puts "  description: #{e.description}"
  
      # Start / End handling (important nuance)
      start_val = e.start.date_time || e.start.date
      end_val   = e.end.date_time   || e.end.date
  
      puts "  start: #{start_val} (#{e.start.date_time ? 'date_time' : 'date'})"
      puts "  end:   #{end_val} (#{e.end.date_time ? 'date_time' : 'date'})"
  
      puts "  created: #{e.created}"
      puts "  updated: #{e.updated}"
  
      puts "  organizer: #{e.organizer&.email}"
      puts "  attendees count: #{e.attendees&.size || 0}"
  
      if e.attendees&.any?
        e.attendees.each do |a|
          puts "    - #{a.email} (#{a.response_status})"
        end
      end
  
      puts "  recurring_event_id: #{e.recurring_event_id}" if e.recurring_event_id
      puts "  iCalUID: #{e.i_cal_uid}"
  
      puts "-" * 60
    end
  
    nil
  end

  def load_email_body
    mm = Yahoo::Email.new(Yahoo::Email.email_actions[:get_message_body], params[:id])
    render plain: mm.get_mail_body, status: :ok
  end

  def is_mobile?
    request.user_agent =~ /Mobile|webOS/
  end

  def calc_date_range(scroll_to)
    now = Date.today
    start_date = nearest_sunday(now)
    if scroll_to
      start_date = Date.strptime(scroll_to, '%Y%m%d')
    end
    from_date = start_date.strftime("%Y%m%d")
    todays_sunday = @start_date
    end_date = start_date + 27
    [start_date, end_date, todays_sunday]
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
end
