#!/usr/bin/perl


print "Content-type: text/html\n\n";

## Einlesen von Addresszeile
if($ENV{'REQUEST_METHOD'} eq 'GET') { $getipt = $ENV{'QUERY_STRING'} }
else { read(STDIN, $getipt, $ENV{'CONTENT_LENGTH'}); }
$getipt=~ tr/\+/ /;
$getipt=~ s/%(..)/chr(hex($1))/ge ;
@data = split(/&/,$getipt);
$i=0;

## Heraussuchen der URL
foreach $Feld (@data){
  ($name[$i],$value[$i])=split(/=/,$Feld);
  if($name[$i] eq "href") { $htmlfilename=$value[$i]; }
  $i++;
  }
$htmlfilename =~ s/http:\/\/www.alvier.ch\//..\/..\//gi;

## Ausgeben des HTML-Files
@HTMLFILE=("");
open(HTMLFILE,"<$htmlfilename") || die "Error opening HTML-file $htmlfilename";
while(<HTMLFILE>) { print $_; }
close(HTMLFILE);
