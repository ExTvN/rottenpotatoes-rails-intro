class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  return all if ratings_list.blank?

  uppercase_ratings = ratings_list.map(&:upcase)

  where(rating: uppercase_ratings)

  end

  def self.all_ratings
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
  end

  def self.ratings_to_show
      @ratings_to_show = ['G', 'PG', 'PG-13', 'R']
  end




end
