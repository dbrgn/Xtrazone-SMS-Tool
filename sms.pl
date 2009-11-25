#!/usr/bin/perl -w
################################################################################
# Xtrazone SMS tool v0.3 - Send an SMS via Swisscom Xtrazone
#
# Syntax: ./sms.pl 0123456789 message to be sent
#
# Author:	Danilo Bargen <gezuru@gmail.com>
# License:	CC by-nc-sa 3.0
#			(http://creativecommons.org/licenses/by-nc-sa/3.0/)
# Web:		http://blog.ich-wars-nicht.ch/xtrazone-sms-tool/
# Changes:
#	0.1		2009/09/06	Basic functionality (sending sms) as a Bash script
#	0.2		2009/09/07	Basic errorhandling, display of remaining SMS
#	0.3		2009/09/12	Rewritten the entire thing in Perl, added new features
# Required to run:
#	- Perl
# 	- Curl
# Todo:
#	- Phonebook
#	- Help option
#	- Accept message from stdin
################################################################################

# Edit these two lines
my $NUMBER = "1234567890";
my $PASSWORD = "password";

################################################################################

# Do not edit the following code unless you know what you're doing

use strict;
use warnings;
use POSIX;

my $cookiefile = "/tmp/xtrazone.cookie"; # Temporary cookie file
my $version = "0.3";

# Check whether curl is installed
if (!`which curl`)
{
	die "Error: Curl is not installed, or could not be found.\n";
}

if (!@ARGV) # No arguments
{
	die usage();
}
elsif (@ARGV < 2) # Only one argument
{
	die usage("No message defined.");
}
elsif ($ARGV[0] !~ m/[0-9]{10}/) # Argument 1 doesn't consist of 10 numbers
{
	die usage("Invalid cell phone number");
}

my $receiver = shift(@ARGV);
my $message = join(' ', @ARGV);

login();
send_sms();
remove_cookie();

################################################################################

# Subroutines (functions)


# How to use this script
sub usage {
	my $msg = "";
	if (@_)
	{
		$msg = "@_\n";
	}
	return $msg."Usage: sms NUMBER MESSAGE\nExample: sms 0123456789 Hello, this is my message!\n";
}

# Log in
sub login {
	# Curl login-request
	my $curlbody = `curl --cookie-jar $cookiefile --connect-timeout 10 --header 0 --location 1 --user-agent "Opera/9.23 (Windows NT 5.1; U; en)" --insecure --data "isiwebuserid=$NUMBER&isiwebpasswd=$PASSWORD&isiwebjavascript=No&isiwebappid=mobile&isiwebmethod=authenticate&isiweburi=/youth/sms_senden-de.aspx&isiwebargs=" https://www.swisscom-mobile.ch/youth/sms_senden-de.aspx?login 2>&1`;

	# Check whether login succeeded
	if ($curlbody =~ m/Swisscom Privatkunden - SMS senden/)
	{
		return 1;
	}
	elsif ($curlbody =~ m/eingegebene Passwort ist nicht korrekt./)
	{
		die "Login password not correct. Did you set it by editing this script?\n";
	}
	elsif ($curlbody =~ m/curl: \(28\) SSL connection timeout/)
	{
		die "SSL connection timeout. The server is currently not reachable.\n";
	}
	elsif ($curlbody =~ m/curl: \(7\) couldn't connect to host/)
	{
		die "SSL connection error. The server is currently not reachable.\n";
	}
	else
	{
		die "Unknown login error";
	}
}

# Send SMS
sub send_sms {
	# Check message length
	if (length($message) > 454)
	{
		die "Message too long (".length($message)." chars). Max characters: 454.\n";
	}
	if (length($message) > 134)
	{
		# Ask user whether he wants to sent a long SMS
		print "This is a long message, it will eat up ".ceil((length($message)+26)/160)." SMS credits. Do you really want that? [n/Y] ";

		my $confirmation = <STDIN>; # Get user input from stdin
		chomp($confirmation); # Remove trailing \n

		if ($confirmation and lc($confirmation) ne "y" and lc($confirmation) ne "yes")
		{
			die "Aborting.\n";
		}
	}
	
	# Curl send sms request
	my $curlbody = `curl --cookie $cookiefile --connect-timeout 10 --header 0 --location 1 --user-agent "Opera/9.23 (Windows NT 5.1; U; en)" --insecure --data "__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE_SCM=5&__VIEWSTATE=&CobYouthSMSSenden:txtMessage=$message&CobYouthSMSSenden:txtMessageDisabled= - sent by xtrazone.ch&CobYouthSMSSenden:txtNewReceiver=$receiver&CobYouthSMSSenden:btnSend=Senden&FooterControl:hidNavigationName=SMS senden&FooterControl_hidMailToFriendUrl=youth/sms_senden-de.aspx" https://www.swisscom-mobile.ch/youth/sms_senden-de.aspx 2>&1`;

	if ($curlbody =~ m/Deine Nachricht wurde gesendet./)
	{
		print "SMS sent successfully.\n";
		$curlbody =~ s/^.*<span id=\"CobYouthMMSSMSKonto_lblGuthaben\">([0-9]{1,3})<\/span>.*$/$1/s;
		print "Remaining SMS credit: $curlbody\n";
	}
	elsif ($curlbody =~ m/Dies ist keine gültige Handynummer/)
	{
		die "Invalid cell phone number (Example: 0791234567).\n";
	}
	else
	{
		die "Unknown error, could not send sms.";
	}
}

# Remove cookie file
sub remove_cookie {
	if (system("rm $cookiefile") != 0)
	{
		die "Error removing cookie file \"$cookiefile\".";
	}
}
