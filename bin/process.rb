def is_running?(pid)
  return false unless pid
  grep_line = `ps -ef | grep #{pid} | grep -v grep | grep ruby` 
  grep_line.split(/\s/).include?(pid)
end

def run_tasks(task) 
  current_pid = Process.pid.to_s
  puts "started #{task[:description]} task: pid #{current_pid}"

  pid = File.exists?(task[:pid_file]) ? IO.readlines(task[:pid_file]).first.chomp : nil

  if is_running?(pid)
    puts "pid #{pid} for task #{task[:description]} is already running"
  else
    IO.write(task[:pid_file], current_pid, mode: "w")
    e = task[:environment]
    puts "\n---------\nStart task #{task[:description]} for environment #{e} ---------"
    system("RAILS_ENV=#{e} rake #{task[:task]}")  
    puts "End task #{task[:description]} for environment #{e} ---------"
  end
  puts "ended #{task[:description]} task: pid #{current_pid}"
end