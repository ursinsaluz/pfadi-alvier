#!/usr/bin/perl

use CGI qw/:all/;

######################################################
my $emailaddresse='m.gabathuler@schulebuchs.ch';
######################################################
print header;

print start_html(
        -title=>'Addressanderung schicken',
        -author=>'marco.graf@schweiz.org',
        -lang=>'de',
        -bgcolor=>'#DDDDDD',
        -text=>'#000000',
        -link=>'#0000FF',
        -vlink=>'#0000FF',
        -alink=>'#FF0000');

##
## Schick die emails
##
open(MAIL,"|/usr/lib/sendmail -t") || die;
#   Header
print MAIL "To: $emailaddresse\n";
print MAIL "From: \"" . param(T1) . "\" <" . (param(C4) ? param(T15) :param(T5)) . ">\n";
print MAIL "Subject: Adressaenderung\n";
#   Body
print MAIL "Name Vorname:               ". param(T1) . (param(C2) ? ("-> ".param(T11))."\n":"\n");
print MAIL "Strasse:                    ". param(T2) . (param(C3) ? ("-> ".param(T12))."\n":"\n");
print MAIL "PLZ/Ort:                    ". param(T3) . (param(C1) ? ("-> ".param(T13))."\n":"\n");
print MAIL "Telefon:                    ". param(T4) . (param(C6) ? ("-> ".param(T14))."\n":"\n");
print MAIL "e-mail:                     ". param(T5) . (param(C4) ? ("-> ".param(T15))."\n":"\n");
print MAIL "gesetzliche/r Vertreter/in: ". param(T6) . (param(C5) ? ("-> ".param(T16))."\n":"\n");
print MAIL "\nBemerkungen/andere Änderungen:\n". param(S1) ."\n";
close(MAIL);

print h1('Ihre &Auml;nderung wurde gesendet.');
print end_html;



