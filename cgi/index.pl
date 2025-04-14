#!/usr/bin/perl

$path="/home/alvier.ch/htdocs";
$root="/home/alvier.ch/htdocs";

## Einlesen von Addresszeile
$getipt = $ENV{'QUERY_STRING'};
$getipt =~ tr/\+/ /;
$getipt =~ s/%(..)/chr(hex($1))/ge ;
@paare = split(/&/,$getipt);
foreach $i (0..$#paare){
  ($name[$i],$value[$i])=split(/=/,$paare[$i]);
  $data{$name[$i]}=$value[$i];
}

if ($data{'path'} ne "") { $path=$data{'path'};} 
if (length($root)>length($path)) { $path=$root; }
## HTML-Header
print "Content-type: text/html\n\n";
print <<ENDHTML;
<HTML>
<HEAD>
    <META NAME="author" CONTENT="Marco Graf v/o Marabu">
    <TITLE>Pfadi Alvier Buchs : Upload</TITLE>
    <BASE TARGET="hauptframe">
</HEAD>
<BODY BGCOLOR="#DDDDDD" TEXT="#000000" LINK="#0000FF" VLINK="#0000FF" ALINK="#FF0000">

<FORM ACTION=index.cgi METHOD=POST>
ENDHTML
print "PATH: $path<BR>\n\n";


@dir = split(/\n/,`ls -al $path`);
@directorys=();
@files=();
foreach $line (@dir){
	$test=$line;
	unless($test !=~ /\b[^ ]{10} /sgi) { next; }
	if ( ($test =~ / \.\b/) || ($test =~ / \.\.\b/)) { next; }
	$test=$line;
	if ($line =~ /d[^ ]{9} +([^ ]+ +){7}([^ ]+)/){
		push(@directorys,$2);
	}
	$line=$test;
	if ($line =~ /-[^ ]{9} +([^ ]+ +){7}([^ ]+)/){
		push(@files,$2);
	}
}
sort(@directorys);
sort(@files);
foreach $directory (@directorys){
	print "<A HREF=\"index.pl?path=$path/$directory\">$directory/</A><BR>\n";
}
foreach $file (@files){
	print "<INPUT NAME=\"datei\" TYPE=CHECKBOX VALUE=\"$file\">$file<BR>\n";
}


print "</FORM>\n\n</BODY>\n</HTML>\n";

