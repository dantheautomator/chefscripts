# Author: Dan Nemec (<catdaddy@geeksgonemad.com>)
# Original author: I can't find the original author. Please contact me if you know and I'll happily attribute.
# added the error handling to allow re-run. Will not overwrite existing objects.
###
# disable JSON inflation
JSON.create_id = "no_thanks"

out_dir = "chef_server_backup"

# load clients
print "load clients\n"
Dir["#{out_dir}/clients/*"].each do |path|
  client = JSON.parse(IO.read(path))
begin
  api.post("clients", {
             :name => client['name'],
             :public_key => client['public_key']
           })
rescue Exception => ex
  print "Error creating client #{client['name']}"
  print "\n"
  print ex.message
  print "\n"
end
end

# load nodes
print "load nodes\n"
Dir["#{out_dir}/nodes/*"].each do |path|
  the_node = JSON.parse(IO.read(path))
begin
  api.post("nodes", the_node)
rescue Exception => ex
  print "Error creating node #{the_node['name']}"
  print "\n"
  print ex.message
  print "\n"
end
end
###

# load roles
print "load roles\n"
Dir["#{out_dir}/roles/*"].each do |path|
  the_role = JSON.parse(IO.read(path))
begin
  api.post("roles", the_role)
rescue Exception => ex
  print "Error creating role #{the_role['name']}"
  print "\n"
  print ex.message
  print "\n"
end
end
###

# load data_bag
print "load data bags\n"
Dir["#{out_dir}/data_bags/*"].each do |path|
  data_bag = path.split(/\//)[-1]
begin
  api.post("data", {
             :name => data_bag
           })
rescue Exception => ex
  print "Error creating data_bag #{data_bag}"
  print "\n"
  print ex.message
  print "\n"
end
  Dir["#{out_dir}/data_bags/#{data_bag}/*"].each do |item|
    item_name_full = item.split(/\//)[-1]
    item_name = item_name_full.split(/\./)[0]
    data_bag_item = JSON.parse(IO.read(item))
    api.post("data/#{data_bag}", data_bag_item)
  end
end
