<HTML>

<head>
<link rel="stylesheet" type="text/css" href="./css/style.css">
</head>

<body>
<form id="formSelect">
<p>Current Client Version<br>
<select ID="opt_From">
<option value="From Version" selected>From Version</option>
<?php 
//populate listbox element for "FROM version"
include 'DataLayer.php';
$dl = new DataLayer();
$dl->connect();
$dl->getVersions($dl->querySQL);

?>
</select>
</p>


<p>Dispatch Version<br>
<select ID="opt_To">
<option value="To Version" selected>To Version</option>
<?php 

//use existing db connection to populate "TO version"
$dl->getVersions($dl->querySQL);
$dl->disconnect();

?>

</select>
</p>
<button type="button" onClick="loadResults()" value="submit">SUBMIT</button>
</form>


<script>
function loadResults() {

var eF = document.getElementById("opt_From");
var strFrom = eF.options[eF.selectedIndex].text;
//window.alert("set FROM var");

var eT = document.getElementById("opt_To");
var strTo = eT.options[eT.selectedIndex].text;
//window.alert("set TO var");

var xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function() {
    if (xhttp.readyState == 4 && xhttp.status == 200) {
      document.getElementById("result").innerHTML = xhttp.responseText;
    }
  };

  //window.alert("process.php?strFrom="+strFrom+"&strTo="+strTo);
  xhttp.open("GET", "process.php?strFrom="+strFrom+"&strTo="+strTo, true);
  xhttp.send();
  
}
</script>

<div id="result">
Results: Awaiting Input from user.
</div>

</body>
</HTML>