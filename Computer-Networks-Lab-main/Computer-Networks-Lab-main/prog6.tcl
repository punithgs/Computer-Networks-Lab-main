set ns [ new Simulator ]

set tr [ open out.tr w ]
$ns trace-all $tr

set nam [ open out.nam w ]
$ns namtrace-all $nam

set n0 [ $ns node ]
set n1 [ $ns node ]

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Reciever"

Agent/TCP set nam_tracevar_ true

$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail

set tcp [ new Agent/TCP ]
set sink [ new Agent/TCPSink ]

$tcp set window_ 1
$tcp set maxcwnd_ 1

$ns attach-agent $n0 $tcp
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $tcp

$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp
$tcp set tracevar cwnd_

proc finish {} {
	global ns tr nam
	$ns flush-trace
	close $nam
	close $tr
	exec nam out.nam &
	exit 0 
}

$ns at 0.1 "$cbr start"
$ns at 3.5 "finish"
$ns run 




