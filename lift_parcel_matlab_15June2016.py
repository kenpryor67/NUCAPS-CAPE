#!/usr/bin/env python
#python 2.7

# lift_parcel_matlab_21ug2015.py
#
# this python script reads csv files in spc format and create a profile object
# then prints out csv files with the CAPE and CIN values for each file 

# revised: 21 Aug2015 GP to use parcelx instead of cape function.


from StringIO import StringIO
import sharppy.sharptab.profile as profile
import urllib
import time as gmtime
import datetime
import sys
import glob
import numpy as np
import csv
import sharppy.sharptab as tab
from sharppy.sharptab.params import parcelx

files = glob.glob("p*.csv")
# loop over input files
for filename in files:
    print ('... reading file:  ' + filename)
    url = open(filename)
    data = np.array(url.read().split('\n'))
    title_idx = np.where( data == '%TITLE%')[0][0]
    start_idx = np.where( data == '%RAW%' )[0]
    finish_idx = np.where( data == '%END%')[0]
    plot_title = data[title_idx + 1]
    full_data = '\n'.join(data[start_idx : finish_idx][:])
    sound_data = StringIO( full_data )
    P, h, T, Td, wdir, wspd = np.genfromtxt( sound_data, delimiter=',', comments="%", unpack=True )
    prof = profile.create_profile( pres=P, hght=h, tmpc=T, dwpc=Td, wdir=wdir, wspd=wspd )
    pcl = parcelx(prof)
    sfcpcl = tab.params.parcelx( prof, flag=1 ) #Surface Parcel
    fcstpcl = tab.params.parcelx( prof, flag=2 ) #Forecast Parcel
    mupcl = tab.params.parcelx( prof, flag=3 ) #Most-Unstable Parcel
    mlpcl = tab.params.parcelx( prof, flag=4 ) #100 mb Mean Layer Parcel
    
    csvfile = open(('Lift_Parcel_' + filename [:-4] + '.txt'), 'wb')
    writer = csv.writer(csvfile, delimiter=' ')
    writer.writerow([plot_title])
    writer.writerow('\r')
    loop_idx = range(1)
    for idx in loop_idx:
        a = [('Surface CAPE = ' + str(sfcpcl.bplus))] #J/Kg
        writer.writerow(a)
        b = [('Surface CIN = ' + str(sfcpcl.bminus))] #J/Kg
        writer.writerow(b)
        c = [('Surface LCL = ' + str(sfcpcl.lclhght))] #meters AGL
        writer.writerow(c)
        d = [('Surface LFC = ' + str(sfcpcl.lfchght))] #meters AGL
        writer.writerow(d)
        e = [('Surface EL = ' + str(sfcpcl.elhght))] #meters AGL
        writer.writerow(e)
        f = [('Surface LI = ' + str(sfcpcl.li5))] # C
        writer.writerow(f)
        writer.writerow('\r')

        g = [('Forecast CAPE = ' + str(fcstpcl.bplus))]
        writer.writerow(g)
        h = [('Forecast CIN = ' + str(fcstpcl.bminus))]
        writer.writerow(h)
        i = [('Forecast LCL = ' + str(fcstpcl.lclhght))]
        writer.writerow(i)
        j = [('Forecast LFC = ' + str(fcstpcl.lfchght))]
        writer.writerow(j)
        k = [('Forecast EL = ' + str(fcstpcl.elhght))]
        writer.writerow(k)
        l = [('Forecast LI = ' + str(fcstpcl.li5))]
        writer.writerow(l)
        writer.writerow('\r')

        m = [('Most-Unstable CAPE = ' + str(mupcl.bplus))]
        writer.writerow(m)
        n = [('Most-Unstable CIN = ' + str(mupcl.bminus))]
        writer.writerow(n)
        o = [('Most-Unstable LCL = ' + str(mupcl.lclhght))]
        writer.writerow(o)
        p = [('Most-Unstable LFC = ' + str(mupcl.lfchght))]
        writer.writerow(p)
        q = [('Most-Unstable EL = ' + str(mupcl.elhght))]
        writer.writerow(q)
        r = [('Most-Unstable LI = ' + str(mupcl.li5))]
        writer.writerow(r)
        writer.writerow('\r' )

        s = [('Mean Layer CAPE = ' + str(mlpcl.bplus))]
        writer.writerow(s)
        t = [('Mean Layer CIN = ' + str(mlpcl.bminus))]
        writer.writerow(t)
        u = [('Mean Layer LCL = ' + str(mlpcl.lclhght))]
        writer.writerow(u)
        v = [('Mean Layer LFC = ' + str(mlpcl.lfchght))]
        writer.writerow(v)
        w = [('Mean Layer EL = ' + str(mlpcl.elhght))]
        writer.writerow(w)
        x = [('Mean Layer LI = ' + str(mlpcl.li5))]
        writer.writerow(x)
    csvfile.close()

