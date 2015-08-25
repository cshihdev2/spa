<?php 

//init all variables
$msg ="";
$selected_ssid="";
$password="";
$form_submission=false;

if ($_SERVER["REQUEST_METHOD"]=="POST"){
	// form submission
	$available_ssid=get_available_wifi_list();
	if (empty($_POST["password"])){
		$msg="Must supply password";
	}
	elseif (empty($_POST["selected_ssid"])){
		$msg="Must select a ssid";
	} else {
		$selected_ssid=$_POST["selected_ssid"];
		$password=$_POST["password"];

		error_log($_POST["selected_ssid"]);
		error_log($_POST["password"]);
		$msg="selected Wifi is " . $_POST["selected_ssid"];
		$msg .= "<br>password is " . $_POST["password"];
		$form_submission=true;		
	}
}else{
	$available_ssid=get_available_wifi_list();

}

function get_available_wifi_list(){
	//$ifconfig_value = shell_exec("ifconfig -a");
	//echo $ifconfig_value;


	$output = shell_exec('sudo iwlist wlan0 scan | grep ESSID');
	//echo $output;
	$arr = explode("\n", $output);
	//echo "array output is " ;
	//var_dump($arr);

	$availble_ssid=array();
	foreach ($arr as $value){
		$new_value = trim($value);
		$new_value = str_replace("ESSID:", "", $new_value);
		$new_value = str_replace('"', '', $new_value);
		if (!empty($new_value)){
			$available_ssid[]=$new_value;
		}else{
			//echo "found empty string";
		}
		//echo "$new_value\n" ;
	}
	return $available_ssid;
}
?>


<h1>Greetings from Carol SPA</h1>

<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">

<label>Select available Wi-Fi</lable>
<select name="selected_ssid">
	<?php foreach($available_ssid as $ssid_name) { ?>
	<option value="<?php echo $ssid_name?>"><?php echo "$ssid_name"?></option>
	<?php } ?>

</select>
<br/>
<label>Wi-Fi Password</lable>
<input type="password" name="password" value="<?php echo $password; ?>"/>
<br/>
<input type="submit" name="submit" value="Submit">
</form>

<br/>
<?php echo $msg; ?>

