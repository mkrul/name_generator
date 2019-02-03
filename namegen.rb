require "httparty"
require "rspec/autorun"

def start
  names_list = []
  names = get_names(names_list)

  loop do
    puts "Generate a new random name? [y/n] "
      answer = gets.chomp.upcase

      break if answer == "N"
      name_parts = slice_names(names)

      first_name = generate_name(name_parts)
      middle_name = generate_name(name_parts)
      last_name = generate_name(name_parts)

      print "\nYour new name is: #{first_name} #{middle_name} #{last_name}\n\n"
    end

  exit
end

def get_names(names_list)
  uri ="https://www.behindthename.com/api/random.json?number=6&key=XXXXXXXXXX"
  puts "Aquiring name data. Please wait..."
  sleep(1)

  10.times do
    response = HTTParty.get(uri)
      response.parsed_response["names"].each do |n| 
        print(".")
	sleep(0.05)
        names_list.push(n.downcase)
      end
    end
  print("\n")
  names_list
end

def slice_names(names_list)
  name_slices = []
  names_list.each do |n|
    name_length = n.length
    if name_length <= 3
      name_slices.push(n)
    elsif name_length == 4
      name_slices.push(*n.gsub(/ /, "") .chars.each_slice(2).map(&:join))
    else
      name_slices.push(*n.gsub(/ /, "").chars.each_slice(4).map(&:join))
    end
  end
  name_slices.reject { |slice| slice.length < 2 }
end

def generate_name(name_parts)
  name_length = rand(1..2)
  name = ""

  name_length.times do
    rand_index = rand(0..name_parts.length)
    unless name_parts[rand_index].nil?
      name << name_parts[rand_index]
    end
  end
  name.capitalize
end

start


# ------ TESTS -----------

describe "#get_names" do
  it "returns a list of 60 names" do
    names_list = get_names(names_list)

    expect(names_list.count).to eq(60)
  end
end

describe "#slice_names" do
  it "returns an array of three-char slices" do
    names_list = ["Stephen", "Jo", "Erin", "Leslie"]

    expect(slice_names(names_list)).to eq(["Step", "hen", "Jo", "Er", "in", "Lesl", "ie"])
  end
end

describe "#generate_name" do
  it "returns a capitalized name" do
    name_parts = ["mi", "sha"]

    expect(generate_name(name_parts)).to include("Mi" || "Sha")
  end
end

