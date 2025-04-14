<?php
$c=7;
if(c>=22)
{ 
	echo "Error: To many Dates";
}
$daten = array();
$daten[ ] = array('count' => 218,'datum' => "18.02",'thema' => "Papiersammeln"); 
$daten[ ] = array('count' => 225,'datum' => "25.02",'thema' => "Winteranlass"); 
$daten[ ] = array('count' => 317,'datum' => "17.03",'thema' => "Elternversammlung"); 
$daten[ ] = array('count' => 422,'datum' => "22.04",'thema' => "Papiersammeln"); 
$daten[ ] = array('count' => 603,'datum' => "03- 05.06",'thema' => "PfiLa");
$daten[ ] = array('count' => 708,'datum' => "08- 22.07",'thema' => "SoLa");
$daten[ ] = array('count' => 819,'datum' => "19.08",'thema' => "Buchserfest");
$daten[ ] = array('count' => 930,'datum' => "30.09- 07.10",'thema' => "HeLa");
$daten[ ] = array('count' => 1021,'datum' => "21.10",'thema' => "Papiersammeln");
$daten[ ] = array('count' => 1209,'datum' => "09.12",'thema' => "Chlaus");
$daten[ ] = array('count' => 1216,'datum' => "16.12",'thema' => "Papiersammeln");
$daten[ ] = array('count' => 1223,'datum' => "23.12",'thema' => "Waldweihnachten");



sort($daten);
?>