#! /usr/bin/env python
# -*- coding: utf-8 -*-
from tsp import *
import time
from stats import *

"""
. This scripts serves the purpose of doing the necessary tests for the experiment.
. It wil run by default 120 times the TSP benchmarking problem

. Each algorithm to solve the TSP problem will have 3 different versions that'll be runned 30 times each. Each version varies in the parent's selection method as it follows:
    -> tournament Selection
    -> roullete Selection
    -> Stochastic Universal Sampling

. This scripts also store in text files and png images the following quality measures:
    -> performance (the best individual and the averages of the bests)
    -> diversity (average of the hamming distances)

. Joel Pires & André Clemêncio, May 2018
"""

if __name__ == '__main__':

    #CONTROL VARIABLES
    numb_generations = 250
    size_pop = 70
    prob_mut = 0.05
    prob_cross = 0.75
    k_tour = 3
    k_elite = 0.1
    recombination = order_cross
    mutation = muta_cromo
    sel_survivors = sel_survivors_elite(k_elite)
    metric = hamming_distance

    #NUMBER OF RUNS
    numb_runs = 30

    #REPRESENTATION OF THE PROBLEM
    coord = le_coordenadas_tsp('zi929.tsp')
    dicio = dicio_cidades(coord)
    meu_merito = merito(dicio)
    fitness_func = meu_merito
    size_cromo = len(dicio)

    #RUN THIS IF YOU WANT TO DO THE 30 RUNS AND WRITE THE RESULTS TO FILES -----------------------------------------------------------------------
    #run_for_file("tsp_tour10",numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,tour_sel(10),recombination,mutation,sel_survivors, fitness_func, metric)
    #run_for_file("tsp_tour50",numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,tour_sel(50),recombination,mutation,sel_survivors, fitness_func, metric)
    #run_for_file("tsp_roulette", numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,roulette(),recombination,mutation,sel_survivors, fitness_func, metric)
    #run_for_file("tsp_sus", numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,sus(),recombination,mutation,sel_survivors, fitness_func, metric)
    #STATISTICAL ANALYSIS----------------------------------------------------------------------------
    statisticalReport()

    """
    #RUN THIS IF YOU WANT TO RUN THE PROJECT AND JUST VISUALIZE THE RESULTS ----------------------------------------------------------------------------
    bests,average_bests, diversity = run(numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,tour_sel(k_tour),recombination,mutation,sel_survivors, fitness_func, metric)
    bests,average_bests, average_generations, diversity = run(numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,roulette(),recombination,mutation,sel_survivors, fitness_func, metric)
    bests,average_bests, average_generations, diversity = run(numb_runs, numb_generations-1, size_pop, size_cromo, prob_mut,  prob_cross,sus(),recombination,mutation,sel_survivors, fitness_func, metric)
    display_diversity(diversity)
    display_stat_runs(bests,average_bests)
    """
