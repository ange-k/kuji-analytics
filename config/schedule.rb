require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/cron.log'

every 1.week do
  command "echo 'mossmossmossmossmossmoss'"
end