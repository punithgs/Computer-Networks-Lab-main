set ns [ new Simulator ]

set tr [ open out.tr w ]
$ns trace-all $tr 

set nam [ open out.nam w ]
$ns namtrace-all $nam

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]
set n4 [ $ns node ]
set n5 [ $ns node ]

$ns duplex-link $n0 $n1 1Mb 20ms DropTail
$ns queue-limit $n0 $n1 5
$ns duplex-link $n0 $n2 1Mb 20ms DropTail
$ns duplex-link $n0 $n3 1Mb 20ms DropTail
$ns duplex-link $n3 $n4 1Mb 20ms DropTail
$ns duplex-link $n3 $n5 1Mb 20ms DropTail

set tcp [ new Agent/TCP ]
set sink [ new Agent/TCPSink ]

set ftp [ new Application/FTP ]

$ns attach-agent $n1 $tcp
$ns attach-agent $n4 $sink 

$ns connect $tcp $sink

$ftp attach-agent $tcp

proc finish {} {
	global ns tr nam 
	$ns flush-trace
	close $nam 
	close $tr 
	exec nam out.nam &
	exit 0
}

$ns at 0.5 "$ftp start"
$ns at 0.25 "$ns queue-limit $n3 $n4 0"
$ns at 0.26 "$ns queue-limit $n3 $n4 5"
$ns at 1.5 "finish"
$ns run







