class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :order_by, :ratings)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Base case checks
    if session[:ratings] == nil
      session[:ratings] = Movie.all_ratings
    end
    if session[:reverse_order] == nil
      session[:reverse_order] = false
    end
    if params[:ratings].kind_of? Hash
      params[:ratings] = params[:ratings].keys
    end
    
    @redirect = false
    
    # Ignore the case where no ratings are selected
    if params[:ratings] != nil
      session[:ratings] = params[:ratings]
    else
      params[:ratings] = session[:ratings]
      @redirect = true
    end
    
    # Ordering logic
    if params[:order_by] != nil
      session[:order_by] = params[:order_by]
    elsif session[:order_by] != nil
      params[:order_by] = session[:order_by]
      @redirect = true
    end
    
    if @redirect == true
      redirect_to movies_path(params)
    end
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    @movies = Movie.with_ratings(@selected_ratings).order_by(params[:order_by])
    
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
