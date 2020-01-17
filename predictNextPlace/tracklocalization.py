# -*- coding: utf-8 -*-
from __future__ import division
import gpxpy
import math
import gpxpy.gpx
import matplotlib.pyplot as mapplot
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from sklearn import metrics
from sklearn.datasets.samples_generator import make_blobs
from sklearn.preprocessing import StandardScaler
import numpy as np
from sklearn.cluster import KMeans
import os
from pandas import DataFrame
import time
import datetime

def main():

    # #############################################################################
    # READ ALL THE GPX FILES
    path = 'C:\Users\Joel Pires\Documents\projs\su\predictNextPlace\\train\\'
    directory = os.path.join("c:\\","Users\Joel Pires\Documents\projs\su\predictNextPlace\\train\\")
    X = []
    pts = []
    inside = 0
    firstTimestamp = 0
    for root,dirs,files in os.walk(directory):
        for file in files:
            if file.endswith(".gpx"):
                filename = path + file
                gpx = gpxpy.parse(open(filename, 'r'))
                for i in gpx.tracks:
                    for j in i.segments:
                        for k in j.points:
                            aux = time.mktime(k.time.timetuple())
                            if(datetime.datetime.fromtimestamp(int(aux)).weekday() < 8): #NAO SE TEM EM ATENÇÂO PONTOS QUE DIZEM RESPEITO AO FIM DE SEMANA
                                X.append(np.array([k.latitude, k.longitude]))
                                pts.append([k.latitude, k.longitude, k.time])

    elapsedTime = aux - firstTimestamp

    #TO know the number of weeks that we have to analyze
    n_weeks = int(math.ceil(elapsedTime/(60*60*24*7)))
    weekDuration = 60*60*24*5 #5 dias uteis
    dayDuration = 60*60*24 #5 dias uteis

    X = np.array(X)
    aux = np.array(pts)


    # #############################################################################
    # COMPUTE THE DBSCAN TO KNOW THE DIFFERENT LOCATIONS (STOPPING POINTS) VISITED IN EACH WEEK
    db = DBSCAN(eps=2.8e-5, min_samples=45).fit(X)              #TODO: Check the best values for the parameters
    core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
    core_samples_mask[db.core_sample_indices_] = True
    labels = db.labels_

    n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
    unique_labels = set(labels)
    colors = [plt.cm.Spectral(each) for each in np.linspace(0, 1, len(unique_labels))]


    # #############################################################################
    # VISUALIZE IN MATPLOTLIB

    for k, col in zip(unique_labels, colors):
        if k == -1:
            # Black used for noise.
            col = [0, 0, 0, 1]

        class_member_mask = (labels == k)

        xy = X[class_member_mask & core_samples_mask]
        plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
                 markeredgecolor='k', markersize=14)

        xy = X[class_member_mask & ~core_samples_mask]
        plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
                 markeredgecolor='k', markersize=1)
    plt.xlabel('Latitude')
    plt.ylabel('Longitude')
    plt.title('Identificados %d Clusters' % n_clusters_)
    plt.show()



    myClusters = []
    for k, col in zip(unique_labels, colors):
        count = 0
        for l in labels:
            if l == k:
                (pts[count]).append(l)
            count += 1
        class_member_mask = (labels == k)
        xy = aux[class_member_mask & core_samples_mask]
        myClusters.append(xy)

    clusterDescription = []
    #guardar o minimo e o maximo
    for i in myClusters:
        minLat = 10000000000
        minLon = 10000000000
        maxLat = -10000000000
        maxLon = -10000000000
        for g in i:
            if(g[0] < minLat):
                minLat = g[0]
            if(g[1] < minLon):
                minLon = g[1]
            if(g[0] > maxLat):
                maxLat = g[0]
            if(g[1] > maxLon):
                maxLon = g[1]
        clusterDescription.append([minLat, minLon, maxLat, maxLon])


    # #############################################################################
    # Determining entry and exit points

    #Pontos de entrada:
    #    -> primeiro ponto do cluster
    #    -> primeiro ponto do cluster a seguir ao ponto de saída


    enteringPoints = {}
    enteringPoints[-1] = []
    differentDays = {}
    differentDays[-1] = []
    for cl in range(0, n_clusters_):
        enteringPoints[cl] = []
        differentDays[cl] = []

    clusterInside = -2

    for point in pts:
        currCluster = point[3]

        #se for o primeiro ponto do cluster?
        if(len(enteringPoints[currCluster]) == 0):
            enteringPoints[currCluster].append(point)
            if(datetime.datetime.fromtimestamp(int(time.mktime(point[2].timetuple()))).weekday() not in differentDays[currCluster]):
                differentDays[currCluster].append(datetime.datetime.fromtimestamp(int(time.mktime(point[2].timetuple()))).weekday())
            clusterInside = currCluster

        #Entry Point!
        if(clusterInside != currCluster):
            if(datetime.datetime.fromtimestamp(int(time.mktime(point[2].timetuple()))).weekday() not in differentDays[currCluster]):
                differentDays[currCluster].append(datetime.datetime.fromtimestamp(int(time.mktime(point[2].timetuple()))).weekday())
            enteringPoints[currCluster].append(point)
            clusterInside = currCluster

    # #############################################################################
    # GETTING THE COORDINATES WITH A WINDOW SIZE OF 2

    spatioTemporalCoordstoPlot = {}
    spatioTemporalCoords = {}
    centroids = {}
    for i in range(0, n_clusters_):
        X = []

        for j in range(1, len(enteringPoints[i])):
            o1 = time.mktime(enteringPoints[i][j-1][2].timetuple())
            o2 = time.mktime(enteringPoints[i][j][2].timetuple())
            temp1 = datetime.datetime.fromtimestamp(int(o1))
            temp2 = datetime.datetime.fromtimestamp(int(o2))
            tempFinal1 = temp1.hour*60*60 - temp1.minute*60 - temp1.second
            tempFinal2 = temp2.hour*60*60 - temp2.minute*60 - temp2.second
            tempFinal1 = tempFinal1 + dayDuration*temp1.weekday()
            tempFinal2 = tempFinal2 + dayDuration*temp2.weekday()

            tempFinal1 = float(tempFinal1/60/60/24)
            tempFinal2 = float(tempFinal2/60/60/24)
            X.append(np.array([tempFinal1, tempFinal2]))

        X = np.array(X)
        spatioTemporalCoords[i] = X

        if(len(spatioTemporalCoords[i]) != 0):
            # #############################################################################
            # K-MEANS FOR EVERY LOCAL/Cluster

            kmeans = KMeans(init='k-means++', n_clusters=len(differentDays[i]))
            y_pred = kmeans.fit_predict(spatioTemporalCoords[i])     #m = 5
            centroids[i] = np.array(kmeans.cluster_centers_)
            plt.scatter(spatioTemporalCoords[i][:, 0], spatioTemporalCoords[i][:, 1], c=y_pred)
            plt.xlabel('Time of m (in seconds)')
            plt.ylabel('Time of m+1 (in seconds)')
            plt.xlim(0, 7)
            plt.ylim(0, 7)
            plt.title("Clusters for each day of the week. Local: " + str(i))
            plt.show()
            centers = np.array(kmeans.cluster_centers_)

            """
            Uncomment this part in order to visualize the centroids
            plt.title("Centroids of the clusters for each day of the week. Local: " + str(i))
            plt.scatter(centers[:, 0], centers[:, 1], marker="X", color="r")
            plt.show()
            """

    # #############################################################################
    # TESTAR
    path = 'C:\Users\Joel Pires\Documents\projs\su\predictNextPlace\\test\\'
    directory = os.path.join("c:\\","Users\Joel Pires\Documents\projs\su\predictNextPlace\\test\\")
    total = 0
    correct = 0
    for root,dirs,files in os.walk(directory):
        for file in files:
            if file.endswith(".gpx"):
                filename = path + file
                gpx = gpxpy.parse(open(filename, 'r'))
                for i in gpx.tracks:
                    for j in i.segments:
                        for k in j.points:
                            if(total != 0):
                                y = 0
                                target = -1
                                for g in clusterDescription:
                                    if( (clusterDescription[y][0] >= k.latitude and  k.latitude <= clusterDescription[y][2]) or (clusterDescription[y][1] >= k.longitude and k.longitude <= clusterDescription[y][3])):
                                        target = y
                                    y += 1

                                aux1 = time.mktime(tempor.time.timetuple())
                                aux2 = time.mktime(k.time.timetuple())
                                timestamp1 = datetime.datetime.fromtimestamp(aux1)
                                timestamp2 = datetime.datetime.fromtimestamp(aux2)
                                timestampFinal1 = timestamp1.hour*60*60 - timestamp1.minute*60 - timestamp1.second
                                timestampFinal2 = timestamp2.hour*60*60 - timestamp2.minute*60 - timestamp2.second
                                timestampFinal1 = timestampFinal1 + dayDuration*timestamp1.weekday()
                                timestampFinal2 = timestampFinal2 + dayDuration*timestamp2.weekday()
                                timestampFinal1 = float(timestampFinal1/60/60/24)
                                timestampFinal2 = float(timestampFinal2/60/60/24)


                                point = np.array([timestampFinal1, timestampFinal2])
                                min = 10000000000000
                                cluster = -1

                                for i in range(0, n_clusters_):
                                    if (i in centroids):
                                        for j in centroids[i]:
                                            dist = np.linalg.norm(point-j)
                                            if(dist < min):
                                                min = dist
                                                cluster = i

                                if (cluster == target):
                                    correct +=1

                            total += 1
                            tempor = k

    print("Percetage of Correctness: " +  str((correct/total)*100) + "%")

if __name__ == '__main__':
    main()
