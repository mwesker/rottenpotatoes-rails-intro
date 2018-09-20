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
    @all_ratings = Movie.ratings
    @sort = params[:sort_by] || session[:sorted]
    set_style @sort
    session[:rating_params] = session[:rating_params] ||  all_ratings_hash
    @params = params[:ratings].nil? ? session[:rating_params] : params[:ratings] 
    session[:rating_params] = @params
    session[:sorted] = @sort
    @movies = Movie.where(:rating => @params.keys).order(session[:sorted]) 
    if (( params[:sort_by].nil? and !session[:sorted].nil? ) or (params[:ratings].nil? and !session[:rating_params].nil?))
      flash.keep
      redirect_to movies_path(:sort_by => session[:sorted],:ratings => @params)
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
  
  def all_ratings_hash arr
    hash = Hash.new
    arr.each {|e| hash[e] = 1 }
  end
  
  def set_style sort
    @style_sort_by = "hilite" if sort == 'title'
    @style_ratings = "hilite" if sort == 'release_date'
  end
end
