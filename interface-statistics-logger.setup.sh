rrdtool create \
    interface-statistics-logger.rrd \
	-s 10 \
	DS:wan0_rx_bytes:DERIVE:30:0:134217727 \
	DS:wan0_tx_bytes:DERIVE:30:0:134217727 \
	RRA:AVERAGE:0.5:1:60480 \
	RRA:AVERAGE:0.5:6:43800 \
	RRA:AVERAGE:0.5:30:105120	
