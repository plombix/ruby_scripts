begin
  require 'ffaker'
rescue LoadError
  system('gem install ffaker')
  Gem.clear_paths
end
require 'fileutils'
require 'open-uri'

current_path = Dir.pwd
if ARGV.empty?
  puts 'usage: two options available, a num  OR clean '
  puts 'like so:'
  puts "\truby random_people.rb 254"
  puts 'a number will create number.times a goup of random info '
  puts "labeled by number suffixed by type and place in a folder 'people'"
  puts "\truby random_people.rb clean"
  puts 'clean will clean the content of the people folder previously created'
elsif ARGV[0] == 'clean'
  people_path = File.join(current_path, 'people')
  if File.exist?(people_path)
    Dir.entries(people_path).each do |_f|
      unless _f[0] == '.'
        File.delete(File.join(people_path, _f))
        puts "deleting #{people_path}/#{_f}"
      end
    end
    FileUtils.remove_dir(people_path)
    puts 'Done cleaning'
  else
    puts "No 'people' folder to clean , generate some first!"
  end
# get num
elsif begin
         custom_range = Integer(ARGV[0])
       rescue
         false
       end

  # make folder & path
  Dir.mkdir('people') unless File.exist?('people')
  people_path = File.join(current_path, 'people')

  custom_range.times do |tm|
    puts "Generating nb: #{tm}"
    pict = File.new("#{tm}.png", 'wb') << open(FFaker::Avatar.image).read
    File.rename(File.join(current_path, pict.path), File.join(people_path, pict.path))
    add = File.open("#{tm}.add", 'a+') do |f|
      f.puts FFaker::AddressFR.full_address
      File.rename(File.join(current_path, f.path), File.join(people_path, f.path))
    end
    job = File.open("#{tm}.work", 'a+') do |f|
      f.puts FFaker::JobFR.title
      File.rename(File.join(current_path, f.path), File.join(people_path, f.path))
    end
    num = File.open("#{tm}.tel", 'a+') do |f|
      f.puts FFaker::PhoneNumberFR.home_work_phone_number
      f.puts FFaker::PhoneNumberFR.home_work_phone_number
      f.puts FFaker::PhoneNumberFR.mobile_phone_number
      File.rename(File.join(current_path, f.path), File.join(people_path, f.path))
    end
  end
  puts 'Done generating'

end
