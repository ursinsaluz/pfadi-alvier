<!-- Agenda-Script-->
<html>
<head>
  <title>Agenda 2006</title>
</head>
<BODY TEXT="#000000" BGCOLOR="#DDDDDD" LINK="#0000FF" VLINK="#0000FF" ALINK="#FF0000">
<h1><b>Agenda 2006</b></h1>
<br>
<table border="0" width="80%" color="black">
<tr><td>
<table border="1" width="50%" color="black">
<?php
include 'data/agendadata.inc.php'; 

for($i = 0; $i < sizeof($daten); $i ++)
{
echo "<tr><td bgcolor=";
if($daten[$i]['thema']=="Papiersammeln")
{echo "orange";}
echo ">";
print_r($daten[$i]['datum']);
echo "</td><td bgcolor=";
if($daten[$i]['thema']=="Papiersammeln")
{echo "orange";}
echo ">";
echo $daten[$i]['thema'];
echo "</td></tr>";
}
?>
</table></td></tr>
<tr></tr>
	<tr><td>
--------------------------------------------------
	</tr></td>
<tr></tr>
<tr><td>
<table border="1" width="50%" color="red">
<tr><td bgcolor="green"><font size="5">Biberdaten</font></td></tr>
<tr><td bgcolor="white">An folgenden Daten finden Biberuebungen statt:</td></tr>
<?php include 'data/biberdata.inc.php'; 

for($i = 0; $i < sizeof($daten); $i ++)
{
echo "<tr><td bgcolor='red'>";
print_r($daten[$i]['datum']);
echo "</td></tr>";
}
?>
</td>
</tr>
</table>
</body>
</html>