#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/works_order_sync"

root = File.expand_path("..", __dir__)
path = File.join(root, WorksOrderSync::WORKS_ORDER_FILE)
before = File.exist?(path) ? File.read(path) : nil

WorksOrderSync.run(root)

if File.exist?(path) && File.read(path) != before
  puts "Updated #{WorksOrderSync::WORKS_ORDER_FILE}"
else
  puts "#{WorksOrderSync::WORKS_ORDER_FILE} already in sync"
end
