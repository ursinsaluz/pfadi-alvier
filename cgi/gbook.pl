#!/usr/bin/perl


$datafilename="../abteilung/gaestebuch/data/data.dat";
$notokfilename="../abteilung/gaestebuch/gbooknotok.html";
$okfilename="../abteilung/gaestebuch/gbookok.html";


## Einlesen der geschickten Daten und umwandeln spezieller Zeichen
if($ENV{'REQUEST_METHOD'} eq 'GET') { $Daten = $ENV{'QUERY_STRING'} }
else { read(STDIN, $Daten, $ENV{'CONTENT_LENGTH'}); }
$Daten=~ tr/\+/ /;
@Formularfelder = split(/&/, $Daten);
@felder=();
@value=();
foreach $i (0..$#Formularfelder) {
	($felder[$i], $value[$i]) = split(/=/, $Formularfelder[$i]);   
}
push(@felder,"timedate");
push(@value, localtime(time()) . " " );
foreach $Feld (@felder) {
	$Feld=~ s/%(..)/chr(hex($1))/ge ;
	$Feld =~ s/&/&amp;/g;
	$Feld =~ s/</&lt;/g;
	$Feld =~ s/>/&gt;/g;
	$Feld =~ s/\|/&#124;/g;
	$Feld =~ s/„/&auml\;/g;
	$Feld =~ s/÷/&ouml\;/g;
	$Feld =~ s/’/&uuml\;/g;
	$Feld =~ s/ý/&Auml\;/g;
	$Feld =~ s/Ù/&Ouml\;/g;
	$Feld =~ s/›/&Uuml\;/g;
	$Feld =~ s/[\n]/<BR>/g;
	$Feld =~ s/.<BR>/<BR>/g;
}
foreach $Feld (@value) {
	$Feld=~ s/%(..)/chr(hex($1))/ge ;
	$Feld =~ s/&/&amp;/g;
	$Feld =~ s/</&lt;/g;
	$Feld =~ s/>/&gt;/g;
	$Feld =~ s/\|/&#124;/g;
	$Feld =~ s/„/&auml\;/g;
	$Feld =~ s/÷/&ouml\;/g;
	$Feld =~ s/’/&uuml\;/g;
	$Feld =~ s/ý/&Auml\;/g;
	$Feld =~ s/Ù/&Ouml\;/g;
	$Feld =~ s/›/&Uuml\;/g;
	$Feld =~ s/[\n]/<BR>/g;
	$Feld =~ s/.<BR>/<BR>/g;
}

## Die erforderlichen Daten kontrollieren
@requireds=();
foreach $i (0..$#felder){
	if ($felder[$i] eq "required") {
		@requireds=split(/\,/,$value[$i]);
	}
}
foreach $required (@requireds){
	$found=0;
	foreach $i (0..$#felder){
		if ($felder[$i] eq $required){
			$found=1;
			if ($value[$i] eq "") { &end($notokfilename); }
		}
	}
	if ($found == 0) { &end($notokfilename); }
}

## Homepage-Feld filtern
foreach $i (0..$#felder){
	if ($felder[$i] eq "homepage"){
		if ($value[$i] eq "http://") { $value[$i]=""; }
		break;
	}
}

## Felder des Datafiles suchen
@filedata=();
$lines=0;
@DATAFILE=("");
open(DATAFILE,"<$datafilename") || die "Error opening file $datafilename";
while(<DATAFILE>){
	if ($. == 1){
		$anzeintraege = $_;
		$anzeintraege =~ s/([0-9]*)/$1/g ;
		next;
	}
	if ($. == 2) {
		$stringfilefelder=$_;
		@filefelder=split(/\|/,$_);
		pop(@filefelder);
		next;
	}
	push(@filedata,$_);
	$lines=$lines+1;
}
close(DATAFILE);

## Vorbereiten des Neuen Eintrags
$neueintrag="";
foreach $filefeld (@filefelder) {
	foreach $i (0..$#felder) {
		if ($filefeld eq $felder[$i]) {
			$value[$i] =~ s/\@/\\\@/g;
			$neueintrag=$neueintrag . "$value[$i]\|";
			last;
		}
		else{
			if ($i == $#felder){ $neueintrag = $neueintrag . "\|"; }
		}
	}
}
$neueintrag =~ s/\\\@/\@/g;
$neueintrag=$neueintrag . "\n";

## Schreiben der Daten ins Datenfile
@DATAFILE=("");
open(DATAFILE,">$datafilename") || die "Error opening file $datafilename";
print DATAFILE ($anzeintraege+1) . "\n";
print DATAFILE $stringfilefelder;
print DATAFILE $neueintrag;
foreach $filedataline (@filedata) {
	print DATAFILE $filedataline;
}
close(DATAFILE);

## ENDE
&end($okfilename);



##
## Unterprogramme:
##


##
## Am Ende "OK"- oder "NICHT-OK"-HTMLfile ausgeben
##
sub end {
	$htmlfilename=$_[0];
	print "Content-type: text/html\n\n";
	@ANTWORTFILE=("");
	open(ANTWORTFILE,$htmlfilename) || die "Error opening HTML-file $htmlfilename";
	while(<ANTWORTFILE>) {
		print $_;
	}
	close(ANTWORTFILE);
	exit(0);
}


##
## Ersetzt die Felder im HTML-Code oder gibt den Code direkt aus
##
sub ersetzfelder {
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
sub heraussuchen {
  $htmlfeld=$_[0];
  $i=0;
  for(@felder) {
    if($htmlfeld eq $_) {
      return $value[$i];
    }
    $i++;
  }
  return "<--Feld nicht gefunden-->";
}

