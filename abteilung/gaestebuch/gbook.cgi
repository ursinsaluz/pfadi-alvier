#!/usr/bin/perl


## Variablendefinition
$htmlfilename="gbook.htm";
$datafilename="data/data.dat";
$vonzeile=1;


## Einlesen der Zusatzvariablen
$getipt = $ENV{'QUERY_STRING'};
$getipt =~ tr/\+/ /;
@data=split(/\?/,$getipt);
foreach $i (0..$#data){
	($feld[$i],$value[$i])=split(/=/,$data[$i]);
	if ($feld[$i] eq "vonzeile") { $vonzeile=$value[$i]; }
}
$biszeile=$vonzeile + 9;


## DATA-File einlesen
@DATAFILE=("");
@filefelder=();
@datenzeile=();
open(DATAFILE,"<$datafilename") || die "Error opening file $datafilename";
while(<DATAFILE>) {
	if ($. == 1){
		$anzeintraege = $_;
		next;
	}
	if ($. == 2) {
		@filefelder=split(/\|/,$_);
		pop(@filefelder);
		next;
	}
	if (($. >= ($vonzeile + 2))&&($. <= ($biszeile + 2))){
		push(@datenzeile,$_);
	}
}
close(DATAFILE);
if ($biszeile > $anzeintraege) { $biszeile = $anzeintraege; }


## HTML-File einlesen
@HTMLFILE=("");
open(HTMLFILE, "<$htmlfilename") || die "Error opening HTML-file $htmlfilename";
@htmlanfang=();
@htmlmitte=();
@htmlende=();
$laufvar=0;
while(<HTMLFILE>){
	if ($laufvar==0) {
		if ($_ =~ s/(.*)<!--BEGIN_GBOOK-->(.*)//g) {
			push(@htmlanfang,$1);
			push(@htmlmitte,$2);
			$laufvar++;
			next;
		}
		else { push(@htmlanfang,$_); }
		}
	if ($laufvar==1) {
		if ($_ =~ s/(.*)<!--END_GBOOK-->(.*)//g) {
			push(@htmlmitte,$1);
			push(@htmlende,$2);
			$laufvar++;
			next;
		}
		else { 
			push(@htmlmitte,$_);
			}
		}
	if ($laufvar==2) {
		push(@htmlende,$_);
		}
	if (($laufvar!=0)&&($laufvar!=1)&&($laufvar!=2)) { die "Error occured in \$laufvar";}
}
close(HTMLFILE);


## Spezialdaten HTML-gerecht machen
foreach $daten (@datenzeile){
	@data=();
	@data=split(/\|/,$daten);
	foreach $i (0..$#filefelder){
		if (($filefelder[$i] eq "homepage")&&($data[$i]=~/[\S]/)){
			$data[$i]="<A HREF=\"$data[$i]\" TARGET=\"_blank\">$data[$i]</A>";
		}
		if (($filefelder[$i] eq "email")&&($data[$i]=~/[\S]/)){
			$data[$i]="<A HREF=\"mailto:$data[$i]\">$data[$i]</A>";
		}
	}
	$daten=join("\|",@data);
}


## Ausgabe
print "Content-type: text/html\n\n";
## Ausgabe Anfang
for ($i=0;$i<=$#htmlanfang;$i++){
	if ( $htmlanfang[$i] =~ /(.*)<!--\$(.*)\$-->(.*)/ ) {
		print $1;
		$search= $2;
		$searchstring= $3;
		until ( $searchstring=~ /(.*)<!--\$$search\$-->(.*)/ || ($i >= $#htmlanfang) ) {
			$i++;
			$searchstring=$searchstring . $htmlanfang[$i];
		}
		$searchstring=~ /(.*)<!--\$$search\$-->(.*)/s;
		$searchstring=$1;
		$htmlanfang[$i]=$2;
		$i--;
		if (($search eq "prev")&&($vonzeile > 1)) {
			$prevzeile=$vonzeile-10;
			if ($prevzeile < 1) { $prevzeile=1; }
			$searchstring =~ s/\$$search\$/$prevzeile/g ;
			$htmlanfang[$i]=$searchstring;
			$i--;
		}
		if (($search eq "next")&&($biszeile < $anzeintraege)) {
			$nextzeile=$vonzeile+10;
			$searchstring =~ s/\$$search\$/$nextzeile/g ;
			$htmlanfang[$i]=$searchstring;
			$i--;
		}
	}
	else {
		$htmlanfang[$i] =~ s/\$startnr\$/$vonzeile/g;
		$htmlanfang[$i] =~ s/\$endnr\$/$biszeile/g;
		$htmlanfang[$i] =~ s/\$anzeintraege\$/$anzeintraege/g;
		print $htmlanfang[$i];
	}
}
## Ausgabe Mitte
foreach $daten (@datenzeile){
	@data=();
	@data=split(/\|/,$daten);
	pop(@data);
	@temp=@htmlmitte;
	for ($i=0;$i<=$#htmlmitte;$i++){
		if ( $htmlmitte[$i] =~ /(.*)<!--\$(.*)\$-->(.*)/ ) {
			print $1;
			$search= $2;
			$searchstring= $3;
			until ( $searchstring=~ /(.*)<!--\$$search\$-->(.*)/ || ($i >= $#htmlmitte) ) {
				$i++;
				$searchstring=$searchstring . $htmlmitte[$i];
			}
			$searchstring=~ /(.*)<!--\$$search\$-->(.*)/s;
			$searchstring=$1;
			$htmlmitte[$i]=$2;
			$i--;
			foreach $j (0..$#filefelder){
				if ($filefelder[$j] eq $search) {
					if ($data[$j]=~/[\S]/) {
						$searchstring =~ s/\$$search\$/$data[$j]/g ;
						print $searchstring;
					}
				}
			}
		}
		else {
			print $htmlmitte[$i];
		}
	}
	@htmlmitte=@temp;
}
## Ausgabe Ende
for ($i=0;$i<=$#htmlende;$i++){
	if ( $htmlende[$i] =~ /(.*)<!--\$(.*)\$-->(.*)/ ) {
		print $1;
		$search= $2;
		$searchstring= $3;
		until ( $searchstring=~ /(.*)<!--\$$search\$-->(.*)/ || ($i >= $#htmlende) ) {
			$i++;
			$searchstring=$searchstring . $htmlende[$i];
		}
		$searchstring=~ /(.*)<!--\$$search\$-->(.*)/s;
		$searchstring=$1;
		$htmlende[$i]=$2;
		$i--;
		if (($search eq "prev")&&($vonzeile > 1)) {
			$prevzeile=$vonzeile-10;
			if ($prevzeile < 1) { $prevzeile=1; }
			$searchstring =~ s/\$$search\$/$prevzeile/g ;
			$htmlende[$i]=$searchstring;
			$i--;
		}
		if (($search eq "next")&&($biszeile < $anzeintraege)) {
			$nextzeile=$vonzeile+10;
			$searchstring =~ s/\$$search\$/$nextzeile/g ;
			$htmlende[$i]=$searchstring;
			$i--;
		}
	}
	else {
		$htmlende[$i] =~ s/\$startnr\$/$vonzeile/g;
		$htmlende[$i] =~ s/\$endnr\$/$biszeile/g;
		$htmlende[$i] =~ s/\$anzeintraege\$/$anzeintraege/g;
		print $htmlende[$i];
	}
}

