class MainController < ApplicationController
  before_filter :require_authentication, except: [:index, :create]

  def index
  end

  def create
    session[:spotify_token] = auth_hash.credentials.token
    session[:spotify_user] = auth_hash.info.nickname
    session[:name] = auth_hash.info.name
    render action: "index"
  end

  def import
    if request.post?
      parser = SpotifyPlaylistImporter::WprbParser.new(HTTParty.get(params[:url]))
      songs = parser.get_songs
      playlist = SpotifyPlaylistImporter::Playlist.new(params[:playlist_name], songs)
      SpotifyPlaylistImporter::Spotify.access_token = session[:spotify_token]
      SpotifyPlaylistImporter::Spotify.user = session[:spotify_user]
      SpotifyPlaylistImporter::Spotify::Search.new.populate_spotify_song_ids!(playlist)
      logger.debug SpotifyPlaylistImporter::Spotify::Playlist.new(playlist).create!
      flash[:notice] = "Imported."
    end
    render action: "index"
  end

  private

  def require_authentication
    unless authorized?
      flash[:notice] = "You must authenticate with Spotify to perform this action."
      render action: "index" and return false
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
