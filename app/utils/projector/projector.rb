module Projector
  class Projector
    def initialize
      @projections = {}
      @ordered_projections = []
      @ordered_months = []
    end
      
    def project_shares
      Share.order(:name).each do |share|
        get_projection(share)
      end

      keys = @projections.keys.sort
      keys.each do | key|
        daily_projection = @projections[key]
        dp_keys = daily_projection.keys.sort
        dp_keys.each do |dp_key|
          @ordered_projections << daily_projection[dp_key]
        end
      end

      last_mkey = nil
      bucket =  nil
      @ordered_projections.each do |op|
        mkey = op[:projected_date].year.to_s + '_' + op[:projected_date].month.to_s
        if last_mkey != mkey
          bucket = ProjectorBucket.new(op[:projected_date])
          last_mkey = mkey
          @ordered_months << bucket
        end
        bucket.add_projection(op)
      end
      
      @ordered_months
    end
   
    def get_projection(share)   
      share_projections = share.projected_income
      share_projections.each do |sp|
        projected_date = sp[:projected_date]
        date_array = @projections[projected_date] || {}
        date_array[sp[:share_name]] = sp
        @projections[projected_date] = date_array
      end
    end
  end
end