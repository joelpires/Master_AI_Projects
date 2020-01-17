# Master_AI_Projects
This is a collection of some of the most relevant projects developed during the MSc. in Artificial Intelligence.

### ML_digits_recognition
This work is done within the scope of the Machine Learning course. Its purpose is to make an optical character recognition (OCR) program, namely from 0 to 9. Characters will use the knowledge acquired in the theoretical classes on neural networks and Matlab (with Neural Networks Toolbox) to implement OCR .

### ML_epilepsy
The aim of this work is to identify epilepsy crises based on for this in the frequency information provided by Electroencephalograms.

These encephalograms extract data on brain activity being that, from a set of characteristics we can identify moments of epileptic seizures (ectal points), moments that precede and follow crises (pre-ictal and post-ictal respectively) and the remaining moments when no epileptic activity is recorded (inter-ictal points).

What is the main challenge then of this work? Create an application in Matlab that allows you to analyze these data collected from EEG’s in order to predict or detect crisis situations. For that, neural networks were used available in the Neural Networks Toolbox. In order to evaluate the performance and performance of our application, we calculate the sensitivity and specificity in each test, that is, we calculate the percentage of true ict situations detected (sensitivity) and the percentage of situations false non-icts detected (specificity). We recall that a large specificity implies a good detection of moments when there are no crises and, on the other hand, a high sensitivity refers to a good detection of crisis situations.

### ai_games_unity
#### Project 1
This is a work developed within the course of Introduction to Artificial Intelligence of the Computer Engineering course at the University of Coimbra and conducted by Fernando Machado.
In this work, we will develop and explore the capabilities of autonomous reactive agents. For this, Braitenberg Vehicles were chosen. Why? Because they are robots that can exhibit sophisticated behaviors despite their extreme simplicity. These vehicles allow us to simulate different reactions of a living being to various elements of nature (such as light and obstacles) through sensory stimuli processed on different sides/hemispheres.
To develop such a project, the Unity game engine and the C# programming language were used. Unity was useful for us to be able to build vehicles, build test scenarios, and visualize the behaviors manifested by our robots. The C# language gave life to these same robots that manifested the behaviors that we had previously programmed.

#### Project 2
This work was developed within the course of Introduction to Artificial Intelligence of the Computer Engineering course at the University of Coimbra and conducted by Fernando Machado.
In this work, we will develop and explore the capabilities of agents looking for. For this, we will try to solve the game "Sokoban" whose objective is to move all the boxes to certain positions on the map. This is only possible using search algorithms.
To develop such a project, the Unity game engine and the C # programming language were used. Unity was useful for us to be able to build test scenarios and visualize the behaviors manifested by our search agent. The C # language gave life to these same agents that manifested the behaviors of the algorithms that we had previously programmed.

#### Project 3
Neste trabalho, vamos desenvolver e explorar como agentes de adaptação adaptativos. Para isso, vamos tentar desenvolver um driver para o jogador de um jogo do estilo “Space Shooter”. O driver tem de fazer com que a nave desvie dos asteróides. Para efeito, usamos algoritmos genéticos.
Para desenvolver esse projeto, use o motor de jogo Unity e a linguagem de programação C #. O Unity foi útil para poder criar cenários de teste e visualizar os comportamentos manifestos pelo nosso agente adaptativo. A linguagem C # deu a vida o mesmo agente que se manifesta nos métodos de algoritmo que nós mesmos já tivemos programado.

### evolutionary_computing

Premature convergence is a well-known problem with regard to evolutionary algorithms and, in order to be reduced, it is necessary to guarantee a great diversity of the population. In this work, we will test and compare different algorithms for selecting parents. One is based on tournament selection, another using uniform stochastic sampling, and finally, we use the roulette selection method. The goal will be to understand which one results in both a greater diversity of the population as well as a higher quality of the final result in terms of performance.

### fuzzySystems

This work aims to apply the knowledge acquired in theoretical classes on diffuse systems, namely:

Neuro-Diffuse Systems - according to specified input produces a certain output value. Especially useful for model processes and systems,

Diffuse Controllers - Represents a process that is part of the system. Among others, they can be of the Mamdani and Sugeno type. These last two will be implemented and analyzed during this work, each with 9 and 25 logical rules.

The implementation of diffuse controllers on remote issues in Matlab and using the tools of Simulink and Fuzzy Logic Toolbox.

These controllers, which are registered by a diffuse logic, are made up of 3 phases: input, processing, output. There is, then, a mapping of belonging functions and truth values; there is a call to the logic rules applied to the input function; finally, the result of this processing is output.

### predictNextPlace

Predicting the next place of users based on spatio-temporal clustering techniques.

This program intends to be the implementation proposed by Scellato et al. in "NextPlace: A Spatio-temporal Prediction Framework for Pervasive Systems" (paper inside the repository).

TSR (Traffic Sign Recognition) is a widely used technology for recognition of road signs on the road.

Our goal with this work will be to develop classifiers for the TSR. We were provided with a dataset with 43 different traffic signs represented by photographs taken in a real environment. The training dataset contains 39209 signals while the test contains 12630. A set of features is also provided pre-computed.

### traffic_signs_recognition

We will consider three different scenarios:

● Scenario A: it is a binary problem. The aim is only to distinguish the STOP signal from the rest.

● Scenario B: in this case, we will differentiate between six different classes of signs, which are: danger signs, obligation signs, prohibition signs for the speed limit, other prohibition signs, unique signs, and signs restriction.

● Scenario C: here we will differentiate all 43 signals.

### zomatoChatbot

Within the scope of the curricular unit of Artificial Intelligence of the University of Coimbra taught by the teacher Hugo Gonc¸alo Oliveira, a goal oriented conversational agent was developed that was able to interact through text with the user. Called ’Zomato Chatbot’ and having a retrieval based model, it is able to hold trivial conversations with the user, although its main purpose is to provide details about restaurants in the Lisbon and Porto area based on API calls from the application of Zomato.

