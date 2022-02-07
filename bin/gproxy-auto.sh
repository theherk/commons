#!/usr/bin/expect --

set timeout 180
set userid adam.lawrence.sherwood@theherk.com
set devicelogin ~/bin/devicelogin.py
spawn sudo ssh -f -F /Users/h4s/.ssh/gproxy.cfg -nNT gproxy2
expect {
  Password: {
    stty -echo
    expect_user -re "(.*)\n"
    send_user "\n"
    send "$expect_out(1,string)\r"
    stty echo
    exp_continue
  }
  -re "To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code (.*) to authenticate." {
    send_user "Code: $expect_out(1,string)\r"
    set code $expect_out(1,string)
    system $devicelogin $code $userid
    send_user "Authentication OK!"
    send "\r"
    exp_continue
  }
}
