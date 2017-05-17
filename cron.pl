#!/usr/bin/perl -w
use FindBin '$Bin';
while(1)
{
system("perl $Bin/backend.pl");
sleep (2);
}
