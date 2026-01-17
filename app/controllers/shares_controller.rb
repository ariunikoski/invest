class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @shares = Share.order(:name)
  end
  
  def show
    @share=Share.find(params[:id])
    render partial: 'shares/show'
  end
  
  def create
    new_share_params = params.permit(:name, :currency, :israeli_number, :symbol)
    Share.new(new_share_params).save!
    redirect_to shares_url
  end
  
  def destroy
    share = Share.find(params[:id].to_i)
    return head :not_found if !share
    share.destroy
    head :ok
  end
  
  def update
    share = Share.find(params[:id])
    return head :bad_request if !share
    j_params = JSON.parse(params[:Share])
    j_params.keys.each { |key| j_params[key] = j_params[key].lstrip.sub(/^[<p>]*/, '') }
	share.update(j_params)
    head :ok
  end
  
  def load_yahoo_historicals
    @share=Share.find(params[:id])
    loader = Yahoo::HistoricalData.new(@share)
    loader.load
    render partial: 'shares/show'
  end
  
  def load_yahoo_summary
    @share=Share.find(params[:id])
    loader = Fmp::Profile.new()
    res = loader.load(@share.symbol)
    @share.sector = res[:sector] if res[:sector]
    @share.industry = res[:industry] if res[:industry]
    @share.yahoo_summary = res[:summary] if res[:summary]
    @share.save!
    render partial: 'shares/show'
  end
  
  def yahoo_current_prices
    loader = Yahoo::Quotes.new
    loader.load
    head :ok
  end
  
  def get_rates 
    @rates = Rates::RatesCache.instance.get_rates
  end
 
  def shares_by_account
    @accounts = Holding.select('DISTINCT account').order(:account)
  end
  
  def projected_income
    get_rates
    @projector = Projector::Projector.new
  end
    
  def breakdown_by_sector
    get_rates
    calculator = SectorBreakdown::Calculator.new(@rates)
    @sectors = calculator.load
    @grand_totals = calculator.get_grand_total
  end
  
  def breakdown_by_sector_condensed
    # same logic, different template
    breakdown_by_sector
  end
    
  def export_projected_income
    tt = Time.now
    fname = '../' + tt.strftime("%Y_%m_%d_%T.csv")
    outf = File.new(fname, "w")
    outf.puts "date,amount,name,symbol,currency,type,accounts"
    get_rates
    projector = Projector::Projector.new
    ordered_months, yearly_by_cur = projector.project_shares
    ordered_months.each do |om|
      om.projections.each do |projection|
        # {:projected_date=>Mon, 15 Jan 2024, :amount=>0.26825e3, :share_name=>"FISI", :share_symbol=>"FISI", :currency=>"USD", :type=>:share, :accounts=>"Balal,Meitav"}
        outf.puts "#{projection[:projected_date]},#{projection[:amount]},#{projection[:share_name,]},#{projection[:share_symbol]},#{projection[:currency]},#{projection[:type]},#{projection[:accounts].gsub(',',' ')}"
      end
    end
    outf.close
    render json: File.absolute_path(fname)
  end
  
  def load_all_dividends
    @shares = Share.order(:name)
    @shares.each do |share|
      loader = Yahoo::HistoricalData.new(share)
      loader.load
      created, duplicated, errors = loader.get_stats
      message = "#{share.symbol} - #{created} created, #{duplicated} duplicated, #{errors} errors"
      level = 'warn'
      level = 'info' if created > 0
      level = 'error' if errors > 0
      Log.create_log(level, message)
    end
    head :ok
  end

  def change_holder
    session[:holder_id] = params[:id]
    redirect_to shares_url
  end
end
