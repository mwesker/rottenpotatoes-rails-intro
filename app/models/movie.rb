class Movie < ActiveRecord::Base
  def self.ratings
    Movie.order(:rating).select(:rating).distinct.inject([]){ |ratings_list, movie| ratings_list.push movie.rating}
  end
end
