class Movie < ActiveRecord::Base
  def self.ratings
    #@test = Movie.order(:rating).select(:rating).distinct
    Movie.distinct.pluck(:rating).sort
    #Movie.order(:rating).select(:rating).distinct.inject([]){ |ratings_list, movie| ratings_list.push movie.rating}
  end
end
