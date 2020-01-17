#! /usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import division
"""
sea_perm.py
A very simple EA for permutations (TSP).
Ernesto Costa, February 2016
"""

__author__ = 'Ernesto Costa'
__date__ = 'February 2016'


from random import random,randint,uniform, sample, shuffle,gauss
from operator import itemgetter
from copy import deepcopy


# For the statistics
def run(numb_runs,numb_generations,size_pop, size_cromo, prob_mut,  prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func, metric):
    bests = []
    average_bests = []
    diversityList = []
    for i in range(numb_runs):
        print("RUN " + str(i))
        best,stat_best,stat_aver, diversity = sea_perm_for_plot(numb_generations,size_pop, size_cromo, prob_mut,  prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func, metric)
        bests.append(min(stat_best))
        average_bests.append(sum(stat_best)/numb_generations)
        diversityList.append(sum(diversity)/numb_generations)
    return bests,average_bests, diversityList


def run_for_file(filename,numb_runs,numb_generations,size_pop, size_cromo, prob_mut,prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func, metric):

    filename1 = 'testFiles/' + filename + '_bests.txt'
    filename2 = 'testFiles/' + filename + '_average_bests.txt'
    filename3 = 'testFiles/' + filename + '_diversity.txt'
    with open(filename1,'w') as f_bests:
        with open(filename2,'w') as f_average_bests:
            with open(filename3,'w') as f_metric:
                for i in range(numb_runs):
                    print("RUN " + str(i))
                    best,stat_best,stat_aver, diversity = sea_perm_for_plot(numb_generations,size_pop, size_cromo, prob_mut,  prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func, metric)
                    f_bests.write(str(min(stat_best)) + '\n')
                    f_average_bests.write(str(sum(stat_best)/numb_generations)+'\n')
                    f_metric.write(str(sum(diversity)/numb_generations) +'\n') #TODO: É preciso mudar isto
    f_bests.close()
    f_average_bests.close()
    f_metric.close()

# Simple [permutation] Evolutionary Algorithm
def sea_perm(numb_generations,size_pop, size_cromo, prob_mut,  prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func):

    populacao = gera_pop(size_pop,size_cromo)
    # evaluate population
    populacao = [(indiv[0], fitness_func(indiv[0])) for indiv in populacao]
    for i in range(numb_generations):
        # sparents selection
        mate_pool = sel_parents(populacao)
	# Variation
	# ------ Crossover
        progenitores = []
        for i in  range(0,size_pop-1,2):
            indiv_1= mate_pool[i]
            indiv_2 = mate_pool[i+1]
            filhos = recombination(indiv_1,indiv_2, prob_cross)
            progenitores.extend(filhos)
        # ------ Mutation
        descendentes = []
        for cromo,fit in progenitores:
            novo_indiv = mutation(cromo,prob_mut)
            descendentes.append((novo_indiv,fitness_func(novo_indiv)))
        # New population
        populacao = sel_survivors(populacao,descendentes)
        # Evaluate the new population
        populacao = [(indiv[0], fitness_func(indiv[0])) for indiv in populacao]
    return best_pop(populacao)

def sea_perm_for_plot(numb_generations,size_pop, size_cromo, prob_mut,prob_cross,sel_parents,recombination,mutation,sel_survivors, fitness_func, metric):
    # inicializa população: indiv = (cromo,fit)
    populacao = gera_pop(size_pop,size_cromo)
    # avalia população
    populacao = [(indiv[0], fitness_func(indiv[0])) for indiv in populacao]

    # para a estatística
    stat = [best_pop(populacao)[1]]
    stat_aver = [average_pop(populacao)]
    diversity = [diversity_discrete(populacao, metric)]

    for i in range(numb_generations):
        # selecciona progenitores
        mate_pool = sel_parents(populacao)
	# Variation
	# ------ Crossover
        progenitores = []
        for i in  range(0,size_pop-1,2):
            indiv_1= mate_pool[i]
            indiv_2 = mate_pool[i+1]
            filhos = recombination(indiv_1,indiv_2, prob_cross)
            progenitores.extend(filhos)
        # ------ Mutation
        descendentes = []
        for cromo,fit in progenitores:
            novo_indiv = mutation(cromo,prob_mut)
            descendentes.append((novo_indiv,fitness_func(novo_indiv)))
        # New population
        populacao = sel_survivors(populacao,descendentes)
        # Avalia nova _população
        populacao = [(indiv[0], fitness_func(indiv[0])) for indiv in populacao]

	    # Estatística
        stat.append(best_pop(populacao)[1])
        stat_aver.append(average_pop(populacao))
        diversity.append(diversity_discrete(populacao, metric))

    return best_pop(populacao),stat, stat_aver, diversity


#Initialize population
def gera_pop(size_pop,size_cromo):
    return [(gera_indiv_perm(size_cromo),0) for i in range(size_pop)]

def gera_indiv_perm(size_cromo):
    data = list(range(size_cromo))
    shuffle(data)
    return data


# Variation operators: ------ > swap mutation
def muta_cromo(cromo, prob_muta):
    if random() < prob_muta:
        comp = len(cromo) - 1
        copia = cromo[:]
        i = randint(0, comp)
        j = randint(0, comp)
        while i == j:
            i = randint(0, comp)
            j = randint(0, comp)
        copia[i], copia[j] = copia[j], copia[i]
        return copia
    else:
        return cromo


# Variation Operators :  OX - order crossover
def order_cross(indiv_1,indiv_2,prob_cross):
    size = len(indiv_1[0])
    value = random()
    if value < prob_cross:
        cromo_1 = indiv_1[0]
        cromo_2 = indiv_2[0]
        # define two cut points
        pc= sample(range(size),2)
        pc.sort()
        pc1,pc2 = pc
        f1 = [None] * size
        f2 = [None] * size
        # copy middle part
        f1[pc1:pc2+1] = cromo_1[pc1:pc2+1]
        f2[pc1:pc2+1] = cromo_2[pc1:pc2+1]
        # include the rest
        pos = (pc2+1)% size
        fixed = pos
        # first offspring
        while pos != pc1:
            j = fixed % size
            while cromo_2[j] in f1:
                j = (j+1) % size
            f1[pos] = cromo_2[j]
            pos = (pos + 1)% size
        # second offspring
        pos = (pc2+1)% size
        while pos != pc1:
            j = fixed % size
            while cromo_1[j] in f2:
                j = (j+1) % size
            f2[pos] = cromo_1[j]
            pos = (pos + 1)% size
        return ((f1,0),(f2,0))
    else:
        return indiv_1,indiv_2

# SUS (Stochastic Uniform Selection)
def sus():
    def sus_sel(pop):
        population = deepcopy(pop)
        population.sort(key=itemgetter(1))
        total_fitness = sum([indiv[1] for indiv in population])
        value = uniform(0,1.0/len(population))
        pointers = [value + i * (1.0/len(population)) for i in range(len(population))]
        mate_pool = []
        for j in range(len(population)):
            val = pointers[j]
            index = 0
            total = population[index][1]/float(total_fitness)
            while total < val:
                index += 1
                total += population[index][1]/float(total_fitness)
            mate_pool.append(pop[index])
        return mate_pool
    return sus_sel


# Roulette selection
def roulette():
    def roulette_sel(pop):
        population = deepcopy(pop)
        population.sort(key=itemgetter(1))
        total_fitness = sum([indiv[1] for indiv in population])
        mate_pool = []
        for i in range (len(pop)):
            value = uniform(0,1)
            index = 0
            total = population[index][1]/total_fitness
            while total < value:
                index += 1
                total += population[index][1]/total_fitness
            mate_pool.append(population[index])
        return mate_pool
    return roulette_sel

# Tournament Selection
def tour_sel(t_size):
    def tournament(pop):
        size_pop= len(pop)
        mate_pool = []
        for i in range(size_pop):
            winner = tour(pop,t_size)
            mate_pool.append(winner)
        return mate_pool
    return tournament

def tour(population,size):
    """Minimization Problem.Deterministic"""
    pool = sample(population, size)
    pool.sort(key=itemgetter(1))
    return pool[0]

# Survivals: elitism
def sel_survivors_elite(elite):
    def elitism(parents,offspring):
        """Minimization."""
        size = len(parents)
        comp_elite = int(size* elite)
        offspring.sort(key=itemgetter(1))
        parents.sort(key=itemgetter(1))
        new_population = parents[:comp_elite] + offspring[:size - comp_elite]
        return new_population
    return elitism



# auxiliary
def best_pop(populacao):
    """Minimization."""
    populacao.sort(key=itemgetter(1))
    return populacao[0]

def average_pop(populacao):
    return sum([fit for cromo,fit in populacao])/len(populacao)

def diversity_discrete(population, metric):
    size_pop = len(population)
    count = 0
    for i in range(size_pop):
        for j in range(size_pop):
            distance = metric(population[i], population[j])
            if distance != 0:
                count += 1
    return (2.0*count)/(size_pop * (size_pop -1))

def diversity_continuos(population, metric, delta = 0.01):
    size_pop = len(population)
    count = 0
    for i in range(size_pop):
        for j in range(size_pop):
            distance = metric(population[i], population[j])
            if distance > delta:
                count += 1
    return (2.0*count)/(size_pop * (size_pop -1))

def hamming_distance(vec_1, vec_2):
    return sum([1 for i in range(len(vec_1)) if vec_1[i] != vec_2[i]])

def euclidean_distance(vec_1, vec_2):
    pairs = list(zip(vec_1, vec_2))
    return math.sqrt(sum([(pair[0] - pair[1])**2 for pair in pairs]))


if __name__ == '__main__':
    pass
