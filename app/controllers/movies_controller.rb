class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
  
    # Load filter and sort options from session, or use defaults
    @ratings_to_show = session[:ratings] || @all_ratings
    @sort_column = session[:sort]
  
    # If new filter or sort options are provided in params, update session
    if params[:ratings]
      @ratings_to_show = params[:ratings]
      session[:ratings] = @ratings_to_show
    end
  
    if params[:sort]
      @sort_column = params[:sort]
      session[:sort] = @sort_column
    end
  
    @movies = Movie.with_ratings(@ratings_to_show)
    if @sort_column.present?
      @movies = @movies.order(@sort_column)
      @header_css_class = 'hilite bg-warning'
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

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
