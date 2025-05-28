#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Links
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗

# Documentation:
# @raycast.description Opens a list of URL's from the file ~/.links.
# @raycast.author theherk
# @raycast.authorURL https://raycast.com/theherk

set homeFolder to (system attribute "HOME")
set linksFile to homeFolder & "/.links"
set fileExists to do shell script "if [ -f " & quoted form of linksFile & " ]; then echo 'true'; else echo 'false'; fi"

if fileExists is equal to "true" then
    set urlList to paragraphs of (do shell script "cat " & quoted form of linksFile & " | grep -v '^$'")
    set urlCount to 0
    repeat with currentURL in urlList
        set trimmedURL to do shell script "echo " & quoted form of currentURL & " | awk '{$1=$1};1'"
        if length of trimmedURL > 0 then
            try
                tell application "System Events"
                    open location trimmedURL
                end tell
                set urlCount to urlCount + 1
                delay 0.1
            on error errMsg
                display dialog "Error opening URL: " & trimmedURL & return & errMsg
            end try
        end if
    end repeat

    if urlCount > 0 then
        return "Successfully opened " & urlCount & " links"
    else
        return "No valid URLs found in ~/.links"
    end if
else
    return "Error: ~/.links file not found"
end if
