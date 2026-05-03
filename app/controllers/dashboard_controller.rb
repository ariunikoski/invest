class DashboardController < ApplicationController
  before_action :ensure_google_connected!

  def index
    # Render the index view
    @from_date, @to_date, @todays_sunday = calc_date_range(params[:scroll_to])
    boxes = {}
    @events = get_events
    return unless ensure_google_connected!  #get_events may have required refresh that failed
    puts '>>> post events commences'
    #debug_events(@events.items, true)
    @events.each do |item|
      # TODO - need to check totime > from time
      # TODO - dpnt see taks or appointments...
      # TODO - in space below weather - some international clocks?
      # TODO - look for other TODOs
      # TODO - clean up debuggers
      expanded_events = expand_events(item)
      expanded_events.each do |ee_item|
        date_key = ee_item.get_date_key
        boxes[date_key] = Google::Box.new(date_key) if !boxes.include?(date_key)
        boxes[date_key].add_event(ee_item)
        #event.debug_print
      end
    end
    render 'index', locals: { is_mobile: is_mobile?, boxes: boxes }
  end

  def expand_events(google_event)
    expanded = []
    if google_event.start.date_time
      # Not an all day event...
      first_day = google_event.start.date_time.to_date
      last_day = google_event.end.date_time.to_date
    else
      first_day = google_event.start.date
      last_day = google_event.end.date - 1
    end
    test_date = first_day
    while test_date <= last_day
    #puts ">>> looking at: #{google_event.summary.inspect} #{first_day} #{last_day}"
      ne = Google::ExtractedEvent.new(google_event)
      ne.set_start_date(test_date) if test_date > first_day
      expanded << ne
      test_date = test_date + 1
    end
    expanded
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
    todays_sunday = start_date
    if scroll_to
      start_date = Date.strptime(scroll_to, '%Y%m%d')
    end
    from_date = start_date.strftime("%Y%m%d")
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

  def create_event
    ce = Google::CreateEvent.new
    notice_mess = "Created event #{params[:title]} (#{DateTime.parse(params[:st]).strftime("%d/%m/%Y")})"
    notice_level = :info
    begin
      if params[:allday] == "true"
        ce.create_event(
          summary: params[:title],
          description: params[:desc].gsub("\n", "<br>"),
          all_day: true,
          start_time: params[:st]
        )
      else
        ce.create_event(
          summary: params[:title],
          description: params[:desc].gsub("\n", "<br>"),
          all_day: false,
          start_time: params[:st],
          end_time: params[:et]
        )
      end
    rescue => e
      puts "Failed to created event with", e
      notice_mess = "Failed to create event with #{e}"
      notice_level = :info
    end
    redirect_to action: :index, notice: notice_mess, notice_level: notice_level
  end
end
