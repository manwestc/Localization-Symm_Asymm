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


def SVh( P, h, bw ):
    '''
        Experimental semivariogram for a single lag
        '''
    pd = squareform( pdist( P[:,:2] ) )
    N = pd.shape[0]
    Z = list()
    for i in range(N):
        for j in range(i+1,N):
            if( pd[i,j] >= h-bw )and( pd[i,j] <= h+bw ):
                Z.append( ( P[i,2] - P[j,2] )**2.0 )
    return np.sum( Z ) / ( 2.0 * len( Z ) )

def SV( P, hs, bw ):
    '''
        Experimental variogram for a collection of lags
        '''
    sv = list()
    for h in hs:
        sv.append( SVh( P, h, bw ) )
    sv = [ [ hs[i], sv[i] ] for i in range( len( hs ) ) if sv[i] > 0 ]
    return np.array( sv ).T

def C( P, h, bw ):
    '''
        Calculate the sill
        '''
    c0 = np.var( P[:,2] )
    if h == 0:
        return c0
    return c0 - SVh( P, h, bw )

def opt( fct, x, y, C0, parameterRange=None, meshSize=1000 ):
    if parameterRange == None:
        parameterRange = [ x[1], x[-1] ]
    mse = np.zeros( meshSize )
    a = np.linspace( parameterRange[0], parameterRange[1], meshSize )
    for i in range( meshSize ):
        mse[i] = np.mean( ( y - fct( x, a[i], C0 ) )**2.0 )
    return a[ mse.argmin() ]

def spherical( h, a, C0 ):
    '''
        Spherical model of the semivariogram
        '''
    # if h is a single digit
    if type(h) == np.float64:
        # calculate the spherical function
        if h <= a:
            return C0*( 1.5*h/a - 0.5*(h/a)**3.0 )
        else:
            return C0
    # if h is an iterable
    else:
        # calcualte the spherical function for all elements
        a = np.ones( h.size ) * a
        C0 = np.ones( h.size ) * C0
        return map( spherical, h, a, C0 )

def circular( h, a, C0 ):
    '''
        Spherical model of the semivariogram
        '''
    # if h is a single digit
    if type(h) == np.float64:
        # calculate the spherical function
        if h <= a:
            return C0*(1 - 2/math.pi * math.acos(h/a) +  math.sqrt(1-(h**2/a**2)))
        else:
            return C0
    # if h is an iterable
    else:
        # calcualte the spherical function for all elements
        a = np.ones( h.size ) * a
        C0 = np.ones( h.size ) * C0
        return map( circular, h, a, C0 )

def exponential( h, a, C0 ):
    '''
        Spherical model of the semivariogram
        '''
    r = 1.5
    # if h is a single digit
    if type(h) == np.float64:
        # calculate the gaussian function
        if h>0:
            return C0*(1-math.exp(-h/r))
        else :
            return 0
    
    # if h is an iterable
    else:
        # calcualte the spherical function for all elements
        a = np.ones( h.size ) * a
        C0 = np.ones( h.size ) * C0
        return map( exponential, h, a, C0 )

def gaussian( h, a, C0 ):
    '''
        Spherical model of the semivariogram
        '''
    r = 1.5
    # if h is a single digit
    if type(h) == np.float64:
        # calculate the gaussian function
        if h>0:
            return C0*(1-math.exp(-(h**2)/(r**2)))
        else :
            return 0
    # if h is an iterable
    else:
        # calcualte the spherical function for all elements
        a = np.ones( h.size ) * a
        C0 = np.ones( h.size ) * C0
        return map( gaussian, h, a, C0 )


def linear( h, a, C0 ):
    '''
        Spherical model of the semivariogram
        '''
    # if h is a single digit
    if type(h) == np.float64:
        # calculate the spherical function
        if h <= a:
            return C0*h/a
        else:
            return C0
    # if h is an iterable
    else:
        # calcualte the spherical function for all elements
        a = np.ones( h.size ) * a
        C0 = np.ones( h.size ) * C0
        return map( linear, h, a, C0 )


def cvmodel( P, model, hs, bw ):
    '''
        Input:  (P)      ndarray, data
        (model)  modeling function
        - spherical
        - exponential
        - gaussian
        (hs)     distances
        (bw)     bandwidth
        Output: (covfct) function modeling the covariance
        '''
    # calculate the semivariogram
    sv = SV( P, hs, bw )
    # calculate the sill
    C0 = C( P, hs[0], bw )
    # calculate the optimal parameters
    param = opt( model, sv[0], sv[1], C0 )
    # return a covariance function
    covfct = lambda h, a=param: C0 - model( h, a, C0 )
    return covfct

def krige_unique( P, covfct, u, N, mu):
    '''
        Input  (P)     ndarray, data
        (covfct) covariance function
        (u)     unsampled point
        (N)     number of neighboring
        points to consider
        (mu)    mean of the variable
        '''
    
    # distance between u and each data point in P
    d = np.sqrt( ( P[:,0]-u[0] )**2.0 + ( P[:,1]-u[1] )**2.0 )
    # add these distances to P
    P = np.vstack(( P.T, d )).T
    # sort P by these distances
    # take the first N of them
    P = P[d.argsort()[:N]]
    
    # apply the covariance model to the distances
    k = covfct( P[:,3] )
    # cast as a matrix
    k = np.matrix( k ).T
    
    # form a matrix of distances between existing data points
    K = squareform( pdist( P[:,:2] ) )
    # apply the covariance model to these distances
    K = covfct( K.ravel() )
    # re-cast as a NumPy array -- thanks M.L.
    K = np.array( K )
    # reshape into an array
    K = K.reshape(N,N)
    # cast as a matrix
    K = np.matrix( K )
    
    # calculate the kriging weights
    weights = np.linalg.inv( K ) * k
    weights = np.array( weights )
    
    # calculate the residuals
    residuals = P[:,2] - mu
    
    # calculate the estimation
    estimation = np.dot( weights.T, residuals ) + mu
    
    return float( estimation )


def krige(P,model,hs,bw,U,N):
    '''
        Input  (P)     ndarray, data
        (model) modeling function
        - spherical
        - exponential
        - gaussian
        (hs)    kriging distances
        (bw)    kriging bandwidth
        (U)     unsampled points
        (N)     number of neighboring
        points to consider
    '''
    # covariance function
    covfct = cvmodel( P, model, hs, bw )
    # mean of the variable
    mu = np.mean( P[:,2] )
    U = np.array(U)
    
    Z = np.zeros((U.shape[1],U.shape[2]))

    for i in range(U.shape[1]):
        for j in range(U.shape[2]):
            Z[i,j] = krige_unique(P, covfct, U[:,i,j], N, mu)

    return Z



def distEuclidea(punto,router):
    return math.sqrt(math.pow(punto[0]-router[0],2)+math.pow(punto[1]-router[1],2))

def test(fichero):
    # Coordenadas de los puntos de medida del entorno
    puntos = {}
    
    # Coordenadas de los routers del entorno
    routers = {}

# Coordenadas de demilitacion de cada zona.
    """
        4 tuplas (coordenadas):
            Primera: esquina superior izquierda
            Segunda: esquina superior derecha
            Tercera: esquina inferior derecha
            Cuarta: esquina inferior izquierda
    """
#    zonas = {}
#    zonas["A"]=[(0,0),(0,6.078),(9.504,6.078),(9.504,0)]
#    zonas["B"]=[(9.504,0),(9.504,1.244),(20.026,1.244),(20.026,0)]
#    zonas["C"]=[(20.026,0),(20.026,6.078),(28.738,6.078),(28.738,0)]
#    zonas["D"]=[(12.828,1.244),(12.828,6.078),(17.539,6.078),(17.539,1.244)]

    # Lista con la coordenada de cada punto
    coord_puntos = []
    
    # Distancias de cada router a cada punto de medida del entorno
    distancias = {}

    # Diccionario con los todos los valores de rssi para el caso base (propuesta original -> solo RANSAC). Dos claves: router y punto
    errores = {}
    
    num_datos = {}
    
    n_datos = 0

    # Diccionario con los todos los valores de rssi para el caso discretizado (propuesta RANSAC + spatial). Dos claves: router y punto
    errores_disc = {}

    # Longitud (en m) de cada eje
    y_max = 9.504
    x_max = 6.078
    #y_max=4
    #x_max=3

    # Fichero a leer
    try:
        f = open("DistanciasXY_puntos_beacons")
    except:
        sys.stderr.write("Error, no he podido abrir %s para lectura.\n" % fichero)
        sys.exit(1)

    '''
        num_punto,coord_x,coord_y
        ...
        num_punto,coord_x,coord_y
        
        nombre_router,coord_x,coord_y
    
    '''
    
    linea = f.readline()

    #Información de los puntos
    while not linea == "ROUTERS\n":
        splitted = linea.split(',')
        '''
            splitted[0] : nombre puntos
            splitted[1] : coordenada y
            splitted[2] : coordenada x
            
        '''
        
        puntos[int(splitted[0])] = (float(splitted[2]),float(splitted[1]))
    
        linea = f.readline()
    
    linea = f.readline()
    #Información de los routers
    while not linea == "":
        splitted = linea.split(',')
        '''
            splitted[0] : nombre router
            splitted[1] : coordenada x
            splitted[2] : coordenada y
            
            '''
        
        routers[splitted[0]] = (float(splitted[1]),float(splitted[2]))
        
        linea = f.readline()

    # Fichero a leer
    titleMap = "Error per m2"
    xAxisMap = ""
    yAxisMap = ""
    cMax = 4
    cMin = 0
    try:
        f = open("kriging/articulo/0x01")
    except:
        sys.stderr.write("Error, no he podido abrir %s para lectura.\n" % fichero)
        sys.exit(1)

    '''
        error1
    
        ...
    
        errorn
    
    '''
        
    linea = f.readline()
    i = 1
    #Información de los puntos
    while not linea == "":
        errores[i] = float(linea)
        i += 1
        linea = f.readline()


    #Error máximo
#max = np.array(errores).max()
    max2 = 2.5
    print "error máximo: "+str(max2)


    # make these smaller to increase the resolution
    dx, dy = 0.2, 0.2
    
    # generate 2 2d grids for the x & y bounds
    y, x = np.mgrid[slice(0, y_max+dy, dy),
                    slice(0, x_max+dx, dx)]
                    
    # bandwidth, plus or minus 0.5 meters
    bw = 0.15
    # lags in 0.5 meter increments from zero to 30
    hs = np.arange(0,5,bw)

    errores_por_punto = []
    coordenadas_punto = []

    for nombre in puntos:
        errores_por_punto.append(errores[nombre])
        coordenadas_punto.append(puntos[nombre])
        

#    print len(errores_por_punto)
#print len(coordenadas_punto)

    errores_por_punto = np.array(errores_por_punto).reshape((len(errores_por_punto),1))
    coordenadas_punto = np.array(coordenadas_punto).reshape((len(coordenadas_punto),2))
    coord_X = np.array(coordenadas_punto[:,0]).reshape((len(coordenadas_punto[:,0]),1))
    coord_Y = np.array(coordenadas_punto[:,1]).reshape((len(coordenadas_punto[:,1]),1))

    # part of our data set recording porosity
    P = np.hstack((coord_X,coord_Y,errores_por_punto))

#grid_z0 = griddata(coordenadas_punto, errores_por_punto, (x, y), method='cubic',fill_value=0)
    #grid_z0 = krige(P,gaussian,hs,bw,(x,y),9)
    grid_z0 = krige(P,gaussian,hs,bw,(x,y),15)

    fig = plt.figure()
    # Mapa de calor
    #ax = plt.subplot(1, 1, 1)
    
    ax = fig.add_subplot(111,projection='3d')
    zs = range(cMin,cMax,1)
    colmap = cm.ScalarMappable(cmap=cm.hsv)
    colmap.set_array(zs)

    yg = ax.scatter(grid_z0, zs, c=cm.hsv(zs/max(zs)), marker='o')
    cb = fig.colorbar(colmap)
    #errores2 = errores.values()

    #minVal = int(math.floor(min(errores2) ))
    #maxVal = int(math.ceil(max(errores2)  ))

    #plt.imshow(grid_z0, vmin=cMin, vmax=cMax,
    #           extent=[x.min(), x.max(), y.min(), y.max()],
    #           origin='lower',aspect='equal')
        
        
    # pintar zonas y nombres de puntos
#    ax.plot([0,0,9.504,9.504],[0,6.078,6.078,0],'k') # zona a
#    ax.plot([9.504,9.504,20.026,20.026],[0,1.244,1.244,0],'k') # zona b
#    ax.plot([20.026,20.026,28.738,28.738],[0,6.078,6.078,0],'k') # zona c
#    ax.plot([12.828,12.828,17.539,17.539],[1.244,6.078,6.078,1.244],'k') # zona d

    ax.plot(coord_X,coord_Y,'ro')

    for item in ([ax.title, ax.xaxis.label, ax.yaxis.label] + ax.get_xticklabels() + ax.get_yticklabels()):
        item.set_fontsize(20)

    font_prop = font_manager.FontProperties(size=20)
    #plt.clim(min,max)
    plt.title(titleMap,fontproperties=font_prop)
    plt.axis([0, x_max, 0, y_max])
    plt.xlabel(xAxisMap)
    plt.ylabel(yAxisMap)
    #plt.colorbar()
    #plt.tight_layout()
    #plt.savefig("Mapas de calor/"+nombre_routers[r]+"-original.eps",bbox_inches='tight')

    plt.show()

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

