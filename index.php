<!DOCTYPE html>
<html>
<body style= "background-color:#7FFF00">
<h1>Assignment 4</h1>
<h2> system up time is displayed for each device</h2>
<p> Click on the ID to retrive the device information </p>
<style>
h1{

	margin: 1em 0 0.5em 0;
	font-weight: 500;
	font-family: 'Titillium Web', times new roman;
        text-align: left;
	position: relative;  
	font-size: 40px;
	line-height: 40px;
	padding: 15px 15px 15px 15%;
	color: #4d4d4d;
	box-shadow: 
		inset 0 0 0 1px rgba(53,86,129, 0.4), 
		inset 0 0 5px rgba(53,86,129, 0.5),
		inset -285px 0 35px black;
	border-radius: 0 0px 0 0px;
	background: #fff  no-repeat center;

   
}
h2{
text-align:center;
color:#00008B;
font-size:20px
}
p{
text-align:center;
position:bottom;
color:#355681;
font-size:10px;
}
table { 

color: #333; /* Lighten up font color */
font-family: Helvetica, Arial, sans-serif; /* Nicer font */
width: 640px; 
height:200px;
border-collapse: 
collapse; border-spacing: 1; 
}

td, th { border: 1px solid #CCC; height: 30px; } /* Make cells a bit taller */

th {
background: #F3F3F3; /* Light grey background */
font-weight: bold; /* Make sure they're bold */
}

p{
font-family:"Times new Roman";
font-size:20px;
}
tr {
background: #ffffff; /* Lighter grey background */
text-align: center; /* Center our text */
}

</style>

<?php
$path=getcwd();
$conf=substr($path,0,strripos($path,'/')+1)."db2.conf";
$doc= file("$conf");
$read = fopen($conf,"r");
while (!feof($read))
{
$line=fgets($read);
for($i=0;$i<=4;$i++)
{
$credentials=explode('"',$doc[$i]);
$values[$i]= "$credentials[1]";
}
$host = $values[0];
$port = $values[1];
$database = $values[2];
$username = $values[3];
$password = $values[4];
}
$con =  mysql_connect("$host:$port","$username","$password");
if(!$con)
  {
  die ('could not connect: .'. mysql_error());
  }
#echo "connected to mysql server<br>";
mysql_select_db("$database",$con)
or die("could not select"); 
$colours=array("FFFFF","FFEEEE","FFEBEB","FFE5E5","FFE6E6","FFEAEA",
"FFD6D6","FFCCCC","FFC9C9","FFC1C1","FFB2B2","FFADAD","FFA3A3",
"FF9999","FF8383","FF8080","FF7F7F","FF7575","FF6666","FF5959","FF5555",
"FF4D4D","FF4C4C","FF4646","FF4545","FF3333","FF3000","E60000","CC0000");

$result=mysql_query("SELECT * FROM deviceinfosasi") or die(mysql_error());

echo '<table  solid black  align="center">
<tr>
<th>ID</th>
<th>IP</th>
<th>PORT</th>
<th>COMMUNITY</th>
<th>STATUS</th>
</tr>';
while($rowdata=mysql_fetch_array($result))
{
$ip=$rowdata['ip'];
$id= $rowdata['id'];
$sysup=$rowdata['sysup'];
$reqsent=$rowdata['reqsent'];
$systemtime=$rowdata['systemtime'];
$lastmissed=$rowdata['lastmissed'];
$updatetime=$rowdata['updatetime'];
$n=$rowdata['lostreq'];
$color="#"."$colours[$n]";
if($n >= 30)
{
$color="#"."990000";
}
echo "<tr>";
echo "<td><a class = 'show-content' data-id=
'       DEVICE INFORMATION

System Up Time = $sysup
Sent Requests  = $reqsent
lostrequest 	= $n
missed request  = $lastmissed
Last System UpTime = $systemtime
Web Server time = $updatetime
last LOST REQUEST At = $lastmissed' 
href ='?category=$id'> $id </a></td>";
echo "<td>". $rowdata['ip']. "</td>";
echo "<td> " . $rowdata['port']."</td>";
echo "<td>" . $rowdata['community']."</td>";
echo "<td bgcolor=$color width=50></td>";
echo"</tr>";
}
echo"</table>";
?>
</body>
<script language ="javascript" type="text/javascript" >
   var element = document.querySelectorAll(".show-content");
   for (var link in element) {
     element[link].onclick = function(){
showContent(this.getAttribute('data-id'));
};
}
function showContent(value){
alert(value);
}
</script>
</table>
</body>
</html>


   

