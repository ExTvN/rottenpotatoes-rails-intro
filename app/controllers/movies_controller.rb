class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || Movie.ratings_to_show
    #@movies = Movie.all

    #if params[:ratings].present?
    # @ratings_to_show = params[:ratings].keys
    #end

    @sort_column = params[:sort]

    valid_sort_columns = ['title', 'release_date']

    unless valid_sort_columns.include?(@sort_column)
      @sort_column = nil
    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if @sort_column.present?
      @movies = @movies.order(@sort_column)
      @header_css_class = 'hilite bg-warning'
    end


    @title_sort_path = movies_path(sort: 'title', ratings: @ratings_to_show)
    @release_date_sort_path = movies_path(sort: 'release_date', ratings: @ratings_to_show)
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
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  # def header_css_class(column_name)
  #   if @sort_column == column_name
  #     return 'hilite bg-warning'
  #   else
  #     return ''
  #   end
  # end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
