#!/bin/bash

USERNAME="$1"

# 1. Convert SaurabhTripathi to "Saurabh Tripathi" (adds space before capital letters)
FULL_NAME=$(echo "$USERNAME" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g')

# 2. Convert SaurabhTripathi to "saurabhtripathi" (all lowercase for the login)
LOWER_USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]' )

if [ -z "$USERNAME" ]; then
    echo "Usage: $0 username"
    exit 1
fi

EMAIL="${USERNAME}@vehant.com"


echo "Creating fresh Thunderbird config for $USERNAME"


# Create directory
mkdir -p "$HOME/.thunderbird/vehant-profile"

cat > "$HOME/.thunderbird/profiles.ini" <<EOF
[Profile0]
Name=vehant-profile
IsRelative=1
Path=vehant-profile
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF

# Create prefs.js
cat > "$HOME/.thunderbird/vehant-profile/prefs.js" <<EOF
user_pref("mail.accountmanager.accounts", "account1,account2,account3");
user_pref("mail.accountmanager.defaultaccount", "account1");
user_pref("mail.smtpservers", "smtp1,smtp2,smtp3");
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);

/* ACCOUNT 1 - VEHANT COM */
user_pref("mail.account.account1.server", "server1");
user_pref("mail.account.account1.identities", "id1");
user_pref("mail.account.account1.smtpServer", "smtp1");

user_pref("mail.identity.id1.fullName", "$FULL_NAME");
user_pref("mail.identity.id1.useremail", "$EMAIL");
user_pref("mail.identity.id1.smtpServer", "smtp1");

user_pref("mail.server.server1.type", "pop3");
user_pref("mail.server.server1.hostname", "mail.vehant.com");
user_pref("mail.server.server1.userName", "$EMAIL");
user_pref("mail.server.server1.port", 995);
user_pref("mail.server.server1.socketType", 3);
user_pref("mail.server.server1.name", "Vehant");

/* Automation & Download Settings */
user_pref("mail.server.server1.login_at_startup", true);      # Check at startup
user_pref("mail.server.server1.check_new_mail", true);       # Check for new messages
user_pref("mail.server.server1.check_time", 10);             # Every 10 minutes
user_pref("mail.server.server1.download_on_biff", true);     # Automatically download new messages
user_pref("mail.server.server1.fetch_by_chunks", false);     # Ensure full download (not headers only)

/* Retention & Deletion Settings */
user_pref("mail.server.server1.leave_on_server", true);      # Leave messages on server
user_pref("mail.server.server1.num_days_to_leave_on_server", 4); # For at most 4 days
user_pref("mail.server.server1.delete_by_age_from_server", true); # Enable the "days" limit
user_pref("mail.server.server1.delete_from_server", true);   # Until I delete them


user_pref("mail.smtpserver.smtp1.hostname", "mail.vehant.com");
user_pref("mail.smtpserver.smtp1.port", 465);
user_pref("mail.smtpserver.smtp1.username", "$EMAIL");
user_pref("mail.smtpserver.smtp1.try_ssl", 3);

/* ACCOUNT 2 - VEHANT IN */
user_pref("mail.account.account2.server", "server2");
user_pref("mail.account.account2.identities", "id2");
user_pref("mail.account.account2.smtpServer", "smtp2");

user_pref("mail.identity.id2.fullName", "$FULL_NAME");
user_pref("mail.identity.id2.useremail", "$EMAIL");
user_pref("mail.identity.id2.smtpServer", "smtp2");

user_pref("mail.server.server2.type", "pop3");
user_pref("mail.server.server2.hostname", "mail.vehant.in");
user_pref("mail.server.server2.userName", "$LOWER_USERNAME");
user_pref("mail.server.server2.port", 995);
user_pref("mail.server.server2.socketType", 3);
user_pref("mail.server.server2.name", "PHANTOM");



/* Automation & Retention */
user_pref("mail.server.server2.login_at_startup", true);
user_pref("mail.server.server2.check_new_mail", true);
user_pref("mail.server.server2.check_time", 10);
user_pref("mail.server.server2.download_on_biff", true);
user_pref("mail.server.server2.fetch_by_chunks", false);
user_pref("mail.server.server2.leave_on_server", true);
user_pref("mail.server.server2.num_days_to_leave_on_server", 4);
user_pref("mail.server.server2.delete_by_age_from_server", true);
user_pref("mail.server.server2.delete_from_server", true);


user_pref("mail.smtpserver.smtp2.hostname", "mail.vehant.in");
user_pref("mail.smtpserver.smtp2.port", 25);
user_pref("mail.smtpserver.smtp2.username", "$FULL_NAME");
user_pref("mail.smtpserver.smtp2.authMethod", 0);

/* ACCOUNT 3 - KRITIKAL SECURE */

user_pref("mail.account.account3.server", "server3");
user_pref("mail.account.account3.identities", "id3");

user_pref("mail.identity.id3.fullName", "$FULL_NAME");
user_pref("mail.identity.id3.useremail", "$EMAIL");
user_pref("mail.identity.id3.smtpServer", "smtp3");

user_pref("mail.server.server3.type", "pop3");
user_pref("mail.server.server3.hostname", "mail.kritikalsecurescan.com");
user_pref("mail.server.server3.userName", "$EMAIL");
user_pref("mail.server.server3.port", 110);
user_pref("mail.server.server3.socketType", 0);
user_pref("mail.server.server3.name", "Kritikal");


/* Automation & Retention */
user_pref("mail.server.server3.login_at_startup", true);
user_pref("mail.server.server3.check_new_mail", true);
user_pref("mail.server.server3.check_time", 10);
user_pref("mail.server.server3.download_on_biff", true);
user_pref("mail.server.server3.fetch_by_chunks", false);
user_pref("mail.server.server3.leave_on_server", true);
user_pref("mail.server.server3.num_days_to_leave_on_server", 4);
user_pref("mail.server.server3.delete_by_age_from_server", true);
user_pref("mail.server.server3.delete_from_server", true);

user_pref("mail.smtpserver.smtp3.hostname", "mail.kritikalsecurescan.com");
user_pref("mail.smtpserver.smtp3.port", 465);
user_pref("mail.smtpserver.smtp3.username", "$EMAIL");
user_pref("mail.smtpserver.smtp3.try_ssl", 3);
user_pref("mail.smtpserver.smtp3.authMethod", 3);
EOF

echo "Done."

echo "Now start Thunderbird normally:"
echo "thunderbird"
