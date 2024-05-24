set ns [ new Simulator ]

$ns color 1 blue 

set nam [ open out.nam w ]
$ns namtrace-all $nam

set tr [ open out.tr w ]
$ns trace-all $tr

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

$n0 shape square

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n3 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n5 10Mb 10ms DropTail

set tcp [ new Agent/TCP ]
set sink [ new Agent/TCPSink ]

$tcp set fid_ 1

$ns attach-agent $n1 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $tcp

proc finish {} {
	global ns nam tr 
	$ns flush-trace
        close $tr
	close $nam
	exec nam out.nam &
	exit 0
}

$ns at 0.1 "$cbr start"
$ns at 1.0 "$cbr stop"
$ns at 1.5 "finish"
$ns run

 



