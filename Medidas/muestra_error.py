# -*- coding: utf-8 -*-

import math
import sys
from optparse import OptionParser
import numpy as np
import numpy.random
import matplotlib.pyplot as plt
import matplotlib as m
from scipy.interpolate import griddata
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from matplotlib import cm
import matplotlib.font_manager as font_manager
from pandas import DataFrame, Series
from scipy.spatial.distance import pdist, squareform
import matplotlib.patches as mpatches
import warnings


def distEuclidea(punto,router):
    return math.sqrt(math.pow(punto[0]-router[0],2)+math.pow(punto[1]-router[1],2))

def test(fichero):
    # Número de datos por cada zona
    num_datos = {}
    
    # Número de datos totales
    n_datos = 0
    
    # Coordenadas de los puntos ordenadas según el camino
    coordenadas = []
    
    # Errores de cada punto ordenados según el camino
    error = []
    
    # Errores medios por zona
    error_por_zona = {}
    
    # Zonas de paso ordenadas según el camino
    zonas = []
    
    # Lista de tuplas que indica el punto inicial y final (según el orden del punto según el camino) de cada zona. Es decir, si la zona A empieza en el punto 1 y termina en el 65 y la B empieza en el 65
    # y termina en el 120, esta lista será: [(1,65),(64,120)]
    puntos_zonas = []
    
    # Colores en los que se pintará cada zona
    colores = {}
    colores["A"] = 'green'
    colores["B"] = 'blue'
    colores["C"] = 'red'
    colores["D"] = 'yellow'

    # Fichero a leer
    try:
        f = open(fichero)
    except:
        sys.stderr.write("Error, no he podido abrir %s para lectura.\n" % fichero)
        sys.exit(1)

    '''
    /** ESTRUCTURA DEL FICHERO
        FECHA
        PARTÍCULAS;NUM_PARTICULAS
        SUAVIZADO;TRUE/FALSE
        COORDENADA_REAL;ZONA_COORDENADA_REAL;COORDENADA_PREDICHA;ERROR_ABSOLUTO
        ...
        ERROR_EUCLIDEO_MEDIO;valor
    */
    '''
        
    f.readline() # FECHA
    f.readline() # Número partículas
    f.readline() # Suavizado
    f.readline() # COORDENADA_REAL;ZONA_COORDENADA_REAL;COORDENADA_PREDICHA;ERROR_ABSOLUTO
    linea = f.readline()
    
    indices_punto = []
    i = 1
    zona_aux = "A"
    indice_aux = 1

    #Información de los routers
    while not linea.split(';')[0] == "ERROR_EUCLIDEO_MEDIO":
        splitted = linea.split(';')
        '''
            splitted[0] : coordenada real (tupla)
            splitted[1] : zona coordenada real
            splitted[2] : coordenada predicha (tupla)
            splitted[3] : error
        '''
        
        coordenada_real = eval(splitted[0]) # convertimos string a tupla
        zona = splitted[1]

        if not zona in error_por_zona:
            error_por_zona[zona] = []

        error_por_zona[zona].append(float(splitted[3]))

        if zona_aux != zona:
            puntos_zonas.append((indice_aux,i))
            zonas.append(zona_aux)
            indice_aux = i-1
            zona_aux = zona

        coordenadas.append(coordenada_real)
        error.append(float(splitted[3]))
        indices_punto.append(i)
        i += 1
        n_datos += 1
        
        linea = f.readline()
    
    # Para pintar la última zona
    puntos_zonas.append((indice_aux,i))
    zonas.append(zona_aux)

    for zona in error_por_zona:
        error_por_zona[zona] = np.array(error_por_zona[zona]).mean()
        print "Error medio de la zona "+zona+": "+str(error_por_zona[zona])

    #Error máximo
    max = np.array(error).max()
    
    #Gráfico de línea
    warnings.filterwarnings("ignore", module="matplotlib") #para ignorar los warnings
    fig = plt.figure()
    ax = plt.subplot(1, 1, 1)
    ax.plot(indices_punto,error)
    
    #Pintar las zonas
    for i in range(len(puntos_zonas)):
        indices = puntos_zonas[i]
        zona = zonas[i]
        ax.fill_between(range(indices[0],indices[1]), error[indices[0]-1:indices[1]-1],facecolor = colores[zona])
    

    for item in ([ax.title, ax.xaxis.label, ax.yaxis.label] + ax.get_xticklabels() + ax.get_yticklabels()):
        item.set_fontsize(20)

    #Creación de la leyenda
    colores_leyenda = []
    etiquetas_leyenda = []
    for zona in sorted(colores):
        colores_leyenda.append(mpatches.Rectangle((0,0),1,1,fc=colores[zona]))
        etiquetas_leyenda.append("Zona "+zona)
                       
    font_prop = font_manager.FontProperties(size=20)
    plt.title(fichero.replace('.csv',''))#,fontproperties=font_prop)
    plt.legend(colores_leyenda,etiquetas_leyenda)

    plt.axis([1, n_datos, 0, 14])
    plt.xlabel("Numero de punto")
    plt.ylabel("Error")
    plt.tight_layout()

    plt.show()
    
    
    
    
    
    
    
    
    #Cálculo del error máximo
#    for coord in errores:
#        error = errores[coord]
#        if error > max:
#            max = error
#
#    print "error máximo: "+str(max)
#    print "número de medidas: "+str(n_datos)
#
#    max = 13.5
#    # make these smaller to increase the resolution
#    dx, dy = 0.25, 0.1
#    
#    # generate 2 2d grids for the x & y bounds
#    y, x = np.mgrid[slice(0, y_max+dy, dy),
#                    slice(0, x_max+dx, dx)]
#                    
#    # bandwidth, plus or minus 0.5 meters
#    bw = 0.5
#    # lags in 0.5 meter increments from zero to 30
#    hs = np.arange(0,30,bw)
#
#    errores_por_punto = []
#    coordenadas_punto = []
#
#    for coord in errores:
#        errores_por_punto.append(errores[coord])
#        coordenadas_punto.append(coord)
#        
#
##    print errores_por_punto
##    print coordenadas_punto
#
#    errores_por_punto = np.array(errores_por_punto).reshape((len(errores_por_punto),1))
#    coordenadas_punto = np.array(coordenadas_punto)
#    coord_X = np.array(coordenadas_punto[:,0]).reshape((len(coordenadas_punto[:,0]),1))
#    coord_Y = np.array(coordenadas_punto[:,1]).reshape((len(coordenadas_punto[:,1]),1))
#
#
#    # part of our data set recording porosity
#    P = np.hstack((coord_X,coord_Y,errores_por_punto))
#
#    #grid_z0 = griddata(coordenadas_punto, errores_por_punto, (x, y), method='cubic',fill_value=0)
#    grid_z0 = krige(P,spherical,hs,bw,(x,y),5)
#    
#    fig = plt.figure()
#    # Mapa de calor
#    ax = plt.subplot(1, 1, 1)
#    plt.imshow(grid_z0, vmin=0, vmax=max,
#               extent=[x.min(), x.max(), y.min(), y.max()],
#               origin='lower',aspect=2)
#        
#        
#    # pintar zonas y nombres de puntos
#    ax.plot([0,0,9.504,9.504],[0,6.078,6.078,0],'k') # zona a
#    ax.plot([9.504,9.504,20.026,20.026],[0,1.244,1.244,0],'k') # zona b
#    ax.plot([20.026,20.026,28.738,28.738],[0,6.078,6.078,0],'k') # zona c
#    ax.plot([12.828,12.828,17.539,17.539],[1.244,6.078,6.078,1.244],'k') # zona d
#
#    ax.plot(coord_X,coord_Y,'ro')
#
#    for item in ([ax.title, ax.xaxis.label, ax.yaxis.label] + ax.get_xticklabels() + ax.get_yticklabels()):
#        item.set_fontsize(20)
#
#    font_prop = font_manager.FontProperties(size=20)
#    #plt.clim(min,max)
#    plt.title("Mapa de calor",fontproperties=font_prop)
#    plt.axis([0, x_max, 0, y_max])
#    plt.xlabel('X-axis')
#    plt.ylabel('Y-axis')
#    plt.colorbar()
#    plt.tight_layout()
    #plt.savefig("Mapas de calor/"+nombre_routers[r]+"-original.eps",bbox_inches='tight')

#    plt.show()

"""
    Obtiene el mapa de calor con n-total (original) y n-discretizada.
    
    Entradas:
        - coord_x, coord_y : grids con las coordenadas en el eje x y en el eje y
                coord_y, coord_x = np.mgrid[slice(y_min, y_max, dy), slice(x_min, x_max, dx)]
        - errores_por_punto: diccionario con el error cuadrático medio de cada punto. Clave: punto
        - puntos: diccionario con las coordenadas de cada punto. Clave: punto
        
    Salidas:
        - error_total: grid con los valores del error cuadrático medio con n-total de cada punto establecidos en su coordenada.
        - error_discretizado: idem que error_total pero con n-discretizada.
"""
def coloca_error(coord_x,coord_y,errores_por_punto,puntos):
    error_total = np.full((coord_x.shape[0]-1,coord_x.shape[1]-1), np.inf)
    error_discretizado = np.full((coord_x.shape[0]-1,coord_x.shape[1]-1), np.inf)
    coord_celdas = {}
    
    for i in range(coord_x.shape[0]-1):
        if not coord_celdas.has_key(i):
            coord_celdas[i]={}
        for j in range(coord_x.shape[1]-1):
            if not coord_celdas[i].has_key(j):
                coord_celdas[i][j] = []
            coord_celdas[i][j].append((coord_x[i+1,j],coord_y[i+1,j])) # esquina superior izqda
            coord_celdas[i][j].append((coord_x[i+1,j+1],coord_y[i+1,j+1])) # esquina superior dcha
            coord_celdas[i][j].append((coord_x[i,j+1],coord_y[i,j+1])) # esquina inferior dcha
            coord_celdas[i][j].append((coord_x[i,j],coord_y[i,j])) # esquina inferior izqda


    for p in errores_por_punto:
        (i,j) = get_celda(coord_celdas,puntos[p])
        error_total[i][j] = errores_por_punto[p]["n-total"]
        error_discretizado[i][j] = errores_por_punto[p]["n-discretizada"]

    return error_total, error_discretizado

"""
    Obtiene la celda del punto pasado como parámetro
    
    Entradas:
        - coord_celdas: diccionario con la coordenada de cada celda. Clave: número de celda en el eje x y número de celda en el eje y
        - punto: coordenada del punto
        
    Salidas:
        - i : índice en el eje x de la celda del punto
        - j : índice en el eje y de la celda del punto
"""
def get_celda(coord_celdas,punto):
    for i in coord_celdas:
        for j in coord_celdas[i]:
            if punto_en_poligono(punto,coord_celdas[i][j]):
                return (i,j)
    return None

def punto_en_poligono(punto, poligono):
    """
        Comprueba si un punto se encuentra dentro de un poligono
        
        Entradas:
        punto - tupla con la coordenada del punto
        poligono - Lista de tuplas con los puntos que forman los vertices [(x1, x2), (x2, y2), ..., (xn, yn)] del polígono
        
        Salidas:
        salida - True si el punto pertenece a la zona o False si no
        
        https://sakseiw.wordpress.com/2013/10/04/punto-dentro-de-poligono/
        """
    i = 0
    j = len(poligono) - 1
    salida = False
    for i in range(len(poligono)):
        try:
            if (poligono[i][1] < punto[1] and poligono[j][1] >= punto[1]) or (poligono[j][1] < punto[1] and poligono[i][1] >= punto[1]):
                if poligono[i][0] + (punto[1] - poligono[i][1]) / (poligono[j][1] - poligono[i][1]) * (poligono[j][0] - poligono[i][0]) < punto[0]:
                    salida = not salida
        except:
            print poligono
            print punto
        j = i
    return salida

"""
    Obtiene el error cuadrático máximo y mínimo
    
    Entrada:  
        - errores_por_punto: diccionario con el error cuadrático medio de cada punto con n-total y n-discretizada. Claves: punto y "n-total" o "n-discretizada"
        
    Salida:
        - max: error cuadrático medio máximo (de entre todos los valores, es decir, de n-total y n-discretizada)
        - min: error cuadrático medio mínimo
"""
def get_max_min(errores_por_punto):
    max, min = 0, float("inf")

    for p in errores_por_punto:
        if errores_por_punto[p]["n-total"] < min:
            min = errores_por_punto[p]["n-total"]

        if errores_por_punto[p]["n-discretizada"] < min:
            min = errores_por_punto[p]["n-discretizada"]

        if errores_por_punto[p]["n-total"] > max:
            max = errores_por_punto[p]["n-total"]
        
        if errores_por_punto[p]["n-discretizada"] > max:
            max = errores_por_punto[p]["n-discretizada"]
    

    return max,min

def get_valor(punto,errores_por_punto,puntos,umbral):
    puntos_a_distancia = []
    pesos = []
    distancia_total = 0
    pesos_total = 0
    valor_total = 0
    valor_discretizado = 0
    aux = 0
    
    for p in puntos:
        distancia = distEuclidea(punto,puntos[p])
        if distancia <= umbral:
            puntos_a_distancia.append((p,distancia))
            distancia_total += distancia
    
    for (p,dist) in puntos_a_distancia:
        peso = (1-dist/distancia_total)
        pesos_total += peso
        pesos.append((p,peso))

    for (p,peso) in pesos:
        valor_total += (errores_por_punto[p]["n-total"]*peso)
        valor_discretizado += (errores_por_punto[p]["n-discretizada"]*peso)

#return valor_total/distancia_total, valor_discretizado/distancia_total
    return valor_total/pesos_total,valor_discretizado/pesos_total

if __name__=='__main__':
    parser= OptionParser(usage="%prog -f <fichero>")
    parser.add_option("-f", "--fichero", action="store", dest="fichero", metavar="<fichero>",default="Errores RANSAC/errores-exp4-2.csv",
                          help= "Lee los datos desde el fichero. Por defecto utiliza el fichero Errores RANSAC/errores-exp4-2.csv")

    (opciones, args)= parser.parse_args()
    
    test(opciones.fichero)

