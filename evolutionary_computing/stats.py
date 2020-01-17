#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
. This file contains functions in order to suport the statistical analysis of the problem
. Joel Pires & André Clemêncio, May 2018
"""

import matplotlib.pyplot as plt
import pandas as pd
from scipy import stats
from pylab import figure, axes, pie, title, show
from scipy.stats import *
import statsmodels.sandbox.stats.multicomp as smm
import numpy as np


"""
Function responsible to do all the statistical report. It provides a basic statistical
description of the samples (stored in "describeData.txt" in the folder "statisticFiles"), a boxplot (stored in the folder "images")
and eight histograms correspondant to the four parent's selectionmethods (with and without the norm distribution curve in it - stored in the folder "images").
It includes: a Komolgorov-Smirnov test, a Shapiro-Wilk test, a Levene test, six Mann-Whitney tests and the Bonferroni correction.
All these statistics will be stored in a text file called "statisticalReport.txt" inside the "statisticFiles" folder.
It needs access to the files inside the "testFiles" folder.
Inputs: none
Outputs: none
"""
def statisticalReport():
	tour10, tour50, roulette, sus = parse_files()
	labels = ["tour10", "tour50", "roulette", "sus"]
	data = get_data("testFiles/tsp_diversity.txt")

	descriptiveData(data,1)

	#DESCRIBING THE DATA -------------------------------------------------------------------------------
	box_plot(data, labels)

	histogram(tour10, 'tour10', "Histograma do (Torneio 10)", "Diversity", "Frequencia")
	histogram(tour50, 'tour50', "Histograma do (Torneio 50)", "Diversity", "Frequencia")
	histogram(roulette, 'roulette', "Histograma do (Roulette)", "Diversity", "Frequencia")
	histogram(sus, 'sus', "Histograma do (SUS)", "Diversity", "Frequencia")

	histogram_norm(tour10, 'tour10', "Histograma Normalizado (Torneio 10)", "Diversity", "Frequencia")
	histogram_norm(tour50, 'tour50', "Histograma Normalizado (Torneio 50)", "Diversity", "Frequencia")
	histogram_norm(roulette, 'roulette', "Histograma Normalizado (Roulette)", "Diversity", "Frequencia")
	histogram_norm(sus, 'sus', "Histograma Normalizado (SUS)", "Diversity", "Frequencia")

	#NORMALITY TEST -------------------------------------------------------------------------------
	norm_data1 = (tour10 - np.mean(tour10))/(np.std(tour10)/np.sqrt(len(tour10)))
	norm_data2 = (tour50 - np.mean(tour50))/(np.std(tour50)/np.sqrt(len(tour50)))
	norm_data3 = (roulette - np.mean(roulette))/(np.std(roulette)/np.sqrt(len(roulette)))
	norm_data4 = (sus - np.mean(sus))/(np.std(sus)/np.sqrt(len(sus)))

	ksResults1 = kstest(norm_data1, cdf='norm')
	ksResults2 = kstest(norm_data2, cdf='norm')
	ksResults3 = kstest(norm_data3, cdf='norm')
	ksResults4 = kstest(norm_data4, cdf='norm')
	shapiroResults1 = shapiro(norm_data1)
	shapiroResults2 = shapiro(norm_data2)
	shapiroResults3 = shapiro(norm_data3)
	shapiroResults4 = shapiro(norm_data4)

    #HOMOGENEITY TEST -------------------------------------------------------------------------------
	homogeneityResults = levene(tour10, tour50, roulette, sus, center='median')

    #NON-PARAMETRIC KRUSKAL-TEST -------------------------------------------------------------------------------
	kruskalResults = kruskal(tour10, tour50, roulette, sus)

    #NON-PARAMETRIC - MANN WHITNEY TESTING -------------------------------------------------------------------------------
	tour10vs50 = mannwhitneyu(tour50, tour10,  alternative='less')
	tour10vsRoulette = mannwhitneyu(roulette,tour10,  alternative='greater')
	tour10vsSus = mannwhitneyu(sus, tour10,  alternative='greater')
	tour50vsRoulette = mannwhitneyu(roulette, tour50,  alternative='greater') #useless
	tour50vsSus = mannwhitneyu( sus, tour50, alternative='greater') #useless
	RoulettevsSus = mannwhitneyu(sus, roulette,  alternative='less')

    #BONFERRONI CORRECTION -------------------------------------------------------------------------------
	p_values = [tour10vs50[1], tour10vsRoulette[1], tour10vsSus[1], tour50vsRoulette[1], tour50vsSus[1], RoulettevsSus[1]]
	p_values_corrected = bonferroni(p_values)

    #WRITE THE STATISTICAL REPORT TO A FILE -------------------------------------------------------------------------------
	with open("statisticFiles/statisticalReport.txt", 'w') as f:
		f.write("-------------- KS RESULTS --------------\n")
		f.write("testResult (tour10): " + str(ksResults1[0]) + '\n')
		f.write("p-value (tour10): " + str(ksResults1[1]) + '\n')
		f.write("testResult (tour50): " + str(ksResults2[0]) + '\n')
		f.write("p-value (tour50): " + str(ksResults2[1]) + '\n')
		f.write("testResult (roulette): " + str(ksResults3[0]) + '\n')
		f.write("p-value (roulette): " + str(ksResults3[1]) + '\n')
		f.write("testResult (sus): " + str(ksResults4[0]) + '\n')
		f.write("p-value (sus): " + str(ksResults4[1]) + '\n')
		f.write("\n------------ SHAPIRO RESULTS -----------\n")
		f.write("testResult (tour10): " + str(shapiroResults1[0]) + '\n')
		f.write("p-value (tour10): " + str(shapiroResults1[1]) + '\n')
		f.write("testResult (tour50): " + str(shapiroResults2[0]) + '\n')
		f.write("p-value (tour50): " + str(shapiroResults2[1]) + '\n')
		f.write("testResult (roulette): " + str(shapiroResults3[0]) + '\n')
		f.write("p-value (roulette): " + str(shapiroResults3[1]) + '\n')
		f.write("testResult (sus): " + str(shapiroResults4[0]) + '\n')
		f.write("p-value (sus): " + str(shapiroResults4[1]) + '\n')
		f.write("\n---------- HOMOGENEITY RESULTS --------\n")
		f.write("testResult: " + str(homogeneityResults[0]) + '\n')
		f.write("p-value: " + str(homogeneityResults[1]) + '\n')
		f.write("\n------------ KRUSKAL RESULTS ----------\n")
		f.write("testResult: " + str(kruskalResults[0]) + '\n')
		f.write("p-value: " + str(kruskalResults[1]) + '\n')
		f.write("\n--------- MANN WHITNEY RESULTS --------\n")
		f.write("\n# tour10 vs tour50 #\n")
		f.write("testResult: " + str(tour10vs50[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][0]) + '\n')
		f.write("\n# tour10 vs roulette #\n")
		f.write("testResult: " + str(tour10vsRoulette[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][1]) + '\n')
		f.write("\n# tour10 vs Sus #\n")
		f.write("testResult: " + str(tour10vsSus[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][2]) + '\n')
		f.write("\n# tour50 vs roulette #\n")
		f.write("testResult: " + str(tour50vsRoulette[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][3]) + '\n')
		f.write("\n# tour50 vs Sus #\n")
		f.write("testResult: " + str(tour50vsSus[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][4]) + '\n')
		f.write("\n# Roulette vs Sus #\n")
		f.write("testResult: " + str(RoulettevsSus[0]) + '\n')
		f.write("p-value: " + str(p_values_corrected[1][5]) + '\n')

	f.close()

"""
Function that executes de Bonferroni Correction
Inputs: p_values, alpha
Outputs: none
"""
def bonferroni(p_values, alpha=0.05):
    return multiple_comparisons(p_values,alpha,'b')


"""
Auxiliary function to execute the Bonferroni Correction
Inputs: p_values, alpha, method
Outputs: none
"""
def multiple_comparisons(p_values,alpha, method):
    return smm.multipletests(p_values,alpha,method)

"""
It generates an histogram of the data that's inserted as an input.
Doesn't show the figure, it stores inside the folder "images" instead.
Inputs: data,dataname, title,xlabel,ylabel,bins
Outputs: none
"""
def histogram(data,dataname, title,xlabel,ylabel,bins=25):
	plt.close()
	plt.hist(data,bins=bins)
	plt.title(title)
	plt.xlabel(xlabel)
	plt.ylabel(ylabel)
	plt.savefig("images/" + dataname + "Histogram.png")

"""
It generates an histogram of the data that's inserted as an input with the norm distribution in it.
Doesn't show the figure, it stores inside the folder "images" instead.
Inputs: data,dataname, title,xlabel,ylabel,bins
Outputs: none
"""
def histogram_norm(data,dataname, title,xlabel,ylabel,bins=20):
	plt.close()
	plt.hist(data,normed=1,bins=bins)
	plt.title(title)
	plt.xlabel(xlabel)
	plt.ylabel(ylabel)
	min_,max_,mean_,median_,mode_,var_,std_ = descriptiveData(data, 0)
	x = np.linspace(min_,max_,1000)
	pdf = norm.pdf(x,mean_,std_)
	plt.plot(x,pdf,'r')
	plt.savefig("images/" + dataname + "HistogramNorm.png")


"""
Receives the multiple samples stored in form of a list of lists and generates basic descriptive statistics.
If the flag is equal to one -> it stores the statistics into a file called "describeData.txt" inside the folder "statisticFiles". Otherwise, don't.
Inputs: data
Outputs: flag
"""
def descriptiveData(data, flag):
	min_ = np.amin(data)
	max_ = np.amax(data)
	mean_ = np.mean(data)
	median_ = np.median(data)
	mode_ = mode(data)
	std_ = np.std(data)
	var_ = np.var(data)

	if flag == 1:
		skew_ = skew(data)
		kurtosis_ = kurtosis(data)
		q_25, q_50, q_75 = np.percentile(data, [25,50,75])
		all = 'Min: '+ str(min_) +  '\nMax: ' + str(max_) + '\nMean: ' + str(mean_) + '\nMedian: ' + str(median_) + '\nMode: ' + str(mode_[0][0]) + '\nVar: ' + str(std_) + '\nStd: ' + str(var_) + '\nSkew: ' + str(skew_) + '\nKurtosis: ' + str(kurtosis_) + '\nQ25: ' + str(q_25) + '\nQ50: ' + str(q_50) + '\nQ75: ' + str(q_75) + '\n'

		filename = "statisticFiles/describeData.txt"
		with open(filename, 'w') as f:
			f.write(all)
		f.close()

	return (min_,max_,mean_,median_,mode_,var_,std_)

"""
Based multi-collumn samples, it generates the respective boxplot
Inputs: data, label
Outputs: none
"""
def box_plot(data, labels):
	plt.close()
	plt.boxplot(data,labels=labels)
	plt.savefig("images/distributionValues.png")


"""
Reads a text file containing multiple collumns samples and converts them into a list of lists.
Inputs: filename
Outputs: data
"""
def get_data(filename):
    data = np.loadtxt(filename)
    return data


"""
This function reads the text files correspondant to the results of the tests made with
the four different parent's selection methods and stores them in 4 differente variables.
Inputs: none
Outputs: tour10, tour50, roulette, sus
"""
def parse_files():
	with open("testFiles/tsp_tour10_diversity.txt") as f:
	    tour10 = f.readlines()
	f.close()
	with open("testFiles/tsp_tour50_diversity.txt") as f:
	    tour50 = f.readlines()
	f.close()
	with open("testFiles/tsp_roulette_diversity.txt") as f:
	    roulette = f.readlines()
	f.close()
	with open("testFiles/tsp_sus_diversity.txt") as f:
	    sus = f.readlines()
	f.close()

	tour10 = [float(x.strip()) for x in tour10]
	tour50 = [float(x.strip()) for x in tour50]
	roulette = [float(x.strip()) for x in roulette]
	sus = [float(x.strip()) for x in sus]
	all = ""
	with open("testFiles/tsp_diversity.txt", 'w') as f:
		for i in range(len(tour10)):
			f.write(str(tour10[i]) + "	" + str(tour50[i]) + "	" + str(roulette[i]) + "	" + str(sus[i]) + "\n")

	return (tour10, tour50, roulette, sus)
