#!/usr/bin/perl


print "Content-type: text/html\n\n";
## Setzen von Variabeln
$datafilename="../../abteilung/anschlag/data/data.dat";
$emailfilename="../../abteilung/anschlag/data/email.dat";
$loginfilename="../../abteilung/anschlag/data/login.dat";
$editfilename="../../abteilung/anschlag/form/edit.htm";
$remakefilename="../../abteilung/anschlag/form/remake.htm";
$redonefilename="../../abteilung/anschlag/form/redone.htm";
$deletefilename="../../abteilung/anschlag/form/delete.htm";
$anschlagfilename="../../abteilung/anschlag/index.htm";

## Einlesen von Addresszeile
if($ENV{'REQUEST_METHOD'} eq 'GET') { $getipt = $ENV{'QUERY_STRING'} }
else { read(STDIN, $getipt, $ENV{'CONTENT_LENGTH'}); }
$getipt=~ tr/\+/ /;

if ($getipt =~ /\bdelete/){
  if (&refreshlogin()){ &delete(); }
  }

elsif ($getipt =~ /\bedit/){
  if  (&refreshlogin()){ &edit(); }
  }

elsif ($getipt =~ /\bremake/){
  if  (&refreshlogin()){ &remake(); }
  }

elsif ($getipt =~ /\blogout/){
  if  (&refreshlogin()){ &hreflogout(); }
  }

elsif(&login()) { &list(); }

&ordne();



##
## DELETE
##
sub delete{
  $getipt=~ s/%(..)/chr(hex($1))/ge ;
  @DATAFILE=("");
  open(DATAFILE,"<$datafilename") || die "Error opening Data-file $datafilename";
  @getipt = split(/&/,$getipt);
  ($noef,$idnum) = split(/=/,$getipt[0]);
  @data=("");
  while(<DATAFILE>){
    if ($.!=$idnum){ push(@data,$_); }
    }
  close(DATAFILE);
  open(DATAFILE,">$datafilename") || die "Error opening Data-file $datafilename";
  for (@data){ print DATAFILE $_; }
  close(DATAFILE);
  @HTMLFILE=("");
  open(HTMLFILE,"<$deletefilename") || die "Error opening Remake-file $deletefilename";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
  &logout();
}


##
## EDIT
##
sub edit{
  $getipt=~ s/%(..)/chr(hex($1))/ge ;
  @DATAFILE=("");
  open(DATAFILE,"<$datafilename") || die "Error opening Data-file $datafilename";
  @getipt = split(/&/,$getipt);
  ($noef,$idnum) = split(/=/,$getipt[0]);
  @data=("");
  while(<DATAFILE>){
    if ($.==1){ @felder=split(/\|/,$_); }
    if ($.==$idnum){ @data=split(/\|/,$_); }
    }
  close(DATAFILE);
  push(@felder,"idnum");
  push(@data,$idnum);
  foreach $Feld (@data){
    $Feld =~ s/\\/\\\\/g;
    $Feld =~ s/"/\\"/g;
    $Feld =~ s/&lt;/</g;
    $Feld =~ s/&gt;/>/g;
    $Feld =~ s/&#124;/\|/g;
    $Feld =~ s/&auml\;/ä/g;
    $Feld =~ s/&ouml\;/ö/g;
    $Feld =~ s/&uuml\;/ü/g;
    $Feld =~ s/&Auml\;/Ä/g;
    $Feld =~ s/&Ouml\;/Ö/g;
    $Feld =~ s/&Uuml\;/Ü/g;
    $Feld =~ s/&amp\;/&/g;
    $Feld =~ s/<BR>/\\n/g;
    }
  @HTMLFILE=("");
  open(HTMLFILE,"<$remakefilename") || die "Error opening Remake-file $remakefilename";
  while(<HTMLFILE>) { &ersetzfelder($_); }
  close(HTMLFILE);
}


##
## REMAKE
##
sub remake{
  @data = split(/&/,$getipt);
  $i=0;
  foreach $Feld (@data){
    ($name[$i],$value[$i])=split(/=/,$Feld);
    $i++;
    }
  foreach $Feld (@name)  
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

  push(@name,'user');
  push(@value,$ENV{'REMOTE_USER'});
  $i=0;
  for(@name){
    if ($name[$i] =~ /remake/) {
      $idnum = $value[$i];
      last;
      $i++;
      }
    }
  @DATAFILE=("");
  open(DATAFILE,"<$datafilename") || die "Error opening Data-file $datafilename";
  @data=("");
  @felder=("");
  while(<DATAFILE>){
    if($.==1) { @felder=split(/\|/,$_); }
    if ($.!=$idnum){ push(@data,$_); }
    }
  $datastring="";
  $anzfelder = $#felder - 1;
  foreach $y (0..$anzfelder){
    foreach $i (0..$#name){
      if ($felder[$y] eq $name[$i]) {
        $datastring = $datastring . $value[$i];
        last;
        }
      $i++;
      }
    $datastring = $datastring. "\|";
    }
  open(DATAFILE,">$datafilename") || die "Error opening Data-file $datafilename";
  $i=0;
  for(@data){
    print DATAFILE $_;
    if ($i == ($idnum - 1)) { print DATAFILE "$datastring\n"; }
    $i++;
    }
  close(DATAFILE);
  @HTMLFILE=("");
  open(HTMLFILE,"<$redonefilename") || die "Error opening Remake-file $redonefilename";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
  &logout();

  %Neuedaten=();
  for $i(0..$#name){
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
    $Neuedaten{$name[$i]}=$temp;
  }
  &email(\%Neuedaten);
}


##
## HREFLOGOUT
##
sub hreflogout{
  $getipt=~ s/%(..)/chr(hex($1))/ge ;
#  &logout();
  @HTMLFILE=("");
  open(HTMLFILE,"<$anschlagfilename") || die "Error opening Remake-file $anschlagfilename";
  while(<HTMLFILE>) { print $_; }
  close(HTMLFILE);
}


##
## LIST
##
sub list{
  $getipt=~ s/%(..)/chr(hex($1))/ge ;
  @HTMLFILE=("");
  open(HTMLFILE, "<$editfilename") || die "Error opening HTML-file $editfilename";
  $laufvar=0;
  @mitte=("");
  @ende=("");
  while(<HTMLFILE>){
    if ($laufvar==0) {
      if ($_ =~ /<!--BEGIN_LIST-->/) { $laufvar++; next;}
      else { print $_; }
      }
    if ($laufvar==1) {
      if ($_ =~ /<!--END_LIST-->/) { $laufvar++; next;}
      else { 
        push(@mitte,$_);
        }
      }
    if ($laufvar==2) {
      push(@ende,$_);
      }
    if (($laufvar!=0)&&($laufvar!=1)&&($laufvar!=2)) { die "Error occured in \$laufvar";}
  }
  close(HTMLFILE);

  @DATAFILE=("");
  open(DATAFILE,"<$datafilename") || die "Error opening datafile $datafilename";
  while(<DATAFILE>) {
    if ($.==1) {
      @felder= split(/\|/,$_);
      push(@felder,"idnum");
      next;
      }
    @data= split(/\|/,$_);
    push(@data,$.);
    for(@mitte) { &ersetzfelder($_);}
    }
  close(DATAFILE);
  for(@ende) { print $_; }
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
  return 0;
}


##
## sucht das angegebene Feld in den Daten
##
sub heraussuchen{
  $htmlfeld=$_[0];
  $i=0;
  for(@felder) {
    if($htmlfeld eq $_){
      return $data[$i];
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
## setzt die loginzeit wieder auf 0
##
sub refreshlogin{
  open(LOGINFILE,"<$loginfilename") || die "Error opening Login-file $loginfilename in login";
  while(<LOGINFILE>){ $logdata=$_; last;}
  close(LOGINFILE);
  if ($logdata =~ /$ENV{'REMOTE_USER'}/) {
    open(LOGINFILE,">$loginfilename") || die "Error opening Login-file $loginfilename in login";
    print LOGINFILE "time()\|$ENV{'REMOTE_USER'}\|\n";
    close(LOGINFILE);
    return 1;
    }
  else {
    print "<html>\n";
    print "<head>\n";
    print "<titel>User kicked out</titel>\n";
    print "<\head>\n";
    print "<body bgcolor=#DDDDDD>\n";
    print "<BR>\n<BR>\n<BR>\n<center>\n<FONT SIZE=+2>Sie wurden von einem anderen User rausgeschmissen, weil Sie zulange eingelogt waren.</FONT><BR>\n";
    print "</body>\n";
    print "</html>\n";
    return 0;
    }
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
        $temp =~ s/biber/Biber/g;
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
        close(MAIL);
      }
    }
  }
  close(DATAFILE);
}
