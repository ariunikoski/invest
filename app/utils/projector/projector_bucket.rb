module Projector
  class ProjectorBucket
    def initialize(first_date)
      @first_date = first_date
      @projections = []
      @tot_by_cur = {}
    end
    
    def add_projection(projection)
      @projections << projection
      cur = projection[:currency]
      tot_by_cur = @tot_by_cur[cur] || 0
      @tot_by_cur[cur] = projection[:amount] + tot_by_cur
    end
    
    def dump
      puts "--> dump for date #{@first_date}} "
      puts "projections: #{@projections}"
      puts "tot_by_cur: #{@tot_by_cur}"
    end
  end
end
      