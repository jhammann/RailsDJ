class Album < ActiveRecord::Base
  has_many :songs
  belongs_to :artist
  belongs_to :genre
  has_attached_file :art, :styles => { :thumb => "100x100>", :medium => "300x300>" }

  # Queue up an entire ALBUM!
  #
  #   user - the User who is requesting the album to be queued
  #
  # Returns nothing.
  def enqueue!(user)
    songs.each{ |song| song.enqueue!(user) }
  end
end
