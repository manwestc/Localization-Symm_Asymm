import datetime
import sys

ruta = sys.argv[1]


tiempos = []
mac = ["C8:5B:EA:43:6F:75","FB:D3:B5:B9:89:F2","F7:24:98:9B:B6:EA","C9:EC:7A:17:D8:D5","EA:EF:87:2F:4D:93"]
with open(ruta+'/tiempos') as f:
	tiempos = f.readlines()

punto = []
tiempoIni = []
tiempoFin = []

for tiempo in tiempos:
	tmp = tiempo.split(" ")
	punto.append(tmp[0])
	tiempoIni.append(tmp[1]+' '+tmp[2])
	tiempoFin.append(tmp[3]+' '+tmp[4])
	print tmp[0],"\t",tmp[1]+' '+tmp[2],"\t",tmp[3]+' '+tmp[4]


puntoActual = 0
estaAndando = True
for it in range(1,22):
 	fileTmp = open(ruta+"/t"+str(it),"r")
 	medidas = fileTmp.readlines()
 	nroMedidas = len(medidas)-1
 	tiempo1 = datetime.datetime.strptime(tiempoIni[it-1], "%Y-%m-%d %H:%M:%S.%f")
 	tiempo2 = datetime.datetime.strptime(tiempoFin[it-1], "%Y-%m-%d %H:%M:%S.%f\n")
 	
 	estaAndando = not estaAndando
	if not estaAndando:
		puntoActual = puntoActual+1

	for medida in medidas:
		tmp2 = medida.split(' ')
		#print (tiempoFin[it]-tiempoIni[it])
		if len(tmp2)<7:
			continue
		linea = str(puntoActual)+" "+tmp2[0]+" "+tmp2[1]+" "+str(estaAndando)	
		for it2 in range(0,5):
			linea = linea + " "+str(mac[it2])+" "+str(tmp2[it2+2])
		print linea
	fileTmp.close()
