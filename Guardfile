# encoding: utf-8

def which cmd
  dir = ENV['PATH'].split(':').find {|p| File.executable? File.join(p, cmd)}
  File.join(dir, cmd) unless dir.nil?
end

def notify m
  msg = "'#{m.gsub(/'/, "''")}\\n#{Time.now.to_s}'"
  case
  when which('terminal-notifier')
    `terminal-notifier -message #{msg}`
  when which('notify-send')
    `notify-send #{msg}`
  when which('tmux')
    `tmux display-message #{msg}` if system('tmux list-clients 1>/dev/null 2>&1')
  end
end

guard :shell do
  watch /^(autoload|plugin|t)\/.+\.vim$/ do
    system "rake test"
    notify "test(s) failed" unless $?.success?
  end
end
