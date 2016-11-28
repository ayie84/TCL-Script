#!/usr/bin/expect -f
## My References....
## http://stackoverflow.com/questions/15965504/how-to-create-log-file-for-tcl-script
## http://blog.rootshell.be/2009/04/02/boring-tasks-automation-with-expect/
## http://blog.omnidarren.com/2011/04/quick-and-dirty-telnet-script-for-switches-in-bash/
#
# This simple Expect script will add a new Syslog destination in
# Cisco switches (IOS based)
# We assume here that all switches uses the same credentials
# for the administrative tasks
#

set date [exec date +%F]
# Define variables
set username "YOURUSERNAME"
set password "YOURPASSWORD"
set enablepassword "YOUR ENABLE PASSWORD"

# Define all the switches to be reconfigured (separated by spaces)
set switches "172.20.1.69 172.20.1.70 172.20.1.72 172.20.1.73 172.20.1.74"

# Main loop
foreach switch $switches {
#NOW=$(date '+%Y%m%d%H%M%S')
log_file -a log/backup-$date.log # <<< === append output to a file
        puts "Processing switch: $switch";
        # Open the telnet session:
        spawn telnet $switch

        expect "Username:"
        send "$username\r"

        # Perform authentication
        expect "Password:"
        send "$password\r"
        expect ">"

        # Switch to enable mode
        send "en\r"
        expect "Password:"
        send "$enablepassword\r"
        expect "#"

        # Enable configuration mode (terminal)
        #send "show int status | include connected\r"
        send "show inven\r"
        expect "#"
		
        send "exit\r"
        expect eof
}
