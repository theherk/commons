#!/usr/bin/env fish

function print_usage
    echo "Usage: "(status filename)" <domain>"
    echo "Example: "(status filename)" example.com"
end

# Check if an argument is provided
if test (count $argv) -ne 1
    print_usage
    exit 1
end

set domain $argv[1]

while true
    set result (dig $domain +short)
    if test -n "$result"
        echo "Result found for $domain: $result"
        break
    end
    echo "No result yet for $domain, retrying..."
    sleep 5
end
