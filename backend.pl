#!/usr/bin/perl -w
use DBI;
use 5.010001;
use warnings "all";
use Net::SNMP;
use FindBin qw($Bin);
#connect to mysql sever:
my $db_conf_path = substr($Bin,0,rindex($Bin,'/')+1)."db2.conf";
open FILE, "$db_conf_path" or die $!;
my @data = <FILE>;
my @host = split('"', $data[0]);
my @port = split('"', $data[1]);
my @database = split('"', $data[2]);
my @username = split('"', $data[3]);
my @password = split('"', $data[4]);
#####assiging to an individual variable####################
$dsn = "dbi:mysql:$database[1];$host[1];$port[1]";
########perl DBI connect
$dbh = DBI->connect($dsn,$username[1],$password[1]) or die "unable to connect: $DBI::errstr\n";
########prepare the query
$query1 = $dbh->prepare("select * from DEVICES");
$query1->execute;

####fetching the values##########
while (@row = $query1->fetchrow_array)
 {
    $id=$row[0];
    $ip=$row[1];
    $port=$row[2];
    $community=$row[3];
#creating a session for polling an snmp device
  $OID_sysUpTime = '1.3.6.1.2.1.1.3.0';
  $session = Net::SNMP->session( -hostname => $ip, -port => $port, - community => $community, nonblocking => 1, timeout=>1
  );
  $result = $session->get_request(
                -varbindlist => [$OID_sysUpTime], 
                -callback => [ \&get_callback, "$id","$ip","$port","$community"]);
#can end the loop in the ending but it may take time
 }
snmp_dispatcher();
  $result = $session->close();
sub get_callback
    {
#storing all in an array @_
       ($session,$id,$ip,$port,$community) = @_;
        my $oid = '1.3.6.1.2.1.1.3.0';
        my $response =$session->var_bind_list($oid);
       
      if(!defined $response)
           {
              responsefail($session,$id,$ip,$port,$community);
           }
#remove the else if time exceeds    
   else
 	 {
   	$sysup = $response->{$oid};
   	$updatetime = localtime();
$table2 = "CREATE TABLE IF NOT EXISTS deviceinfosasi (
id int(255) NOT NULL AUTO_INCREMENT,
ip varchar(40),
port varchar(40),
community varchar(40),
reqsent int(25) NOT NULL,
lostreq int(25) NOT NULL,
sysup varchar(40) ,
systemtime varchar(40),
updatetime varchar(40),
lastmissed varchar(40),
PRIMARY KEY (id) )
ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;";
##creating the table####
$query2 = $dbh->prepare($table2);
$query2->execute;
my $know = $dbh->prepare("SELECT * FROM deviceinfosasi WHERE ip = '$ip' && community ='$community' "); 
#the value of id has been take from the array @_`
$know->execute;
#this fetches only one line that is the starting line
my @row1 = $know->fetchrow_array();

 if($row1[1] eq "$ip" && $row1[2] eq "$port" && $row1[3] eq "$community")

  {
 $req=$row1[4]+1;
  $update = $dbh->prepare("UPDATE deviceinfosasi SET  reqsent = '$req',  sysup ='$sysup',  systemtime='$updatetime', updatetime = '$updatetime' WHERE ip = '$ip' && community='$community'" );
  $update->execute;
   }

 else
   {
$insert = $dbh->prepare("INSERT INTO deviceinfosasi (ip, port, community, reqsent, lostreq, sysup, systemtime, updatetime) VALUES ('$ip' , '$port', '$community', '1','0','$sysup', '$updatetime', '$updatetime')");
$insert->execute;
    }

return 0;
  }
return 0;
}
#for failure in polling
sub responsefail
{
($session,$id,$ip,$port,$community)=@_;
$updatetime = localtime();

$table2 = "CREATE TABLE IF NOT EXISTS deviceinfosasi (
id int(255) NOT NULL AUTO_INCREMENT,
ip varchar(40),
port varchar(40),
community varchar(40),
reqsent int(25) NOT NULL,
lostreq int(25) NOT NULL,
sysup varchar(40) ,
systemtime varchar(40),
updatetime varchar(40),
lastmissed varchar(40),
PRIMARY KEY (id) )
ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;";
$query3 = $dbh->prepare($table2);
$query3->execute;
my $know2 = $dbh->prepare("SELECT * FROM deviceinfosasi WHERE  ip = '$ip' && community = '$community'" );
$know2->execute;
my @row2=$know2->fetchrow_array();

 if($row2[1] eq "$ip" && $row2[2] eq "$port" && $row2[3] eq "$community")
     {
$reqf=$row2[4]+1;
    $lost=$row2[5]+1;
#no need to update ip port community as they are alredy present while verfiying logic
     $update2=$dbh->prepare("UPDATE deviceinfosasi SET reqsent = '$reqf', lostreq = '$lost', updatetime = '$updatetime', lastmissed = '$updatetime' WHERE ip= '$ip' && community='$community' ");
    $update2->execute;  
     }
else
    {
    $insert1 = $dbh->prepare("INSERT INTO deviceinfosasi (ip, port , community , reqsent ,lostreq , updatetime , lastmissed) VALUES ( '$ip', '$port' , '$community', '1' ,'1' ,'$updatetime' , '$updatetime')");
 $insert1->execute;
    }

return 0;
}
























