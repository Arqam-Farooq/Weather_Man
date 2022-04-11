# Data retrive form file
require 'date'
require 'colorize'
def file_headings(file_path)
 if file_path
  file = File.open (file_path)
  headings = file.readline.split(',')
  values = file.read
  values = values.split(',')
  return data = [headings,values]
 else
   puts "File is not open or found please correct command line argument"
   exit
 end
end

# Part 1*****************************************************************************
# Find Max temperat-ure
def average(data_name,heading,value)
  size = heading.length
  data_size = (value.length / size) + 1
  for i in heading
    if i == data_name
      index = heading.index(data_name)
      f_index = index
      sum, count = 0, 0
      data_size.times do |n|
      sum += value[index].to_i
      unless value[index].to_i == 0
        count= count + 1
      end
        index +=  size - 1
      end
    end
  end
  return sum / count
end
def max_value(data_type, data, data2)

  size = data.length
  data_size = (data2.length/size) + 1
  for i in data
    if i == data_type
      index = data.index(data_type)
      f_index = index
      max_t = data2[index]
      date = data2[index - f_index]
      data_size.times do |n|
        if data2[index] > max_t
          date = data2[index-f_index]
          max_t = data2[index]
        end
        index += size - 1
      end
    end
  end
  list = [max_t, date.slice(3, 10)]
  return list
end

# Find Minimum Temperature
def min_value(data_type, data, data2)
  size = data.length
  data_size = (data2.length / size) + 1
  min_t = '0'
  date,= '0'
  data.each do |i|
    if i == data_type
      index = data.index(data_type)
      f_index = index
      min_t = data2[index]
      date = data2[index - f_index]
      data_size.times do |n|
        if data2[index] > '0' && data2[index] < min_t
          date = data2[index - f_index]
          min_t = data2[index]
        end
        index = index + size - 1
      end

    end
  end
  list = [min_t,date.slice(3, 10)]
  return list
end
def get_col_data(data_name, headings, value)
  size = headings.length
  data_size = (value.length / size)
  list=[]
  headings.each do |i|
    if i == data_name
      index = headings.index(data_name)
      data_size.times do
        list.append(value[index])
        index = index + size - 1
      end
    end
  end
  list
end
# handling the command line arrgument
module Arrgument
  case ARGV[0]
  when '-e'
    di = Dir["#{ARGV[2]}/*#{ARGV[1]}*.txt"]
    list, list2, list3, max_temperature, date_maxtemp = Array.new(5) { [] }
    min_temperature, date_mintemp, humidity, date_humidity = Array.new(4) { [] }
    if di.empty?
      puts "There is no such file given"
    else
      di.length.times do |i|
        list_data = file_headings(di[i])
        list.append(max_value('Max TemperatureC', list_data[0], list_data[1]))
        list2.append(min_value('Min TemperatureC', list_data[0], list_data[1]))
        list3.append(max_value('Max Humidity', list_data[0], list_data[1]))
        max_temperature.append(list[i][0].to_i)
        date_maxtemp.append(list[i][1])
        min_temperature.append(list2[i][0].to_i)
        date_mintemp.append(list2[i][1])
        humidity.append(list3[i][0].to_i)
        date_humidity.append(list3[i][1])
      end
      datee = date_maxtemp[max_temperature.index(max_temperature.max)]
      puts "Highest #{max_temperature.max}C on #{datee}"
      datee = date_mintemp[min_temperature.index(min_temperature.min)]
      puts "Lowest #{min_temperature.min}C on #{datee}"
      datee = date_humidity[humidity.index(humidity.max)]
      puts "Humidity #{humidity.max}C on #{datee}"
    end

  when '-a'
    file_month = ARGV[1].split('/')
    path = Date::MONTHNAMES[file_month[1].to_i].slice(0, 3).to_s
    di = Dir["#{ARGV[2]}/*#{file_month[0]}_#{path}*.txt"]
    list_data = file_headings(di[0])
    tmp_t = average('Max TemperatureC', list_data[0], list_data[1])
    puts "Highest Averge: #{tmp_t}C"
    tmp_t = average('Min TemperatureC', list_data[0], list_data[1])
    puts "Lowest Averge: #{tmp_t}C"
    tmp_t = average('Max Humidity', list_data[0], list_data[1])
    puts "Humidity Averge: #{tmp_t}C%"
  when '-c'
    file_month = ARGV[1].split('/')
    path = Date::MONTHNAMES[file_month[1].to_i].slice(0, 3).to_s
    di = Dir["#{ARGV[2]}/*#{file_month[0]}_#{path}*.txt"]
    list_data = file_headings(di[0])
    max = get_col_data('Max TemperatureC', list_data[0], list_data[1])
    min = get_col_data('Min TemperatureC', list_data[0], list_data[1])
    (list_data[1].length / list_data[0].length).times do |i|
      symbol1 = Array.new(max[i].to_i, '+')
      symbol2 = Array.new(min[i].to_i, '+')
      string =  "#{i + 1} #{symbol1.join.red}#{symbol2.join.blue}"
      string2 = "#{max[i].to_i}C - #{min[i].to_i}C"
      puts string + string2
    end
  end
end
