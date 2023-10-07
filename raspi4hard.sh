#Step 1. Install Uncomplicated FireWall (ufw)
#Or use ModSecurity instead

#Step 2. Install Fail2Ban

#Step 3. Harden ssh [optional]

#Step 4. Detect and Lessen Impact of Denial of Service Attacks
# mod_evasive is a module for Apache, which provides evasive action in the event of a Denial of Service attack or brute force attack. Install mod_evasive by running the command:

sudo apt-get install libapache2-mod-evasive -y

#Create a log directory:

sudo mkdir /var/log/mod_evasive

sudo chown www-data:www-data /var/log/mod_evasive

#Edit:

sudo nano /etc/apache2/mods-available/evasive.conf

#and 

#uncomment all lines except DOSSystemCommand. 
#change DOSEmailNotify to your email address.

#Save and exit the editor

#Restart apache2

sudo service apache2 restart

#If failed, then install Apache2 using:

sudo apt install apache2 libapache2-mod-wsgi -y

sudo service apache2 restart

#Step 5. Prevent IP Spoofing.

#Open a terminal window on MacBook and login to Raspberry Pi

#Edit the file

sudo nano /etc/host.conf

#Add or edit the following lines :

order bind,hosts

#Step 6. Harden sysctl configuration settings

#Edit the file:

sudo nano /etc/sysctl.conf

#Uncomment or add the following lines :

# IP Spoofing protection

net.ipv4.conf.default.rp_filter = 1

net.ipv4.conf.all.rp_filter = 1



# Disable source packet routing

net.ipv4.conf.all.accept_source_route = 0

net.ipv6.conf.all.accept_source_route = 0 



# Ignore send redirects

net.ipv4.conf.all.send_redirects = 0

net.ipv6.conf.all.send_redirects = 0

net.ipv4.conf.default.send_redirects = 0



# Block SYN attacks

net.ipv4.tcp_syncookies = 1

net.ipv4.tcp_max_syn_backlog = 2048

net.ipv4.tcp_synack_retries = 2

net.ipv4.tcp_syn_retries = 5



# Log Martians

net.ipv4.conf.all.log_martians = 1

# Save and close the file (CTRL-o, ENTER, CTRL-x)

# Step 7. Install logwatch

# Logwatch is a log analysis program. It reads system logs and generates periodic reports based on user criteria.

sudo apt-get install logwatch -y

# Set it to run weekly or daily:

sudo mv /etc/cron.daily/00logwatch /etc/cron.weekly/

# Edit the file:

sudo nano /etc/cron.weekly/00logwatch

# And change the line to be:

/usr/sbin/logwatch --output mail --range 'between -7 days and -1 days'

# Step 8. Load sysctl changes

# Reload sysctl by running command:

sudo sysctl -p

# Step 9. Install rootkit Checker

# A rootkit is malware designed to provide privileged access to a computer while actively hiding its presence.

rkhunter scans for rootkits, backdoors and possible local exploits. 

chrootkit checks for known rootkits. 

# Install the tools:

sudo apt-get install rkhunter chkrootkit -y

# Edit rkhunter's config file:

sudo nano /etc/default/rkhunter

# and change these lines to be:

CRON_DAILY_RUN="true"

CRON_DB_UPDATE="true"

# Edit chrootkit's config file:

sudo nano /etc/chkrootkit.conf

# and change these lines to be:

RUN_DAILY="true"

RUN_DAILY_OPTS=""

# Run the checkers weekly:

sudo mv /etc/cron.weekly/rkhunter /etc/cron.weekly/rkhunter_update

sudo mv /etc/cron.daily/rkhunter /etc/cron.weekly/rkhunter_run

sudo mv /etc/cron.daily/chkrootkit /etc/cron.weekly/

# Step 10. Disable bad versions of SSL and TLS
