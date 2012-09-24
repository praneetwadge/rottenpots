class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.ratings()

    if params[:ratings] == nil and params[:sorter] == nil
    	if session[:ratings] != nil and session[:sorter] != nil
    		flash.keep
    		redirect_to movies_path :ratings => session[:ratings], :sorter => session[:sorter]
    	elsif session[:ratings] != nil
    		flash.keep
    		redirect_to movies_path :ratings => session[:ratings]
    	elsif session[:sorter] != nil
    		flash.keep
    		redirect_to movies_path :sorter => session[:sorter]
    	end
    elsif params[:sorter] != nil
    	session[:sorter] = params[:sorter]
    elsif params[:ratings] != nil
    	session[:ratings] = params[:ratings]
    end


    if params[:ratings].is_a? Hash and params[:ratings] != nil
    	session[:ratings] = params[:ratings].keys
    elsif params[:ratings] != nil
    	session[:ratings] = params[:ratings]
    elsif session[:ratings] == nil
     	session[:ratings] = Movie.ratings()
    end


    if  session[:sorter] == 'mtitle'
	@movies = Movie.find(:all, :conditions => {:rating => session[:ratings]}, :order => :title)
    elsif session[:sorter] == 'rdate'
	@movies = Movie.find(:all, :conditions => {:rating => session[:ratings]}, :order => :release_date)
    else
    	@movies = Movie.find(:all, :conditions => {:rating => session[:ratings]})
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
