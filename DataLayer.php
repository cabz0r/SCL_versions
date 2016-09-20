<?php

include_once 'variables.php';

class DataLayer{

public $conn;

/*ONLY SELECT VERSIONS WHICH ARE NOT CLIENT SPECIFIC*/
public $querySQL = 
"select distinct [10] from prodcat where [10] like 'px%' 
and [10] NOT LIKE '%KC%' 
and [10] NOT LIKE '%PWB%' 
and [10] NOT LIKE '%AX%' 
and [10] NOT LIKE '%HEINZ%' 
and [10] NOT LIKE '%DW%' 
and [10] NOT LIKE '%CLOROX%'";


public function connect(){
$var = new variables();
$odbc = $var->getODBC();
$user = $var->getUser();
$pass = $var->getPass();

/*
echo $odbc;
echo $user;
echo $pass;
*/

$this->conn = odbc_connect($odbc,$user,$pass);
return $this->conn;
}

public function disconnect(){
return odbc_close($this->conn);
}

public function getVersions($query1){

if ($this->conn){
$result = odbc_exec($this->conn, $query1);

  while(odbc_fetch_row($result))
  {
    for($i=1;$i<=odbc_num_fields($result);$i++) 
    {
    echo "<option value='" . odbc_result($result,$i) . "'>" . odbc_result($result,$i). "</option><br/>";
    }
  }
}
else echo "odbc not connected";
}

}
?>