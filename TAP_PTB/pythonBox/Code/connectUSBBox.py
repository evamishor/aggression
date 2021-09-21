import time
from ioLabs import USBBox, REPORT
import socket

def resource_path(relative):
    if hasattr(sys, "_MEIPASS"):
        return os.path.join(sys._MEIPASS, relative)
    return os.path.join(relative)


# REPORT contains the report IDs
UDP_IP = "127.0.0.1"
UDP_PORT = 5005

class UDPWrapper:
	def __init__(self, ip, port):
		self.ip = ip
		self.port = port
		self.sock = socket.socket(socket.AF_INET, # Internet
							  socket.SOCK_DGRAM) # UDP
	def sendUDPMessage(self, message):
		self.sock.sendto(message, (self.ip, self.port))

udpW = UDPWrapper(UDP_IP, UDP_PORT)
output_log = []

def mycallback(report):
	print "got a report: %s" % report
	if report.id == 72:
		return
	udpW.sendUDPMessage('%d,%d,%d,%s' % (report.key_code, report.id, report.rtc, report.name))
	output_log.append([report.key_code, report.id, report.rtc, report.name])

if __name__ == "__main__":
	print "Here is main app"
	usbbox=USBBox()
	usbbox.commands.add_default_callback(mycallback)
	while True:
		usbbox.process_received_reports()
		time.sleep(0.03)
