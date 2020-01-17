"""
Utilities for visualization and statistical suport
"""

import matplotlib.pyplot as plt
import pandas as pd
from scipy import stats
from pylab import figure, axes, pie, title, show
from scipy.stats import ttest_ind, normaltest, kstest, levene, kruskal, mannwhitneyu, shapiro
import statsmodels.sandbox.stats.multicomp as smm
import numpy as np

# auxiliary
def display(indiv, phenotype):
    print('Chromo: %s\nFitness: %s' % (phenotype(indiv[0]),indiv[1]))

def display_stat_1(best,average):
    generations = list(range(len(best)))
    plt.title('Performance over generations')
    plt.xlabel('Generation')
    plt.ylabel('Fitness')
    plt.plot(generations, best, label='Best')
    plt.plot(generations,average,label='Average')
    plt.legend(loc='best')
    plt.show()

def display_diversity(diversity):
    generations = list(range(len(diversity)))
    plt.title('Diversity over generations')
    plt.xlabel('Generation')
    plt.ylabel('Diversity')
    plt.plot(generations, diversity, label='Diversity')
    plt.legend(loc='best')
    plt.show()


def display_stat_n(boa,average_best):
    generations = list(range(len(boa)))
    plt.title('Performance over runs')
    plt.xlabel('Generation')
    plt.ylabel('Fitness')
    plt.plot(generations, boa, label='Best of All')
    plt.plot(generations,average_best,label='Average of Bests')
    plt.legend(loc='best')
    plt.show()

def display_stat_runs(bests,average_bests):
    runs = list(range(len(bests)))
    plt.title('Performance over runs')
    plt.xlabel('Runs')
    plt.ylabel('Fitness')
    plt.plot(runs, bests, label='Best of All Generations')
    plt.plot(runs,average_bests,label='Average of Bests of all Generations')
    plt.legend(loc='best')
    plt.show()


if __name__ == '__main__':
    pass
