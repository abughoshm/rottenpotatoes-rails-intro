class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # check status of session and current params for redirect 
    sessionCheck = !session[:sorting].nil? || !session[:rating].nil?
    paramCheck = params[:sorting].nil? && params[:rating].nil?
    if (params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?))
      redirect_to movies_path(:sorting => session[:sorting], :ratings => session[:ratings])
    end

    @current_ratings = params[:ratings] || session[:ratings]
    @current_sorting = params[:sorting] || session[:sorting]
    @all_ratings = ['G','PG','PG-13','R']
    @current_rating_keys = @current_ratings.nil? ? @all_ratings : @current_ratings.keys
    @movies = Movie.where(rating: @current_rating_keys).order(@current_sorting)

    session[:sorting] = @current_sorting
    session[:ratings] = @current_ratings
    flash.keep
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
