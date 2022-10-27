require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
PLAY_COLOR = Gosu::Color.new(0xFF1D5DBA)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']


# Put your record definitions (Album class and Track class) here
class Album

attr_accessor :title, :artist, :genre, :tracks, :plocation

def initialize (atitle, aartist, agenre, arrtrk, ploc)

    @title=atitle
    @artist=aartist
    @genre=agenre
    @tracks=arrtrk
	@plocation=ploc
end

end

class Track

attr_accessor :ttitle, :tlocation

def initialize(tname, tloc)

@ttitle=tname
@tlocation=tloc

end
end


def read_track(music_file)

    title = music_file.gets.chomp
	file_location=music_file.gets.chomp
	track = Track.new(title, file_location)
	
	track

end


def read_tracks(music_file)

    count = music_file.gets().to_i
	tracks=Array.new
	
	for i in 0..count-1
	track = read_track(music_file)
	tracks<<track
	end
	
	tracks

end


def read_album(music_file)

    album_artist = music_file.gets.chomp
	album_title = music_file.gets.chomp
	album_photo = music_file.gets.chomp
	album_genre = music_file.gets.chomp
	tracks = read_tracks(music_file)
	
	album = Album.new(album_title, album_artist, album_genre, tracks, album_photo)
	album

end


def read_albums(music_file)

    albums = Array.new
	album_no = music_file.gets.chomp.to_i
	for x in 0..album_no-1
	   album = read_album(music_file)
	   albums << album
	end
	
	music_file.close()
	albums

end


def print_track (track, index)

    index+=1
    puts(index.to_s + '.Track title is: ' + track.ttitle.to_s)
	puts(index.to_s + '.Track file location is: ' +track.tlocation.to_s)
	
end


def print_tracks(tracks)

index = 0
while (index < tracks.length)
    print_track(tracks[index], index)
	index+=1
	end
	
	index
end


def print_album(albums)

index=0

for i in 0..albums.length-1

    puts
	puts "Album number: " + (i+1).to_s
	puts "Album number: " + albums[i].title
	puts "Album artist: " + albums[i].artist
	puts "Genre is: " + albums[i].genre.to_s
	puts GENRE_NAMES[albums[i].genre.to_i]
	index = print_tracks(albums[i].tracks)
	
	end
	
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 600, 800
	    self.caption = "Music Player"

	    music_file = File.new("albums.txt","r")
		@albumarr = read_albums(music_file)
		print_album(@albumarr)
		
		@button_font = Gosu::Font.new(20)
	end

  
  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

  def draw_albums
    # complete this code
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
     # complete this code
     if((@locs[0] > leftX  && @locs[0] < rightX) && (@locs[1] > topY && @locs[1] < bottomY ))
		return true
	else
		return false
	end	
  end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
  		 @song = Gosu::Song.new(@albumarr[album].tracks[track].tlocation)
  		 @song.play(false)

  end


# Not used? Everything depends on mouse actions.

	def update
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
		Gosu.draw_rect(0,0,600,800,BOTTOM_COLOR,ZOrder::BACKGROUND, mode=:default)
		@cphoto1 = Gosu::Image.new(@albumarr[0].plocation)
		@cphoto1.draw(10, 10, z=ZOrder::PLAYER)
		@cphoto2 = Gosu::Image.new(@albumarr[1].plocation)		
		@cphoto2.draw(10, 400, z=ZOrder::PLAYER)		
		
		tx=350
		ty=10
		tyy=400
		for x in 0..@albumarr[0].tracks.length-1
		Gosu.draw_rect(tx, ty, 200, 40, TOP_COLOR, z=ZOrder::PLAYER, mode=:default)
		@button_font.draw_text(@albumarr[0].tracks[x].ttitle, tx, ty, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
		ty += 50
		end
		for y in 0..@albumarr[1].tracks.length-1
		Gosu.draw_rect(tx, tyy, 200, 40, TOP_COLOR, z=ZOrder::PLAYER, mode=:default)		
		@button_font.draw_text(@albumarr[1].tracks[y].ttitle, tx, tyy, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)		
		tyy += 50
		end
		
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu

	def button_down(id)
		case id
		when Gosu::MsLeft
		@locs = [mouse_x,mouse_y]
		i=0
		ty1=10
		tyy1=50
		j=0
		ty2=400
		tyy2=440
		while (i<3)
		   if area_clicked(350, ty1, 550, tyy1)
		   playTrack(i, 0) 
		   end
		   ty1+=50
		   tyy1+=50
		   i+=1
		end
		
		while (j<2)
		   if area_clicked(350, ty2, 550, tyy2)
		   playTrack(j, 1)
		   end
		   j+=1
		   ty2+=50
		   tyy2+=50
		end
		end
		end
	end
# Show is a method that loops through update and draw

MusicPlayerMain.new.show 
