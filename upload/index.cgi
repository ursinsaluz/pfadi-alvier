#!/usr/bin/perl

$path="";
$root="";

print "Content-type: text/html\n\n";

## Einlesen von Addresszeile
$getipt = $ENV{'QUERY_STRING'};
$getipt =~ tr/\+/ /;
$getipt =~ s/%(..)/chr(hex($1))/ge ;
@paare = split(/&/,$getipt);
foreach $i (0..$#paare){
	($name[$i],$value[$i])=split(/=/,$paare[$i]);
	$data{$name[$i]}=$value[$i];
}
if($ENV{'REQUEST_METHOD'} eq 'POST') {
	read(STDIN, $getipt, $ENV{'CONTENT_LENGTH'});
#	print "<pre>$getipt</pre><BR>\n";
	@getiptes=split(/[\-]{29}[0-9]*/,$getipt);
	($trash,@getiptes,$trash)=@getiptes;
	foreach $Feld (@getiptes){
		$Feld =~ s/\b.*Content-Disposition: form-data\; name="([^"]*)"[\; ="a-z]*([^"\s])*"*[\s]{2}//s;  #
		$Feldname=$1;
		$data{$Feldname} = $Feld;
		if ($Feldname eq "file") { $data{'filename'}=$2; }
		else {
			$data{$Feldname} =~ s/\s//sg;
			if ($Feldname eq "datei") { push(@dateien,$data{'datei'}); }
		}
	}
}

for(@dateien){ print "$_\n";}
if ($ENV{'REMOTE_USER'} eq "root") { $root=""; }
elsif ($ENV{'REMOTE_USER'} eq "test") { $root="upload/test"; }
elsif ($ENV{'REMOTE_USER'} eq "satansbroota") { $root="raider"; }
elsif ($ENV{'REMOTE_USER'} eq "jeeminee") { $root="rover/jeeminee"; }
elsif ($ENV{'REMOTE_USER'} eq "hoopuntel") { $root="rover/hoopuntel"; }

if ($data{'path'} ne "") {
	$path=$data{'path'};
	$path= ($path eq "/.." ? "" : $path) ;
	$path= ($path eq "/." ? "" : $path) ;
	$path=~ s/\/[^\/]+\/\.\.//g;
	$path=~ s/\/\.//g;
}
if (length($root)>length($path)) { $path=$root; }

## HTML-Header
print <<ENDHTML;
<HTML>
<HEAD>
    <META NAME="author" CONTENT="Marco Graf v/o Marabu">
    <TITLE>Pfadi Alvier Buchs : Upload</TITLE>
    <BASE TARGET="hauptframe">
</HEAD>
<BODY BGCOLOR="#DDDDDD" TEXT="#000000" LINK="#0000FF" VLINK="#0000FF" ALINK="#FF0000">

<FORM NAME="formular" ACTION="index.cgi?path=$path" METHOD=POST ENCTYPE="multipart/form-data">
<INPUT TYPE=HIDDEN NAME="aktion" VALUE="">


<FONT SIZE=+2>HTML-basierender FTP-Zugriff f&uuml;r <B>$ENV{'REMOTE_USER'}</B></FONT><BR>
<BR>
<B>PATH: <I>$path</I></B><BR>
<BR>
ENDHTML


## Aktionen
if ($data{'aktion'} eq "mkdir"){
	print ((-d "/home/alvier.ch/htdocs/$path/$data{'directory'}") ? "<FONT COLOR=#FF0000>Directory alredy exists!</FONT><BR>\n" : `mkdir /home/alvier.ch/htdocs/$path/$data{'directory'}`);
}
if ($data{'aktion'} eq "rmdir"){
	print ((rmdir "/home/alvier.ch/htdocs/$path/$data{'directory'}") ? "" : "<FONT COLOR=#FF0000>Directory is not empty!</FONT><BR>\n");
}
if ($data{'aktion'} eq "rm"){
	foreach $datei (@dateien){
		print ((-e "/home/alvier.ch/htdocs/$path/$datei") ? (`rm /home/alvier.ch/htdocs/$path/$datei` ? "" : "ERROR<BR>\n") : "<FONT COLOR=#FF0000>File $path/$datei does not exist!</FONT><BR>\n");
	}
}


## Tabellenbegin
print <<ENDHTML;

<TABLE BORDER=1>
	<TR>
		<TD VALIGN=TOP WIDTH=400 ALIGN=CENTER>
ENDHTML


## Liste den Inhalt des Directorys auf
@dir = split(/\n/,`ls -al /home/alvier.ch/htdocs/$path`);
@directorys=();
@files=();
foreach $line (@dir){
	$test=$line;
	unless($test !=~ /\b[^ ]{10} /sgi) { next; }
	if ($line =~ /(d[^ ]{9}) +([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+)/){
		push(@directorys,{mode=>$1,files=>$2,group=>$3,user=>$4,size=>$5,month=>$6,day=>$7,time=>$8,name=>$9});
	}
	$line=$test;
	if ($line =~ /(-[^ ]{9}) +([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+ +)([^ ]+)/){
		push(@files,{mode=>$1,files=>$2,group=>$3,user=>$4,size=>$5,month=>$6,day=>$7,time=>$8,name=>$9});
	}
}
sort(@directorys);
sort(@files);
print "\t\t\t<TABLE BORDER=0 WIDTH=350>\n";
for $directory (@directorys){
	print "\t\t\t\t<TR>\n\t\t\t\t\t<TD WIDTH=100>\n\t\t\t\t\t\t$directory->{'mode'}\n\t\t\t\t\t</TD>\n\t\t\t\t\t<TD WIDTH=100>\n\t\t\t\t\t\t$directory->{'files'}\n\t\t\t\t\t</TD>\n\t\t\t\t\t<TD WIDTH=150>\n\t\t\t\t\t\t<A HREF=\"?path=$path/$directory->{'name'}\">$directory->{'name'}/</A>\n\t\t\t\t\t</TD>\n\t\t\t\t</TR>\n";
}
for $file (@files){
	print "\t\t\t\t<TR>\n\t\t\t\t\t<TD WIDTH=100>\n\t\t\t\t\t\t$file->{'mode'}\n\t\t\t\t\t</TD>\n\t\t\t\t\t<TD WIDTH=100>\n\t\t\t\t\t\t$file->{'size'}\n\t\t\t\t\t</TD>\n\t\t\t\t\t<TD WIDTH=150>\n\t\t\t\t\t\t<INPUT NAME=\"datei\" TYPE=CHECKBOX VALUE=\"$file->{'name'}\">$file->{'name'}\n\t\t\t\t\t</TD>\n\t\t\t\t</TR>\n";
}
print "\t\t\t</TABLE>\n\t\t</TD>\n";

## Formular
print <<ENDHTML;
		<TD VALIGN=TOP ALIGN=CENTER>
			<TABLE BORDER=0>
				<TR>
					<TD VALIGN=TOP>
						<FONT SIZE=+1><U>Ordner:</U></FONT><BR>
						<BR>
						<INPUT TYPE=TEXT NAME="directory"><BR>
						<INPUT TYPE=BUTTON VALUE="Löschen" onClick="javascript:document.formular.aktion.value='rmdir';document.formular.submit();"><INPUT TYPE=BUTTON VALUE="Erstellen" onClick="javascript:document.formular.aktion.value='mkdir';document.formular.submit();">
					</TD>
				</TR>
				<TR>
					<TD VALIGN=TOP>
						<HR>
						<FONT SIZE=+1><U>File:</U></FONT><BR>
						<BR>
						uploaden:<BR>
						<INPUT NAME="file" TYPE=FILE SIZE=30 MAXLENGTH=1000000><BR>
						<INPUT TYPE=SUBMIT VALUE="Speichern"><BR>
						<BR>
						ausgew&auml;lte <INPUT TYPE=BUTTON VALUE="Löschen" onClick="javascript:document.formular.aktion.value='rm';document.formular.submit();"><BR>
						<BR>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</FORM>

</BODY>
</HTML>
ENDHTML
