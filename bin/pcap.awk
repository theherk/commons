#!/usr/bin/awk -f

# For each line that starts with a timestamp, store it
/^[0-9]/ {
    current_timestamp = $1
}

# For each line that starts with "IP" and doesn't contain "VXLAN"
/^IP/ && !/VXLAN/ {
    if (first == "") {
        # Store first line of pair
        first = $0
        ts = current_timestamp
    } else {
        # Process second line of pair
        # Get flags
        flags = $0
        if (match(flags, /Flags \[[^]]+\]/)) {
            flag_text = substr(flags, RSTART, RLENGTH)
        }

        # Split into IP components
        split(first, a, " > ")
        split($0, b, " > ")

        # Print result
        print ts, a[1], ">", b[2], flag_text

        # Reset for next pair
        first = ""
    }
}
