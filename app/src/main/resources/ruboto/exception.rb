def Exception.print_backtrace(msg = nil)
  puts msg if msg
  puts "#{self.class} #{message}"
  puts self
  puts backtrace.join("\n")
  if cause
    print "Caused by: "
    cause.print_backtrace
  end
end
