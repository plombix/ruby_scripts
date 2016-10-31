# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    random_people.rb                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sballet <sballet@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/07/04 14:47:15 by sballet           #+#    #+#              #
#    Updated: 2016/07/06 13:37:24 by sballet          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# !/usr/bin/env ruby -w
begin
  require 'ffaker'
rescue LoadError
  system('gem install ffaker')
  Gem.clear_paths
end
begin
  require 'urss'
rescue LoadError
  system('gem install urss')
  Gem.clear_paths
end
require 'fileutils'
require 'open-uri'
require 'pry'

# Get vars
#===============================================================================
current_path = Dir.pwd
people_path = File.join(current_path, 'people')

# If no args
#===============================================================================
if ARGV.empty?
  puts 'usage: two options available, a num  OR clean '
  puts 'like so:'
  puts "\truby random_people.rb 254"
  puts 'a number will create number.times a goup of random info '
  puts "labeled by number suffixed by type and place in a folder 'people'"
  puts "\truby random_people.rb clean"
  puts 'clean will clean the content of the people folder previously created'

# if clean
#===============================================================================
elsif ARGV[0] == 'clean'
  if File.exist?(people_path)
    Dir.entries(people_path).each do |f|
      unless f[0] == '.'
        File.delete(File.join(people_path, f))
        puts "deleting #{people_path}/#{f}"
      end
    end
    FileUtils.remove_dir(people_path)
    puts 'Done cleaning'
  else
    puts "No 'people' folder to clean , generate some first!"
  end

# if num
#===============================================================================
elsif begin
         custom_range = Integer(ARGV[0])
       rescue
         false
       end

  # make folder & path
  Dir.mkdir('people') unless File.exist?('people')
  people_path = File.join(current_path, 'people')

  # make files and move in folder
  rss = Urss.at('http://www.flickr.com/services/feeds/photos_public.gne?format=rss_200'); true
  custom_range.times do |tm|
    puts "Generating nb: #{tm}"
    pict = File.new("#{tm}.jpg", 'wb') << open(rss.entries.first.medias.first.content_url).read
    File.rename(File.join(current_path, pict.path), File.join(people_path,
                                                              pict.path))
    File.open("#{tm}.add", 'a+') do |f|
      f.puts FFaker::AddressFR.street_address
      f.puts FFaker::AddressFR.postal_code.to_s + " #{FFaker::AddressFR.city}"
      File.rename(File.join(current_path, f.path), File.join(people_path,
                                                             f.path))
    end
    File.open("#{tm}.work", 'a+') do |f|
      f.puts FFaker::JobFR.title
      File.rename(File.join(current_path, f.path), File.join(people_path,
                                                             f.path))
    end
    File.open("#{tm}.name", 'a+') do |f|
      f.puts  FFaker::NameFR.first_name
      f.puts  FFaker::NameFR.last_name
      File.rename(File.join(current_path, f.path), File.join(people_path,
                                                             f.path))
    end
    File.open("#{tm}.tel", 'a+') do |f|
      f.puts FFaker::PhoneNumberFR.mobile_phone_number
      File.rename(File.join(current_path, f.path), File.join(people_path,
                                                             f.path))
    end
  end
  puts 'Done generating'

end
