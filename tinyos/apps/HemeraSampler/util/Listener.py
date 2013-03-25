
import socket
import HemeraData
import re
import sys
import binascii

port = 4000

if __name__ == '__main__':

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
    s.bind(('', port))

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = HemeraData.HemeraData(data=data, data_length=len(data))

            print addr
            print rpt
            print binascii.b2a_hex(data)

