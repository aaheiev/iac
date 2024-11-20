#!/usr/bin/env ruby

require 'getoptlong'
require 'json'

help_message = <<-EOF
#{__FILE__} [OPTION]
-h, --help:
   show help
--plan path, -p path:
   plan file path
EOF

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--plan', '-p', GetoptLong::REQUIRED_ARGUMENT ]
)

plan_path = ""

opts.each do |opt, arg|
  case opt
    when '--help'
      puts help_message
      exit
    when '--plan'
      plan_path = arg.to_s
  end
end

begin
  plan = JSON.parse(File.read(plan_path))
  resources_to_update = 0
  resources_to_create = 0
  resources_to_delete = 0

  plan["resource_changes"].each do |resource_change|
    action = resource_change["change"]["actions"][0]
    case action
      when "delete"
        resources_to_delete += 1
      when "create"
        resources_to_create += 1
      when 'update'
        resources_to_update += 1
    end
  end
  if (resources_to_create + resources_to_update + resources_to_delete) == 0
    puts "{}"
  else
    ret = {
        create: resources_to_create,
        update: resources_to_update,
        delete: resources_to_delete
    }
    puts ret.to_json

#     puts "| layer | create | update | delete |"
#     puts "|-------|--------|--------|--------|"
#     puts "| #{File.dirname(plan_path)} | #{resources_to_create} | #{resources_to_update} | #{resources_to_delete} |"
#     puts "resources_to_create: #{resources_to_create}"
#     puts "resources_to_update: #{resources_to_update}"
#     puts "resources_to_delete: #{resources_to_delete}"
  end
rescue Exception => e
  puts e
end
