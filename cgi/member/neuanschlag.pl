#!/usr/bin/perl


print "Content-type: text/html\n\n";

$datafilename="../../abteilung/anschlag/data/data.dat";
$emailfilename="../../abteilung/anschlag/data/email.dat";
$loginfilename="../../abteilung/anschlag/data/login.dat";
$notokfile="<../../abteilung/anschlag/html/notok.htm";
$okfile="<../../abteilung/anschlag/html/ok.htm";
$htmlfilename=$okfile;

## Logintest
if (&login()){

## Einlesen der geschickten Daten
if($ENV{'REQUEST_METHOD'} eq 'GET') { $Daten = $ENV{'QUERY_STRING'} }
else { read(STDIN, $Daten, $ENV{'CONTENT_LENGTH'}); }
$Daten=~ tr/\+/ /;
@Formularfelder = split(/&/, $Daten);
$i=0;
foreach $Feld (@Formularfelder)  
 {
  ($felder[$i], $value[$i]) = split(/=/, $Feld);   
  $i++;
 }
$anzfelder=$i+1;

foreach $Feld (@felder)  
 {
  $Feld=~ s/%(..)/chr(hex($1))/ge ;
  $Feld =~ s/&/&amp;/g;
  $Feld =~ s/</&lt;/g;
  $Feld =~ s/>/&gt;/g;
  $Feld =~ s/\|/&#124;/g;
  $Feld =~ s/ä/&auml\;/g;
  $Feld =~ s/ö/&ouml\;/g;
  $Feld =~ s/ü/&uuml\;/g;
  $Feld =~ s/Ä/&Auml\;/g;
  $Feld =~ s/Ö/&Ouml\;/g;
  $Feld =~ s/Ü/&Uuml\;/g;
  $Feld =~ s/[\n]/<BR>/g;
  $Feld =~ s/.<BR>/<BR>/g;
}

foreach $Feld (@value)  
 {
  $Feld=~ s/%(..)/chr(hex($1))/ge ;
  $Feld =~ s/&/&amp;/g;
  $Feld =~ s/</&lt;/g;
  $Feld =~ s/>/&gt;/g;
  $Feld =~ s/\|/&#124;/g;
  $Feld =~ s/ä/&auml\;/g;
  $Feld =~ s/ö/&ouml\;/g;
  $Feld =~ s/ü/&uuml\;/g;
  $Feld =~ s/Ä/&Auml\;/g;
  $Feld =~ s/Ö/&Ouml\;/g;
  $Feld =~ s/Ü/&Uuml\;/g;
  $Feld =~ s/[\n]/<BR>/g;
  $Feld =~ s/.<BR>/<BR>/g;
}

## user in die Daten einbeziehen
push(@felder,'user');
push(@value,$ENV{'REMOTE_USER'});

## Felder Datafiles suchen
@DATAFILE=("");
open(DATAFILE,"<../../abteilung/anschlag/data/data.dat") || die "Error opening datafile for read";
while(<DATAFILE>){
  @filefelder=split(/\|/,$_);
  last;
}
close(DATAFILE);

## Schreiben der Daten ins Datenfile
@DATAFILE=("");
open(DATAFILE,">>../../abteilung/anschlag/data/data.dat") || die "Error opening datafile for push";
foreach $feld (@filefelder) {
  $i=0;
  for(@felder){
    if ($feld eq $_) {
      print DATAFILE "$value[$i]\|";
      last;
      }
    else {
      if($i >= $anzfelder) {
        print DATAFILE "\|";
        }
      } 
    $i++;
    }
  }
print DATAFILE "\n";
close(DATAFILE);

## "OK"- oder "NICHT-OK"-HTMLfile ausgeben
@ANTWORTFILE=("");
open(ANTWORTFILE,$htmlfilename) || die "Error opening HTML-file $htmlfilename";
while(<ANTWORTFILE>) {
  if ($_=~ /<!--test-->/) {
    ## Anschlag anzeigen
     ## HTML-File öffnen und lesen des mittleren Teil
    @HTMLFILE=("");
    $stufe= $value[1];
    $htmlfilename="../../abteilung/anschlag/html/" . $stufe . ".htm";
    open(HTMLFILE, "<$htmlfilename") || die "Error opening HTML-file $htmlfilename";
    $laufvar=0;
    @mitte=("");
    while(<HTMLFILE>){
      if ($laufvar==0) {
        if ($_ =~ /<!--BEGIN_ANSCHLAG-->/) { $laufvar++; next;}
        else { next; }
        }
      if ($laufvar==1) {
        if ($_ =~ /<!--END_ANSCHLAG-->/) { $laufvar++; next;}
        else { 
          push(@mitte,$_);
          }
        }
      if ($laufvar==2) {
        last;
        }
      if (($laufvar!=0)&&($laufvar!=1)&&($laufvar!=2)) { die "Error occured in \$laufvar";}
    }
    close(HTMLFILE);
    for(@mitte) { &ersetzfelder($_);}
    }
    ## Ende der Anschlag-Anzeige
  else { print $_; }
  }
close(ANTWORTFILE);


##
## Alte Anschlaege loeschen
$datenow=localtime(time());
  $datenow =~ s/Jan/01/;
  $datenow =~ s/Feb/02/;
  $datenow =~ s/Mar/03/;
  $datenow =~ s/Apr/04/;
  $datenow =~ s/May/05/;
  $datenow =~ s/Jun/06/;
  $datenow =~ s/Jul/07/;
  $datenow =~ s/Aug/08/;
  $datenow =~ s/Sep/09/;
  $datenow =~ s/Oct/10/;
  $datenow =~ s/Nov/11/;
  $datenow =~ s/Dec/12/;
@date = split(/ +/,$datenow);
$Localjahr = $date[4];
$Localmonat = $date[1];
$Localtag =  $date[2];
@DATAFILE=("");
open(DATAFILE,"<../../abteilung/anschlag/data/data.dat") || die "Error opening datafile for read";
@data=("");
while(<DATAFILE>){
  push(@data,$_);
}
close(DATAFILE);
@DATAFILE=("");
open(DATAFILE,">../../abteilung/anschlag/data/data.dat") || die "Error opening datafile for write";
print DATAFILE $data[1];
foreach $Linenum (2..$#data){
  $Line=$data[$Linenum];
  @Element=split(/\|/,$Line);
  $datum=$Element[0];
  ($Tag,$Monat,$Jahr)=split(/\./,$datum);
  if ($Jahr>$Localjahr) { print DATAFILE $Line; }
  elsif( ($Jahr==$Localjahr) && ($Monat>$Localmonat) ) { print DATAFILE $Line; }
  elsif( ($Jahr==$Localjahr) && ($Monat==$Localmonat) && ($Tag>=$Localtag) ) { print DATAFILE $Line; }
  else { print "\n"; }
}
close(DATAFILE);

&ordne();

&logout();


%Neuedaten=();
for $i(0..$#felder){
  $temp = $value[$i];
  $temp =~ s/\\/\\\\/g;
  $temp =~ s/"/\"/g;
  $temp =~ s/&lt;/</g;
  $temp =~ s/&gt;/>/g;
  $temp =~ s/&#124;/|/g;
  $temp =~ s/&auml\;/ä/g;
  $temp =~ s/&ouml\;/ö/g;
  $temp =~ s/&uuml\;/ü/g;
  $temp =~ s/&Auml\;/Ä/g;
  $temp =~ s/&Ouml\;/Ö/g;
  $temp =~ s/&Uuml\;/Ü/g;
  $temp =~ s/&amp\;/&/g;
  $temp =~ s/<BR>/\n            /g;
  $Neuedaten{$felder[$i]}=$temp;
}
&email(\%Neuedaten);

}



##
## Ordnen der Daten in der Datei nach Datum
##
sub ordne{
  ## Einlesen der Datei
  @data=();
  @DATAFILE=();
  open(DATAFILE,"<$datafilename") || die "Error opening datafile for read";
  while(<DATAFILE>){
    if ($.!=1){ push(@data,$_); }
    else { $firstline=$_; }
  }
  close(DATAFILE);

  ## ordnen der Daten
  foreach (@data){
    for ($i=0;$i < $#data;$i++){
      ($vergleicha,@sonst)=split(/\|/,$data[$i]);
      ($vergleichb,@sonst)=split(/\|/,$data[$i+1]);
      if (&kleinerals($vergleichb,$vergleicha)) {
        $temp=$data[$i+1];
        $data[$i+1]=$data[$i];
        $data[$i]=$temp;
      }
    }
  }

  ## Schreiben der Datei
  @DATAFILE=();
  open(DATAFILE,">$datafilename") || die "Error opening datafile for write";
  print DATAFILE $firstline;
  foreach $line (@data){ print DATAFILE $line; }
  close(DATAFILE);
}

##
## prueft ob die daten der untergruppe $name schon abgelaufen sind
##
sub kleinerals{
  
  @date = split(/\./,$_[0]);                                                           ## Spliten des Datums
  $date[1] =~ s/\b01\b/0/;                                                             ## Umwandlung der Monate in
  $date[1] =~ s/\b02\b/31/;                                                            ## Tage
  $date[1] =~ s/\b03\b/59/;                                                            ## |
  $date[1] =~ s/\b04\b/90/;                                                            ## |
  $date[1] =~ s/\b05\b/120/;                                                           ## |
  $date[1] =~ s/\b06\b/151/;                                                           ## |
  $date[1] =~ s/\b07\b/181/;                                                           ## |
  $date[1] =~ s/\b08\b/212/;                                                           ## |
  $date[1] =~ s/\b09\b/243/;                                                           ## |
  $date[1] =~ s/\b10\b/273/;                                                           ## |
  $date[1] =~ s/\b11\b/304/;                                                           ## |
  $date[1] =~ s/\b12\b/334/;                                                           ## +
  $datadate1=$date[2] * 365 + $date[1] + $date[0];                                     ## Berechnung Anzahl Tage

  @date = split(/\./,$_[1]);                                                           ## Spliten des Datums
  $date[1] =~ s/\b01\b/0/;                                                             ## Umwandlung der Monate in
  $date[1] =~ s/\b02\b/31/;                                                            ## Tage
  $date[1] =~ s/\b03\b/59/;                                                            ## |
  $date[1] =~ s/\b04\b/90/;                                                            ## |
  $date[1] =~ s/\b05\b/120/;                                                           ## |
  $date[1] =~ s/\b06\b/151/;                                                           ## |
  $date[1] =~ s/\b07\b/181/;                                                           ## |
  $date[1] =~ s/\b08\b/212/;                                                           ## |
  $date[1] =~ s/\b09\b/243/;                                                           ## |
  $date[1] =~ s/\b10\b/273/;                                                           ## |
  $date[1] =~ s/\b11\b/304/;                                                           ## |
  $date[1] =~ s/\b12\b/334/;                                                           ## +
  $datadate2=$date[2] * 365 + $date[1] + $date[0];                                     ## Berechnung Anzahl Tage
  if ($datadate1 < $datadate2){ return 1; }                                               ## Vergleichen
  else { return 0; }
}

##
## Ersetzt die Felder im HTML-Code oder gibt den Code direkt aus
##
sub ersetzfelder{
  $htmlcode=$_[0];
  if ($htmlcode=~ /\$/) {
    @htmlfelder=split(/\$/,$htmlcode);
    print $htmlfelder[0];
    print &heraussuchen($htmlfelder[1]);
    &ersetzfelder($htmlfelder[2]);
    }
  else { print $htmlcode; }
}

##
## sucht das angegebene Feld in den Daten
##
sub heraussuchen{
  $htmlfeld=$_[0];
  $i=0;
  for(@felder) {
    if($htmlfeld eq $_){
      return $value[$i];
      }
    $i++;
    }
  return "<--Feld nicht gefunden-->";
}


##
## traegt den user in das loginfile ein
##
sub login{
  open(LOGINFILE,"<$loginfilename") || die "Error opening Login-file $loginfilename in login";
  while(<LOGINFILE>){ $logdata=$_; last;}
  close(LOGINFILE);
  if ($logdata eq "") {
    open(LOGINFILE,">$loginfilename") || die "Error opening Login-file $loginfilename in login";
    $zeit=time();
    print LOGINFILE "$zeit\|$ENV{'REMOTE_USER'}\|\n";
    close(LOGINFILE);
    }
  else {
    ($zeit,$user)=split(/\|/,$_);
    $zeit = time() - $zeit;
    $min = int($zeit / 60);
    if (($min>15) || ($user eq $ENV{'REMOTE_USER'})){
      open(LOGINFILE,">$loginfilename") || die "Error opening Login-file $loginfilename in login";
      $zeit=time();
      print LOGINFILE "$zeit\|$ENV{'REMOTE_USER'}\|\n";
      close(LOGINFILE);
    }
    else {
      $sek = ( (int($zeit)) - (60 * $min) );
      $restmin = 16 - $min;
      print "<html>\n";
      print "<head>\n";
      print "<titel>User loged on</titel>\n";
      print "<\head>\n";
      print "<body bgcolor=#DDDDDD>\n";
      print "<BR>\n<BR>\n<BR>\n<center>\n<FONT SIZE=+2>$user ist seit $min Minuten und $sek Sekunden eingelogt.<BR>\nVersuchen Sie es bitte in $restmin Minuten noch einmal.</FONT><BR>\n";
      print "</body>\n";
      print "</html>\n";
      return 0;
      }
    }
  return 1;
}


##
## loescht den user aus dem loginfile
##
sub logout{
  open(LOGINFILE,"<$loginfilename") || die "Error opening Login-file $loginfilename in login";
  while(<LOGINFILE>){ $logdata=$_; last;}
  close(LOGINFILE);
  if ($logdata =~ /$ENV{'REMOTE_USER'}/) {
    open(LOGINFILE,">$loginfilename") || die "Error opening Login-file $loginfilename in login";
    print LOGINFILE "\n";
    close(LOGINFILE);
    }
  else { die "user $ENV{'REMOTE_USER'} was kicked out while an operation!!!"; }
  return 0;
}


##
## Schick die emails
##
sub email{
  %Emaildaten=%{$_[0]};

  @EMAILFILE=("");
  open(EMAILFILE,"$emailfilename") || die "Error opening $emailfilename";
  while(<EMAILFILE>) {
    ($emailaddresse,@stufen)= split(/\|/,$_);
    foreach $stufe (@stufen){
      if($stufe eq $Emaildaten{'stufe'}){
        open(MAIL,"|/usr/lib/sendmail -t") || die;
        print MAIL "To: $emailaddresse\n";
        print MAIL "From: \"Pfadi AL4\" <leiter\@alvier.ch>\n";
        print MAIL "Subject: Anschlag\n";
        $temp = $Emaildaten{'stufe'};
        $temp =~ s/stufe1/1. Stufe/g;
        $temp =~ s/woelf/Wölf/g;
        $temp =~ s/bienli/Bienli/g;
        $temp =~ s/stufe2/2. Stufe/g;
        $temp =~ s/pfader/Pfader/g;
        $temp =~ s/pfaderinnen/Pfaderinnen/g;
        $temp =~ s/rover/Rover/g;
        $temp =~ s/raider/Raider/g;
        $temp =~ s/abteilung/Abteilung/g;
        print MAIL "$temp\n\n";
        print MAIL "\t$Emaildaten{'titel'}\n\n\n";
        print MAIL "Datum:      $Emaildaten{'datum'}\n";
        print MAIL "Antreten:   $Emaildaten{'anzeit'} $Emaildaten{'anort'}\n";
        print MAIL "Abtreten:   $Emaildaten{'abzeit'} $Emaildaten{'abort'}\n";
        print MAIL "Tenu:       $Emaildaten{'tenu'}\n";
        print MAIL "Mitnehmen:  $Emaildaten{'mit'}\n";
        print MAIL "Besonderes: $Emaildaten{'bes'}\n";
        print MAIL "\n";
        print MAIL "\t\tAllzeit Bereit\n";
        print MAIL "\t\t$Emaildaten{'sign'}\n";
        print MAIL "--\n";
        print MAIL "Um ihre email von dieser List zu löschen, benutzen sie diese URL:\n";
        print MAIL 'http://www.alvier.ch/cgi/anschlagemail.pl?email='.$emailaddresse.'&formart=delete'."\n";
        print MAIL "\n";
        print MAIL "Um ihre Einträge zu ändern, benutzen sie diese URL:\n";
        $stufenstring = join('=1&',@stufen);
        $stufenstring =~ s/\n//g;
        print MAIL 'http://www.alvier.ch/cgi/editanschlagemail.pl?'.$stufenstring.'email='.$emailaddresse."\n";
        close(MAIL);
      }
    }
  }
  close(DATAFILE);
}
