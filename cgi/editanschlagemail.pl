#!/usr/bin/perl

use CGI qw/:standard/;

## HTML Ausgabe

print "Content-type: text/html\n\n";
print <<ENDHTML;
<HTML>
<HEAD>
	<TITLE>Emaileintrag &auml;ndern f&uuml;r Anschlagsbrett</TITLE>
</HEAD>
<BODY BGCOLOR="#DDDDDD" TEXT="#000000" LINK="#0000FF" ALINK="#FF0000" VLINK="#0000FF">

<FORM METHOD="POST" NAME="email_anschlag_neu" ACTION="/cgi/anschlagemail.pl">
<INPUT TYPE="hidden" NAME="formart" VALUE="new">
Hier kannst Du Deinen Eintrag &Auml;ndern:<BR>
<BR>
<TABLE BORDER=3>
	<TR>
		<TD COLSPAN=3>
ENDHTML
print '<B><CENTER>email:&nbsp;</B><INPUT TYPE="text" NAME="email" VALUE="'.param(email).'" SIZE="30"><BR>';
print <<ENDHTML;
		</TD>
	</TR>
	<TR>
		<TD>
ENDHTML
if (param(stufe1)){
	print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="stufe1" checked> 1.Stufe<BR>';}
else {
	print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="stufe1"> 1.Stufe<BR>';}
if (param(bienli)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="bienli" onClick="if (document.email_anschlag_neu.stufen[1].checked) document.email_anschlag_neu.stufen[0].checked=true;" checked> Bienli<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="bienli" onClick="if (document.email_anschlag_neu.stufen[1].checked) document.email_anschlag_neu.stufen[0].checked=true;"> Bienli<BR>';}
if (param(woelfe) != undef){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="woelfe" onClick="if (document.email_anschlag_neu.stufen[2].checked) document.email_anschlag_neu.stufen[0].checked=true;" checked> W&ouml;lf<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="woelfe" onClick="if (document.email_anschlag_neu.stufen[2].checked) document.email_anschlag_neu.stufen[0].checked=true;"> W&ouml;lf<BR>';}
print <<ENDHTML;
		</TD>
		<TD>
ENDHTML
if (param(stufe2)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="stufe2" checked> 2. Stufe<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="stufe2"> 2. Stufe<BR>';}
if (param(pfaderinnen)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="pfaderinnen" onClick="if (document.email_anschlag_neu.stufen[4].checked) document.email_anschlag_neu.stufen[3].checked=true;" checked> Pfaderinnen<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="pfaderinnen" onClick="if (document.email_anschlag_neu.stufen[4].checked) document.email_anschlag_neu.stufen[3].checked=true;"> Pfaderinnen<BR>';}
if (param(pfader)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="pfader" onClick="if (document.email_anschlag_neu.stufen[5].checked) document.email_anschlag_neu.stufen[3].checked=true;" checked> Pfader<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="pfader" onClick="if (document.email_anschlag_neu.stufen[5].checked) document.email_anschlag_neu.stufen[3].checked=true;"> Pfader<BR>';}
print <<ENDHTML;
		</TD>
		<TD>
ENDHTML
if (param(abteilung)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="abteilung" checked> Abteilung<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="abteilung"> Abteilung<BR>';}
if (param(raider)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="raider" checked> Raider<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="raider"> Raider<BR>';}
if (param(rover)){
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="rover" checked> Rover<BR>';}
else{
print '			<INPUT TYPE="checkbox" NAME="stufen" VALUE="rover"> Rover<BR>';}
print <<ENDHTML;
		</TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<CENTER><INPUT TYPE="submit" VALUE="OK"><CENTER>
		</TD>
	</TR>
</TABLE>
</FORM>

</BODY>
</HTML>
ENDHTML

