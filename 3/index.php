<?php

$json_string = file_get_contents("https://www.w3schools.com/angular/customers.php");

$array = json_decode( $json_string)->records;

foreach ( $array as $data )
{
	$strana[] =  $data->Country;
}
$result = array_unique($strana);

foreach ($result as $res) {
	Get_Names($res, $array );
	echo "<br>";
}

function Get_Names($place, $arr){
	echo '<b>' . $place . '</b>  line should contain: ';
	foreach ($arr as $value) {
		if  ($value->Country == $place){
			echo $value->Name . ', ';
		}
	}

}
?>

