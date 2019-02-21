class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :order_by, :ratings)
    @selected_ratings = Movie.all_ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Handle rating slection
    if params[:ratings] != nil
      @movies = Movie.with_ratings(params[:ratings].keys)
      @selected_ratings = params[:ratings].keys
    elsif
      @movies = Movie.all
      @selected_ratings = Movie.all_ratings
    end
   
    @all_ratings = Movie.all_ratings
    
    # Handle ordering
    if params[:order_by] != nil
      if params[:order_by] != session[:order_by]
        @movies.order!(params[:order_by])
        session[:order_by] = params[:order_by]
      elsif params[:order_by] == session[:order_by]
        @movies.order!(params[:order_by]).reverse_order!
        session[:order_by] = nil
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
