#!/bin/env ruby

# Simple script that parses the interface usage statistics
# as returned by 'ip -s link'
#
# This script should be useful for machine statistic collection
# ie: ethernet bytes transmitted and received, etc.

def assert(should_be_true, message)
    if !should_be_true
        STDERR.puts message
        exit(false)
    end
end


# get input to parse
#
# try reading from stdin
# otherwise invoke ip -s link directly

if STDIN.tty?
    # no pip-ed input...invoke directly
    cmd = "ip -s link"
    input = `#{cmd}`
    
    assert($?.exitstatus == 0, "Command failed.")
else
    input = ARGF.read    
end

# split results into lines
lines = input.split("\n")

# sanity check number of lines
assert(lines.length != 0        , "Command output empty")
assert(lines.length % 6 == 0    , "Command output not expected length")

# group lines into block of 6...each interface's results are on 6 lines 
interfaces_lines = lines.each_slice(6).to_a

# iterate over each interface's set of lines
interfaces_lines.each do |interface_lines|
    # sanity check RX line
    expected_RX_line = "    RX: bytes  packets  errors  dropped overrun mcast   "
    assert(interface_lines[2] == expected_RX_line, "RX line not expected: #{expected_RX_line}")
       
    # sanity check TX line
    expected_TX_line = "    TX: bytes  packets  errors  dropped carrier collsns "
    assert(interface_lines[4] == expected_TX_line, "TX line not expected: #{expected_TX_line}")
    
    interface_name = interface_lines[0].split()[1].chomp(":")
    tx_bytes = interface_lines[3].split()[0].to_i
    rx_bytes = interface_lines[5].split()[0].to_i
    
    puts "#{interface_name} #{tx_bytes} #{rx_bytes}"
end

