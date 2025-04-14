#!/usr/bin/perl


## Konstantendeklaration

$htmlfilenameneu="../abteilung/anschlag/html/emailneuok.htm";
$htmlfilenamedelete="../abteilung/anschlag/html/emaildeleteok.htm";
$htmlfilenamedeletefehler="../abteilung/anschlag/html/emaildeletenok.htm";
$emailliste="../abteilung/anschlag/data/email.dat";



## Einlese der Daten

if($ENV{'REQUEST_METHOD'} eq 'GET') { $getipt = $ENV{'QUERY_STRING'} }
else { read(STDIN, $getipt, $ENV{'CONTENT_LENGTH'}); }
#$getipt=~ tr/\+/ /;
@data=();
@data = split(/&/,$getipt);
foreach $i (0..$#data){
  ($name[$i],$value[$i])=split(/=/,$data[$i]);
  $name[$i]=~ s/%(..)/chr(hex($1))/ge;
  $value[$i]=~ s/%(..)/chr(hex($1))/ge;
  if ($name[$i] eq "formart") { $formart=$value[$i]; }
  if ($name[$i] eq "email") { $email=$value[$i]; }
}
if ($email eq "list") { &list(); }



## Data-String kreieren

$newdatastring = $email. "|";
foreach $i (0..$#name){
  if ($name[$i] eq "stufen") { $newdatastring = $newdatastring . $value[$i] . "|"; }
}
$newdatastring = $newdatastring . "\n";



## Im Datafile suchen, ob email schon vorhanden.
## Wenn ja loeschen/aender ansonsten anfuegen.

$gefunden = 0;
@DATAFILE=("");
@NEWDATAFILE=("");
open(DATAFILE,"<$emailliste") || die "Error opening file $emailliste";
while(<DATAFILE>) {
  @data= split(/\|/,$_);
  if ($data[0] ne $email) {
    push(@NEWDATAFILE,$_);
  }
  else {
    $gefunden = 1;
    if ($formart eq "delete") {}
    else {
      push(@NEWDATAFILE,$newdatastring);
    }
  }
}
close(DATAFILE);
if ( ($gefunden == 0) && ($formart eq "new") ) {
  push(@NEWDATAFILE,$newdatastring);
}


## Neues Datafile schreiben

open(DATAFILE,">$emailliste") || die "Error opening file $emailliste";
for(@NEWDATAFILE){
  print DATAFILE $_;
}
close(DATAFILE);



## HTML Ausgabe

print "Content-type: text/html\n\n";
if ($formart eq "new") {
  open(HTMLFILE, "<$htmlfilenameneu") || die "Error opening HTML-file $htmlfilenameneu";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
}
if ( ($gefunden == 1) && ($formart eq "delete") ) {
  open(HTMLFILE, "<$htmlfilenamedelete") || die "Error opening HTML-file $htmlfilenamedelete";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
}
if ( ($gefunden == 0) && ($formart eq "delete") ) {
  open(HTMLFILE, "<$htmlfilenamedeletefehler") || die "Error opening HTML-file $htmlfilenamedeletefehler";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
}


##
## listet alle Einträge auf
##
sub list{
  print "Content-type: text/plain\n\n";
  print "In der email.dat steht:\n\n";
  open(DATAFILE,"<$emailliste") || die "Error opening file $emailliste";
  for(<DATAFILE>){
    print "   " . $_;
  }
  close(DATAFILE);
  exit(0);
}

