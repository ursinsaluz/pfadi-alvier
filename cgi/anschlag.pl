#!/usr/bin/perl


                                                                                          ## Constantendeclaration
$anschlagmessage="<CENTER><BLINK><FONT COLOR=\"#FF0000\">Achtung mehrere Anschl&auml\;ge<\/FONT><\/BLINK><\/CENTER>";

print "Content-type: text/html\n\n";
@HTMLFILE=("");
@getipt= split(/\?/, $ENV{'REQUEST_URI'});                                                ## Einlesen von Addresszeile
$stufe= $getipt[1];
$htmlfilename="../abteilung/anschlag/html/" . $stufe . ".htm";
open(HTMLFILE, "<$htmlfilename") || die "Error opening HTML-file $htmlfilename";          ## HTML-File öffnen
$laufvar=0;
@mitte=("");
@ende=("");
$anschlagsmessage=&message();
while(<HTMLFILE>){
  $_=~ s/<!--ACHTUNG_ANSCHLAG-->/$anschlagsmessage/g;
  if ($laufvar==0) {
    if ($_ =~ /<!--BEGIN_ANSCHLAG-->/) { $laufvar++; next;}
    else { print $_; }
    }
  if ($laufvar==1) {
    if ($_ =~ /<!--END_ANSCHLAG-->/) { $laufvar++; next;}
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
open(DATAFILE,"<../abteilung/anschlag/data/data.dat") || die "Error opening datafile";
while(<DATAFILE>) {
  if ($.==1) {
    @felder= split(/\|/,$_);
    next;
    }
  @data= split(/\|/,$_);
  if ( ($data[1] eq $stufe) && (&datumvergleich($data[0])) ) {
    for(@mitte) { &ersetzfelder($_);}
    }
  }
close(DATAFILE);
for(@ende) { print $_; }

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
      return $data[$i];
      }
    $i++;
    }
  return "<!--Feld nicht gefunden-->";
}

##
## Ersetzt die Felder im HTML-Code oder gibt den Code direkt aus
##
sub message{
  $testboolean=0;
  @DATAFILE=("");
  open(DATAFILE,"<../abteilung/anschlag/data/data.dat") || die "Error opening datafile";
  while(<DATAFILE>) {
    if ($.==1) { next; }
    @data= split(/\|/,$_);
    if ( ($data[1] eq $stufe) && (&datumvergleich($data[0])) ) {
      if ($testboolean==1) {
        close(DATAFILE);
        return $anschlagmessage;
      }
      else { $testboolean=1; }
      }
    }
  close(DATAFILE);
  return "";
}

##
## prueft ob das datum schon abgelaufen sind oder ob es schon angezeigt werden darf
##
sub datumvergleich{
  $datadate=$_[0];
  $datenow=localtime(time());                                                               ## Berechnung der localtime und
    $datenow =~ s/Jan/0/;                                                                   ## Umwandlung der Monate in
    $datenow =~ s/Feb/31/;                                                                  ## Tage
    $datenow =~ s/Mar/59/;                                                                  ## |
    $datenow =~ s/Apr/90/;                                                                  ## |
    $datenow =~ s/May/120/;                                                                 ## |
    $datenow =~ s/Jun/151/;                                                                 ## |
    $datenow =~ s/Jul/181/;                                                                 ## |
    $datenow =~ s/Aug/212/;                                                                 ## |
    $datenow =~ s/Sep/243/;                                                                 ## |
    $datenow =~ s/Oct/273/;                                                                 ## |
    $datenow =~ s/Nov/304/;                                                                 ## |
    $datenow =~ s/Dec/334/;                                                                 ## |
  @date = split(/ +/,$datenow);                                                             ## +
  $datenow = $date[4] * 365 + $date[1] + $date[2];                                          ## Berechnung Anzahl Tage

  @date = split(/\./,$datadate);                                                            ## Vergleichen der Daten
  $date[1] =~ s/\b01\b/0/;                                                                  ## |  Umwandlung der Monate in
  $date[1] =~ s/\b02\b/31/;                                                                 ## |  Tage
  $date[1] =~ s/\b03\b/59/;                                                                 ## |  |
  $date[1] =~ s/\b04\b/90/;                                                                 ## |  |
  $date[1] =~ s/\b05\b/120/;                                                                ## |  |
  $date[1] =~ s/\b06\b/151/;                                                                ## |  |
  $date[1] =~ s/\b07\b/181/;                                                                ## |  |
  $date[1] =~ s/\b08\b/212/;                                                                ## |  |
  $date[1] =~ s/\b09\b/243/;                                                                ## |  |
  $date[1] =~ s/\b10\b/273/;                                                                ## |  |
  $date[1] =~ s/\b11\b/304/;                                                                ## |  |
  $date[1] =~ s/\b12\b/334/;                                                                ## |  +
  $datadate=$date[2] * 365 + $date[1] + $date[0];                                           ## |  Berechnung Anzahl Tage
  if ($datenow <= $datadate){ return 1;}                                                    ## +
  return 0;
}

