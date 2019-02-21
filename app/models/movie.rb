class Movie < ActiveRecord::Base
    
    def self.all_ratings
      self.pluck('rating').uniq 
    end
    
    def self.with_ratings(ratings)
       self.where({rating: ratings}) 
    end
end
