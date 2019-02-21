class Movie < ActiveRecord::Base
    
    enum all_ratings {"G", "PG", "PG-13", "R"}
end
