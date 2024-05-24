set ns [ new Simulator ]

set tr [ open out.tr w ]
$ns trace-all $tr

set nam [ open out.nam w ]
$ns namtrace-all $nam 

set ng1 [ open tcp1.xg w ]
set ng2 [ open tcp2.xg w ]

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

$ns make-lan "$n0 $n1 $n2" 1Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n3 $n4 $n5" 2Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n0 $n3 1Mb 10ms DropTail

set tcp1 [ new Agent/TCP ]
set tcp2 [ new Agent/TCP ]
set sink1 [ new Agent/TCPSink ]
set sink2 [ new Agent/TCPSink ]
set cbr1 [ new Application/Traffic/CBR ]
set cbr2 [ new Application/Traffic/CBR ]

$ns attach-agent $n4 $tcp1
$ns attach-agent $n2 $sink1
$ns attach-agent $n1 $tcp2
$ns attach-agent $n5 $sink2

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

$cbr1 attach-agent $tcp1
$cbr2 attach-agent $tcp2

$tcp1 set class_ 1
$tcp2 set class_ 2

proc finish {} {
  	global ns tr nam
  	$ns flush-trace
  	close $nam
  	close $tr 
  	exec nam out.nam &
  	exec xgraph tcp1.xg tcp2.xg &
  	exit 0
  }
 
proc Draw {Agent File} {
	global ns 
	set Cong [ $Agent set cwnd_ ]
	set Time [ $ns now ]
	puts $File "$Time $Cong"
	$ns at [ expr $Time+0.01 ] "Draw $Agent $File"
}

$ns at 0.0 "$cbr1 start"
$ns at 0.7 "$cbr2 start"
$ns at 0.0 "Draw $tcp1 $ng1"
$ns at 0.0 "Draw $tcp2 $ng2"
$ns at 10.0 "finish"
$ns run









