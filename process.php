<?php

//THIS FILE GENERATES THE HTML CODE FOR AN AJAX RESPONSE 
//TO DISPLAY VERSIONS AND THE VERSIONS THEY WERE BUILT FROM.

include_once 'variables.php';

$var = new variables();
$conn = odbc_connect($var->getODBC(),$var->getUser(),$var->getPass());

IF ($conn)
{

  $currentVer = $_GET['strFrom'];
  $dispatchVer = $_GET['strTo'];

  IF ($currentVer == "From Version" || $dispatchVer == "To Version")
  {
      echo "Please select valid version(s)";
  }
  ELSE
  {
  
	  //the SQL statement that will query the database
	  
	  $query = "exec sp_displayVersions '" . $currentVer . "','" . $dispatchVer . "'";

	  //perform the query
	  $result=odbc_exec($conn, $query);
	  
	  //get number of columns returned
	  $colNum = odbc_num_fields($result);
	  $rowNum = odbc_num_rows($result);


	  IF ($rowNum == 0) 
	  {
		echo "Invalid Selection - Client version should be an earlier release than dispatch version";
	  }
	  ELSE
	  {
		echo "<table border=\"0\"><tr>";
			
			//print field headers/names
			FOR ($j=1; $j<= $colNum; $j++)
			{ 
				echo "<th>" . odbc_field_name ($result, $j ) . "</th>";
			}

			//fetch versions returned from database in to a HTML table
			WHILE(odbc_fetch_row($result))
			{
				echo "<tr>";
				for($i=1;$i<=$colNum;$i++) 
				{
					echo "<td>" . odbc_result($result,$i) . "</td>";
				}
				echo "</tr>";
				$i++;
			}
		echo "</tr></table></br>
		<a target=\"_blank\" href=\"" . $var->getReportServer() 
		."/Pages/ReportViewer.aspx?%2fSummary+Change+Log%2fSummaryChangeLogMajorMinor&rs:Command=Render&ReleaseType=" 
		. $var->getReleaseType() . "&releaseFrom=" 
		. $currentVer ."&releaseTo=" 
		. $dispatchVer 
		. "\">
		<button style=\"width:100%\">
		GENERATE SUMMARY CHANGE LOGS
		</button>
		</a>";
		}
	}
}
ELSE 
echo "odbc not connected";

//close the connection
odbc_close ($conn);

?>