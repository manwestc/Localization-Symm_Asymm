import sys,argparse,csv
from datetime import datetime

file = 'final.csv'
nroPuntos = 11


tiempos = (nroPuntos-1)*2 +1
FMT = '%H:%M:%S.%f'
beacons = ["C8:5B:EA:43:6F:75","FB:D3:B5:B9:89:F2","F7:24:98:9B:B6:EA","C9:EC:7A:17:D8:D5","EA:EF:87:2F:4D:93"]


#abre archivo
with open(file, 'rb') as f:


	for line in f.readlines():
		line = line[:-1]
		if len(line.split(' '))<2:
			continue

		#leer tiempos
		if tiempos>0:
			array = line.split(' ')
			delta = datetime.strptime(array[4],FMT) - datetime.strptime(array[2],FMT)
			print str(array[0])+','+str(delta.seconds) +','+str(delta.microseconds)
			tiempos-=1
		#procesa simulacion
		else:
			array = line.split(' ')
			vals = [0]*5
			#print array
			for i in range(4,14,2):
				for x in range(0,5):
					if(array[i]==beacons[x]):
						vals[x] = array[i+1]
						break
			tmpVal = 0 # 0 no se mueve, 1 se mueve
			if array[3]=="True":
				tmpVal=1
			print str(tmpVal)+','+str(array[0])+","+str(vals[0])+','+str(vals[1])+','+str(vals[2])+','+str(vals[3])+','+str(vals[4])


