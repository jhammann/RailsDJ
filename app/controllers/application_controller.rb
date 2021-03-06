class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_setup
  before_filter :set_vars

  helper_method :current_user
  before_filter :require_user

  def index
    @users = User.all
    @artists = Artist.limit(50)
  end

  def play
    Client.stop
    pid = Process.fork { Client.loop }
    Process.detach(pid)
    render :nothing => true
  end

  def pause
    Client.pause
    render :nothing => true
  end

  def stop
    Client.stop if Client.playing?
    render :nothing => true
  end

  def volume
    Client.volume(params[:id])
  end

private
  def set_vars
    @songs = Song.queue.all
    @now_playing = Song.where(:now_playing => true)
  end

  def check_setup
    redirect_to setups_path unless Setup.done
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to login_path if !current_user
  end
end
