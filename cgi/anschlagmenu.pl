#!/usr/bin/perl


print "Content-type: text/html\n\n";
@HTMLFILE=("");
@getipt= split(/\?/, $ENV{'REQUEST_URI'});                                                ## Einlesen von Addresszeile
open(HTMLFILE, "<$getipt[1]") || die "Error opening HTML-file $getipt[1]";                ## HTML-File öffnen
$angezeigt=0;
while(<HTMLFILE>){                                                                        ## HTML-File einlesen
  if($_=~ /\$/){                                                                     ## sobald ein '$' gefunden wird:
    @namesplit=split(/\$/,$_);
    $name=$namesplit[1];
    if (&anzeigen($name)) {                                                               ## wenn nicht abgelaufen das menubild anzeigen
      print "<A HREF=\"http://$ENV{'SERVER_NAME'}/cgi/anschlag.pl?$name\" TARGET=\"hauptframe_anschlag\">";
      print "<IMG SRC=\"http://$ENV{'SERVER_NAME'}/abteilung/anschlag/bilder/", $name ,"menu.gif\" border=0 alt=\"$name\">";
      print "</A>\n";
      $angezeigt++;
      }
    }
  else { print $_; }                                                                      ## wenn kein '$' dann Zeichen schreiben
  }
close(HTMLFILE);
if ($angezeigt==0){ print "Es ist leider noch kein Anschlag f\&uuml\;r die n\&auml\;chsten 6 Tage im Internet vorhanden<BR>\n"; }

##
## prueft ob die daten der untergruppe $name schon abgelaufen sind
##
sub anzeigen(){
  $feldname=$_[0];
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

  @DATAFILE=("");
  open(DATAFILE,"<../abteilung/anschlag/data/data.dat") || die "Error opening datafile";
  while(<DATAFILE>){                                                                        ## Durchsuchen des data-files
    @data = split(/\|/,$_);                                                                 ## Nach der Stufe $feldname
    if ($data[1] eq $feldname){                                                             ##
      @date = split(/\./,$data[0]);                                                         ## Vergleichen der Daten
       $date[1] =~ s/\b01\b/0/;                                                             ## |  Umwandlung der Monate in
       $date[1] =~ s/\b02\b/31/;                                                            ## |  Tage
       $date[1] =~ s/\b03\b/59/;                                                            ## |  |
       $date[1] =~ s/\b04\b/90/;                                                            ## |  |
       $date[1] =~ s/\b05\b/120/;                                                           ## |  |
       $date[1] =~ s/\b06\b/151/;                                                           ## |  |
       $date[1] =~ s/\b07\b/181/;                                                           ## |  |
       $date[1] =~ s/\b08\b/212/;                                                           ## |  |
       $date[1] =~ s/\b09\b/243/;                                                           ## |  |
       $date[1] =~ s/\b10\b/273/;                                                           ## |  |
       $date[1] =~ s/\b11\b/304/;                                                           ## |  |
       $date[1] =~ s/\b12\b/334/;                                                           ## |  +
       $datadate=$date[2] * 365 + $date[1] + $date[0];                                      ## |  Berechnung Anzahl Tage
      if ($datenow <= $datadate){                                                           ## |
        close(DATAFILE);                                                                    ## |
        return 1;                                                                           ## |
        }                                                                                   ## +
      }
    }
  close(DATAFILE);
  return 0;
}
