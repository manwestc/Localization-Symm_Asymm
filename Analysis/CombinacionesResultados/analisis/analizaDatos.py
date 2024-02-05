import math
import sys
import numpy as np


def leerArchivo(ruta,beacon):
	
	#mapea las MAC
	macs  = {}
	macs["C8:5B:EA:43:6F:75"] = 1
	macs["FB:D3:B5:B9:89:F2"] = 2
	macs["F7:24:98:9B:B6:EA"] = 3
	macs["C9:EC:7A:17:D8:D5"] = 4
	macs["EA:EF:87:2F:4D:93"] = 5
	beacons = [ [], [] ,[] ,[] ,[]]

	#Abre archivo
	try:
		f = open(ruta)
	except:
		sys.stderr("No se pudo abrir %s para la lectura\n",ruta);
		sys.exit(1)

	linea = f.readline()

	while True:
		
		mac = f.readline().strip()
		if mac == '' or len(mac)<17:
			break
		
		rssi = f.readline().strip()
		if rssi == '':
			break
		
		try:
			pos = macs[mac]
		except:
			continue
		vectorMed = np.zeros(5)
		vectorMed[pos-1] = int(rssi)
			
		#print vectorMed
		beacons[pos-1].append(int(rssi))
	
	#print beacons[4]
	#for it in range(0,5):
	media = np.mean(beacons[beacon-1])
	std = np.std(beacons[beacon-1])
	return media, std
	#for it2 in range(0,5):
	#	print len(beacons[it2])

if __name__=='__main__':
	
	beacon = 2
	ruta = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x0'
	for pot in range(1,7):
		print '\nPotencia '+str(pot)
		ruta2 = ruta + str(pot)+'/'
		mediaM = 0;
		for it in range(1,16):
			print '\tPosicion '+str(it)
			ruta3 = ruta2+'p'+str(it)
			#print ruta3
			tmp1, tmp2 = leerArchivo(ruta3,beacon-1)
			mediaM = mediaM + tmp2
		print mediaM/15.0
