class WeeklyReportService
  # To run: rails runner 'puts WeeklyReportService.run' | mail  -a "Content-Type: text/html; charset=UTF-8"  -s "Test Share Report 1" unikoski@yahoo.com
  # IN order not to clog my email I am also doing: rails runner 'puts WeeklyReportService.run' >x.html 
  # in production it should be: RAILS_ENV=production bundle exec rails runner 'puts WeeklyReportService.run' | mail  -a "Content-Type: text/html; charset=UTF-8"  -s "Weekly Share Report 1" unikoski@yahoo.com
  #
  # TODO Test that server version of load currencies still works
  # TODO on server, ensure that mail is implemented the same 
  # TODO if there is a filter by alert type also handle new types of alerts
  
  INFO_STYLE = "color :#2e7d32;"
  WARN_STYLE = "color :#ef6c00; font-weight:bold;"
  ERROR_STYLE = "color :#c62828; font-weight:bold;"

  SECTION_HEADER_STYLE = "font-size: 1.2em; font-weight: bold; border: 1px solid #999; padding: 4px 8px; border-radius: 6px; display: inline-block;"
  
  TABLE_HEADER_STYLE = "font-weight: bold; background-color: #fff9c4; text-align: left;"
  TABLE_ROW_STYLE="text-align: left;"

  def self.run
    runner = WeeklyReportService.new
    # TODO: Need to run for all holders...
    runner.create_report
    runner.flush
  end

  def clear_logs
    Log.where(displayed: 0).update_all(displayed: 1)
  end

  def initialize
    # Example content – replace with your real logic
    @lines = []
    clear_logs
  end

  def add_raw(meat)
    @lines << meat
  end

  def add_line(newline)
    @lines << newline << "<br>"
    @log_styles = {}
    @log_styles['info'] = INFO_STYLE
    @log_styles['warn'] = WARN_STYLE
    @log_styles['error'] = ERROR_STYLE
  end

  def add_paragraph(style, newline)
    @lines << "<p style='#{style}'>#{newline}</p>"
  end

  def add_logs(show_info = true)
    logs = Log.where.not(displayed: 1).order(:id)
    if logs.length > 0
      logs.each do |log|
        if log.level != 'info' || show_info
          add_paragraph @log_styles[log.level], log.message
        end
      end
    end
    clear_logs
  end

  def create_section_header heading_text
    add_paragraph SECTION_HEADER_STYLE, heading_text
  end

  def get_exchange_rates
    create_section_header "Loading Exchange Rates"
    loader = CurrencyConverter::LoadAllCurrencies.new
    loader.load true
    add_logs 
  end

  def get_prices
    create_section_header "Loading Current Prices"
    loader = Yahoo::Quotes.new true
    loader.load
    add_logs
  end

  def get_dividends
    create_section_header "Loading Dividends"
    shares = Share.order(:name)
    shares.each do |share|
      loader = Yahoo::HistoricalData.new(share, true)
      loader.load
      created, duplicated, errors = loader.get_stats
      message = "#{share.symbol} - #{created} created, #{duplicated} duplicated, #{errors} errors"
      level = 'warn'
      level = 'info' if created > 0
      level = 'error' if errors > 0
      add_paragraph(@log_styles[level], message) unless level == 'warn'
    end
  end

  def create_table
    add_raw("<TABLE border='1' cellpadding='6' cellspacing='0'>")
    add_raw("  <THEAD>")
    add_raw("    <TR>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Symbol</TH>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Name</TH>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Type</TH>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Status</TH>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Created</TH>")
    add_raw("      <TH style='#{TABLE_HEADER_STYLE}'>Notes</TH>")
    add_raw("    </TR>")
    add_raw("  </THEAD>")
    add_raw("  <BODY>")
  end

  def close_table
    add_raw("  </BODY>")
    add_raw("</TABLE")
    add_line("")
  end

  def create_table_row(symbol, name, type, status, created, notes)
    add_raw("    <TR>")
    add_raw("      <TD style='#{TABLE_ROW_STYLE}'>#{symbol}</TD>")
    add_raw("      <TD style='#{TABLE_ROW_STYLE}'>#{name}</TD>")
    add_raw("      <TD style='#{TABLE_ROW_STYLE}'>#{type}</TD>")
    add_raw("      <TD style='#{TABLE_ROW_STYLE}'>#{status}</TD>")
    add_raw("      <TD style=#{TABLE_ROW_STYLE}'>#{created}</TD>")
    add_raw("      <TD style=#{TABLE_ROW_STYLE}'>#{notes}</TD>")
    add_raw("    </TR>")
  end

  def get_alerts
    create_section_header "alerts"
    shares = Share.order(:name)
    table_created = false
    shares.each do |share|
      share.do_all_alerts
      share.alerts.where(alert_status: ["NEW", "RENEW"]).each do |alert|
        create_table unless table_created
        table_created = true

        # TODO get text color from PILL_DATA and for notes get tooltip
        create_table_row(share.symbol, share.name, alert.alert_type, alert.alert_status, alert.created_at, "")
      end
    end
    close_table if table_created
  end

  def create_report
    add_line ""
    add_line ""
    add_line "<b>Weekly Share Report</b>"
    add_line "Generated at: <b>#{Time.zone.now}</b>"
    add_line ""

    get_exchange_rates
    get_prices
    get_dividends
    get_alerts
    
    add_line ""
    add_line "Finito at <b>#{Time.zone.now} </b>"
    add_line ""
  end

  def flush
    @lines.join("\n")
  end
end
