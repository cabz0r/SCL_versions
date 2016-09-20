<?php

class variables{

private $ODBC_name = "conn"; //name of ODBC connection set in ODBCAD32.exe (must be set to SQL auth)
private $user="user";
private $pw="pass";
private $reportServer="http://ReportServer:8080/SSRS_SQL2008";
private $releaseType="true"; //true = Promax PX, false = Promax BI.

//	ODBC connection string details
//	SERVER: SQLServer\SQL2008_R2
//	DB:		version_management_db


public function getUser(){
return $this->user;
}

public function getPass(){
return $this->pw;
}

public function getODBC(){
return $this->ODBC_name;
}

public function getReportServer(){
return $this->reportServer;
}

public function getReleaseType(){
return $this->releaseType;
}

}

?>