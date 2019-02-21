class Movie < ActiveRecord::Base

    def self.all_ratings
        self.pluck('rating').uniq 
    end
    
    def self.with_ratings(ratings)
        return self.where({rating: ratings}) 
    end
    
    def self.order_by(order_col)
        return self.order(order_col)
    end
end
