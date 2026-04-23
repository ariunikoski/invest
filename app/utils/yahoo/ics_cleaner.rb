require 'icalendar'
require 'securerandom'

module Yahoo
class IcsCleaner
  def initialize(input_filename)
    @input_filename = input_filename
    @output_filename = build_output_filename(input_filename)
  end

  def clean!
    input = File.read(@input_filename)
    input = sanitize_input(input)

    calendars = Icalendar::Calendar.parse(input)

    new_cal = Icalendar::Calendar.new

    calendars.each do |cal|
      cal.events.each do |event|
        # Ensure UID exists
        event.uid ||= SecureRandom.uuid

        new_cal.add_event(event)
      end
    end

    new_cal.publish
    File.write(@output_filename, new_cal.to_ical)
  end

  private

  def sanitize_input(input)
    input
      # Remove problematic X-ALT-DESC lines (including multiline continuations)
      .gsub(/^X-ALT-DESC;FMTTYPE=text\/html:.*(\r?\n[ \t].*)*/i, '')
      .gsub(/^X-ALT-DESC;VALUE=text\/html:.*(\r?\n[ \t].*)*/i, '')
      # Optional: normalize encoding
      .encode('UTF-8', invalid: :replace, undef: :replace)
  end

  def build_output_filename(filename)
    ext = File.extname(filename)
    base = File.basename(filename, ext)
    dir  = File.dirname(filename)

    File.join(dir, "#{base}_cleaned#{ext}")
  end
end
end