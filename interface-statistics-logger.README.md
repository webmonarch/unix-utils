rrdtool create interface_statistics.rrd \
	-s 10 \
	DS:eth0_rx_bytes:DERIVE:30:0:104857600 \
	RRA:AVERAGE:0.5:1:10
