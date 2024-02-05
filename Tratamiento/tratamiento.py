import csv
import sys
import os

def readFrom(fichero):
    temp = []
    out = {}

    with open(fichero, 'r') as f:
        fileOutput = f.readlines()

    try:

        for i in range(0, len(fileOutput), 2):
            mac = fileOutput[i].split()[1]

            if fileOutput[i].split()[2] == "(Public)" and mac !="88:0F:10:97:7E:B4":
                if mac in out:
                    out[mac].append(float(fileOutput[i+1].split()[1]))
                else:
                    out[mac] = [float(fileOutput[i+1].split()[1])]


    except IndexError:
        pass


    return out

def parseToCSV(data):
    f = open('table.csv', 'wt')
    try:
        writer = csv.writer(f)
        writer.writerow( ("bdaddr", "RSSI") )

        for e in data:
            writer.writerow( (e[0], e[1]) )
    finally:
        f.close()


def creaFicheroCalibracion(out):
#/** ESTRUCTURA DEL FICHERO
#*
#PUNTOS\n
#nombre_punto_1;coord_x;coord_y\n
#...
#nombre_punto_n;coord_x;coordy\n
#MEDIDAS\n
#nombre_punto_1;bssid_ap1;rssi_ap1;bssid_ap2;rssi_ap2;...;bssid_apn;rssi_apn\n
#...
#nombre_punto_1;bssid_ap1;rssi_ap1;bssid_ap2;rssi_ap2;...;bssid_apn;rssi_apn\n
#...
#nombre_punto_n;bssid_ap1;rssi_ap1;bssid_ap2;rssi_ap2;...;bssid_apn;rssi_apn\n
#...
#nombre_punto_n;bssid_ap1;rssi_ap1;bssid_ap2;rssi_ap2;...;bssid_apn;rssi_apn\n
#
#Se cogen medidas completas, es decir, que tengan datos de todos los routers. Si se tienen mas datos de los demas
#routers, se descartan
#
#*/
    puntos = {}
    puntos["A"]=[2.000,3.255]
    puntos["B"]=[2.51,0.847]
    puntos["C"]=[3.353,5.052]
    puntos["D"]=[0.703,2.421]
    puntos["E"]=[3.888,2.427]
    puntos["F"]=[5.457,3.217]
    puntos["G"]=[7.040,5.068]
    puntos["H"]=[6.159,2.209]
    puntos["I"]=[7.483,3.167]
    puntos["J"]=[8.224,1.859]
    puntos["K"]=[9.816,0.256]
    puntos["L"]=[11.221,0.930]
    puntos["M"]=[12.877,0.508]
    puntos["N"]=[14.440,0.921]
    puntos["O"]=[16.840,0.702]
    puntos["P"]=[19.132,0.800]
    puntos["Q"]=[21.506,1.669]
    puntos["R"]=[22.329,4.640]
    puntos["S"]=[22.878,3.000]
    puntos["T"]=[23.412,1.068]
    puntos["U"]=[24.451,2.520]
    puntos["V"]=[25.060,1.730]
    puntos["W"]=[25.516,4.084]
    puntos["X"]=[27.188,3.182]
    puntos["Y"]=[27.963,4.674]
    puntos["AA"]=[16.387,2.331]
    puntos["AB"]=[14.198,2.430]
    puntos["AC"]=[15.239,4.800]
    puntos["AD"]=[13.231,4.260]

    f_salida = open("medidas_bluetooth.txt","w")
    f_salida.write("PUNTOS\n")

    for p in puntos:
        f_salida.write(p+";"+str(puntos[p][0])+";"+str(puntos[p][1])+"\n");

    f_salida.write("MEDIDAS\n")

#    for p in out:
#        r_sorted = sorted(out[p],key=lambda r: len(out[p][r]))
#        for i in range(len(out[p][r_sorted[0]])):
#            f_salida.write(p)
#            for r in out[p]:
#                f_salida.write(";"+r+";"+str(out[p][r].pop()))
#            f_salida.write("\n")


    for p in out:
#        print "-------- ANTES -----------"
#        for r in out[p]:
#            print "len(out["+p+"]["+r+"])="+str(len(out[p][r]))
        j = 0
        i = 0
        r_sorted = sorted(out[p],key=lambda r: len(out[p][r]))
        len_original = []
        
        for r in r_sorted:
            len_original.append(len(out[p][r]))

        while j < len(r_sorted):
            while i < len_original[j]:
                f_salida.write(p)
                for r in r_sorted[j:]:
                    f_salida.write(";"+r+";"+str(out[p][r].pop()))
                f_salida.write("\n")
                i += 1
            j += 1

#        print "-------- DESPUES -----------"
#        for r in out[p]:
#            print "len(out["+p+"]["+r+"])="+str(len(out[p][r]))

    f_salida.close()


def creaFicheroMedidas(out):
    f_salida = open("salida.csv","w")
    f_salida.write("PUNTO,ROUTER,RSSI\n")

    for p in out:
        for r in out[p]:
            for rssi in out[p][r]:
                f_salida.write(p+","+r+","+str(rssi)+"\n")

    f_salida.close()

def creaFicheroUl():
    out = {}
    for f in ["../outputBLE1","../outputBLE2","../outputBLE3","../outputBLE4","../outputBLE5"]:
        out[f.replace("../output","")] = readUlFrom(f)

    f_salida = open("medidas_bluetooth_ul.txt","w")
    
    for r in out:
        f_salida.write(r)
        for rssi in out[r]:
            f_salida.write(";"+str(rssi))
        f_salida.write("\n")

    f_salida.close()


def readUlFrom(fichero):
    routers = {}
    routers["BLE1"] = "74:DA:EA:B3:2F:4A"
    routers["BLE2"] = "74:DA:EA:B2:ED:76"
    routers["BLE3"] = "74:DA:EA:B4:22:18"
    routers["BLE4"] = "74:DA:EA:B4:3A:B3"
    routers["BLE5"] = "74:DA:EA:B4:26:96"
    out = []
    
    router = fichero.replace("../output","")
    
    with open(fichero, 'r') as f:
        fileOutput = f.readlines()

    try:
        
        for i in range(0, len(fileOutput), 2):
            mac = fileOutput[i].split()[1]
            
            if mac == routers[router]:
                out.append(float(fileOutput[i+1].split()[1]))


    except IndexError:
        pass
    
    
    return out



if __name__ == "__main__":
    out = {}
    for f in os.listdir("../Medidas"):
        if f != ".DS_Store": #carpeta creada por Mac
            out[f.replace("output_","")] = readFrom("../Medidas/"+f)

    creaFicheroMedidas(out)
    creaFicheroCalibracion(out)

    creaFicheroUl()









