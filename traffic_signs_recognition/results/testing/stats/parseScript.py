# -*- coding: utf-8 -*-
import os
directory = os.path.join("c:\\","Users\Joel Pires\Documents\projs\\rp\myproject\\results\\testing\stats\\")
with open("master.csv",'w') as fid:
    fid.write("cenário, dataset, normalização, features selection, kruskal threshold, correlation threshold, feature reduction method, classifier, pca criteria, criteria threshold, precision, accuracy, prevalence, specificity, sensitivity, F Measure" + '\n')
    for root,dirs,files in os.walk(directory):
        for file in files:
            if file.endswith(".txt"):
                f=open(file, 'r')
                aux = os.path.join(root,file)
                temp = aux.split('_')
                finalString = temp[0][-1] + ' , ' + temp[1] + ' , ' + temp[2] + ' , ' + temp[3] + ' , ' + temp[4] + ' , ' + temp[5] + ' , ' + temp[6] + ' , ' + temp[7] + ' , ' + temp[8] + ' , ' + temp[9]
                count = 1;
                for line in f:
                    if(count != 7 and count != 3):
                        temp = line.split(':')
                        finalString = finalString + ' , ' + temp[1].strip()
                    count += 1;
                finalString += '\n'
                fid.write(finalString)
            f.close()

fid.close()
