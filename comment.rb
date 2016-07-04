# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    comment.rb                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sballet <sballet@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/07/04 14:47:15 by sballet           #+#    #+#              #
#    Updated: 2016/07/04 16:56:35 by sballet          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
#!/usr/bin/env ruby -w
# ***********************hack to auto install dep***************************** #

unless %x!gem which colorize![-12..-1] == "colorize.rb\n"
   %x!gem install colorize!
end

# **************************************************************************** #
require "colorize"
require "pry"

VIEW_FOLDER = 'app/views/'
BAD_DIR = ['.','..','layouts']
BAD_FILE = ['.','_']

class String
  def erb?
    self[-3..-1] == "erb"
  end
end


def clean_file(file)
  ln = ""
  ln = file.shift until ln.strip == '<%if false%>'
  ln = ""
  ln = file.pop until ln.strip == '<%end%>'
  return file
end

def un_comment
  Dir.foreach(VIEW_FOLDER) do |fold_view|
    unless BAD_DIR.include? fold_view
      Dir.open( VIEW_FOLDER + fold_view ).each do |file|
        unless BAD_FILE.include? file[0]
          if file.erb?
            temp = File.open(File.join(VIEW_FOLDER , fold_view, file)).read.split("\n")
            unless temp.nil? || temp.first != "<!-- comment -->"
              puts VIEW_FOLDER + fold_view +'/'+ file
              temp = clean_file(temp.to_a)
            end
            File.open(File.join(VIEW_FOLDER , fold_view, file), "w") do |f|
              temp.each{|t| f.puts(t)}
            end
          end
        end
      end
    end
  end
end

def comment
  Dir.foreach(VIEW_FOLDER) do |fold_view|
    unless BAD_DIR.include? fold_view
      Dir.open( VIEW_FOLDER + fold_view ).each do |file|
        unless BAD_FILE.include? file[0]
          if file.erb?
            puts "Commenting : #{file}"
            try =  File.open(File.join(VIEW_FOLDER , fold_view, file)).read.split("\n")
            unless try.nil? && try.first ==  "<!-- comment -->"
              temp =  File.open(File.join(VIEW_FOLDER , fold_view, file)).read
              file_temp = File.open(File.join(VIEW_FOLDER , fold_view, file), "w")
              file_temp.write("<!-- comment -->\n<%if false%>\n"+temp+"\n<%end%>\n" )
              file_temp.close
            end
          end
        end
      end
    end
  end
end
if ARGV.count == 0
  puts "# **************************************************************************** #".colorize(:light_green)
  puts
  puts "comment or un-comment all .erb  VIEW_FOLDER = 'app/views/'".colorize(:blue)
  puts "/!\\\  Safety first ,File HAS to BEGIN             /!\\\ ".colorize(:red)
  puts  "/!\\\ with '<!-- comment -->' to be un-commented   /!\\\ ".colorize(:red)
  puts
  puts "\nUsage".colorize(:light_blue)
  puts " type 'ruby comment.rb co' to comment all views".colorize(:light_blue)
  puts " type 'ruby comment.rb unco' to un-comment all views".colorize(:light_blue)
  puts
  puts
  puts "or  you can offer me a:"
  puts
  puts "    (  )   (   )  )".colorize(:yellow)
  puts "     ) (   )  (  (".colorize(:yellow)
  puts "     ( )  (    ) )".colorize(:yellow)
  puts "     _____________".colorize(:yellow)
  puts "    |_____________| ___".colorize(:yellow)
  puts "    |             |/ _ \\\ ".colorize(:yellow)
  puts "    |               | | |".colorize(:yellow)
  puts "    |               |_| |".colorize(:yellow)
  puts " ___|             |\\\___/".colorize(:yellow)
  puts "/    \\\___________/    \\\ ".colorize(:yellow)
  puts "\\\_____________________/".colorize(:yellow)
  puts
  puts "# **************************************************************************** #".colorize(:light_green)
elsif ARGV[0] == 'co'
  comment
elsif ARGV[0] == "unco"
  un_comment
end
