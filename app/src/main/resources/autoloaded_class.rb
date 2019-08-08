puts "Loading #{__FILE__}"

class AutoloadedClass
  puts "Loading #{self}"

  def perform
    puts 'Perform'
  end
end

puts "Loaded #{__FILE__}"
