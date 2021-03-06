# Main method for starting the game
# Called in bin/run.rb
def play_game
  system "clear"
  print "\e[8;1000;1000t"
  welcome if !$TEST_MODE
  current_user = get_user
  menu(current_user)
end

# Gratuitous ASCII art introduction
def welcome
  system "clear"
  aa = Artii::Base.new :font => 'univers'
  bb = Artii::Base.new :font => 'doh'
  cc = Artii::Base.new :font => 'larry3d'
  dd = Artii::Base.new :font => 'banner3'
  puts bb.asciify('Welcome to')
  sleep(2)
  system "clear"
  puts aa.asciify("Who Wants To Be A")
  sleep(1)
  puts bb.asciify("   Millionbear")
  puts cc.asciify(" $$$$$$$$$$$$$$$$$$$$$$$")
  sleep(2)
  system "clear"
  puts aa.asciify "      With your host"
  sleep(1)
  system "clear"
  puts bb.asciify "            Alex"
  puts bb.asciify "       Trebear"
  sleep(2)
  system "clear"
  # bear_host

  if !$IS_LITE_MODE
    Catpix::print_image "lib/cli/img/bear5.png",
      :center_x => true,
      :resolution => "low",
      :bg_fill => false
    puts
  end
end

# Asks for user input for user name
# And creates new user instance

def get_user
  print "What's your name?".center(`tput cols`.to_i)
  print "".center(95)
  new_name = gets.chomp

  while new_name.downcase.start_with?("drop table")
    puts
    puts "You think you're sooooooo clever, huh?".center(`tput cols`.to_i)
    puts
    print "What's your REAL name?".center(`tput cols`.to_i)
    print "".center(95)
    new_name = gets.chomp
  end

  puts
  new_user = User.find_or_create_by(name: new_name)
  new_user
end


# Main menu for user to start game, view leaderboard, or exit
def menu(user)
  system "clear"
  print "\e[8;1000;1000t"
  aa = Artii::Base.new :font => 'doom'
  puts aa.asciify("What would you like to do?".center(110))
  puts
  puts aa.asciify("1.  Play a New Game ".center(125))
  puts aa.asciify("2.  View Leaderboard".center(125))
  puts aa.asciify("3.  How to Play     ".center(125))
  puts aa.asciify("4.  Exit            ".center(125))
  user_input = gets.chomp
  if user_input == "1"
    start_game(user)
  elsif user_input == "2"
    display_leaderboard(user)
  elsif user_input == '3'
    how_to_play(user)
  elsif user_input == "4"
    system "clear"
    puts aa.asciify("Thanks for playing!")
    bye_bear
    sleep(3)
    return nil
  else
    puts "Selection not recognized"
    system "clear"
    menu(user)
  end
end

def display_leaderboard(user)
  system "clear"
  rows = []
  puts
  puts "Leaderboard:".center(`tput cols`.to_i)
  puts
  top_scores = GameSession.all.max_by(10){|sesh| sesh.total_score}
  10.times do |index|
    gg = top_scores[index]

    if gg
      rows << [index+1, gg.user.name, gg.total_score]
    else
      rows << [index+1, "---", "---"]
    end
   #puts "#{count}. #{gg.user.name}"

   end
   table = Terminal::Table.new do |t|
    t.headings = ["Rank", "Name", "Score"]
    t.rows = rows
    t.style = {:margin_left => ''.center($GAME_WIDTH)}
  end

   puts table
   sleep(3)
   system "clear"
   menu(user)
end
