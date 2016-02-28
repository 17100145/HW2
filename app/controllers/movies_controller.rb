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
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings

  if (!params[:ratings] && !session[:ratings])
      @movies = Movie.all
      @check = Movie.all_ratings
  else
      if (params[:ratings] && !session[:ratings])
        session[:ratings] = params[:ratings]
      end 
      if (!params[:ratings])
        params[:ratings] = session[:ratings]
      end

      @check = params[:ratings].try(:keys)
      # if @check
      @movies = Movie.where(:rating => @check)
      # else
        # @movies = Movie.all
        # @check = Movie.all_ratings
      # end
      # @test = params[:sort]
      # @movies = Movie.order
      # @bgcolor = "hilite"

      if(params[:sort_by].to_s == "title")
        @movies = @movies.order(:title)
      elsif(params[:sort_by].to_s == "release_date")
        @movies = @movies.order(:release_date)
      end
      session[:ratings] = params[:ratings]
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

  def newUpdate
  end

  def actualUpdate
    @movie = Movie.find_by_title(params[:currentmovie][:title])
    if @movie
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      # redirect_to movies_path
    else
      flash[:notice] = "Error: Movie not found."
      # redirect_to movies_path
    end
    redirect_to movies_path
    # @movie = Movie.find params[:id]
  end

  def deleteT
  end

  def deleteMovieTitle
    # @movie = Movie.find_by_title(params[:currentmovie][:title])
    @movie = Movie.find_by_title(params[:movie][:title])
    if @movie
      @movie.destroy
      flash[:notice] = "#{@movie.title} was successfully deleted."
    else
      flash[:notice] = "Error: Movie not found."
    end
    redirect_to movies_path
  end

  def deleteR
  end

  def deleteMovieRating
    @moviesall = Movie.where(:rating => params[:movie][:rating])
    if @moviesall
      @moviesall.each do |mov|
        mov.destroy
      end
      flash[:notice] = "All movies with the specified rating were successfully deleted."
    else
      flash[:notice] = "There are no movies with #{@movie.rating} rating."
    end
    redirect_to movies_path
  end



end