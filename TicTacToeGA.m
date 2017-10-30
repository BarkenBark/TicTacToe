%% Main code
clc; clear all
clf; close all

%Controller/Network properties
nbrOfHiddenNeurons = 8;
networkDimensions = [3, nbrOfHiddenNeurons, 2];
weightInterval = [-14, 14];
thresholdInterval = weightInterval;


%% Genetic Algorithm
NUMBER_OF_GENERATIONS = 10;
COPIES_OF_BEST_INDIVIDUAL = 1;

populationSize = 10;
[nbrOfWeights, nbrOfThresholds] = GetNbrOfWeightsAndThresholds(networkDimensions);
nbrOfGenes = nbrOfWeights + nbrOfThresholds;

mutationProbability = 4/nbrOfGenes;
creepRate = 0.25;
creepProbability = 0.85;
tournamentSelectionParameter = 0.70;
tournamentSize = 2;
crossoverProbability = 0.3;

population = InitializePopulation(populationSize, networkDimensions);

t = tic;
holdoutStrikes = 0;
for iGeneration = 1:NUMBER_OF_GENERATIONS

  %Evaluate population
  fitness = EvaluatePopulation(population);
  
  if iGeneration == NUMBER_OF_GENERATIONS
    fprintf('All %d generations completed.\n', NUMBER_OF_GENERATIONS);
    break
  end
  
  tempPopulation = population;

  %Selection and crossover
  for i = 1:2:populationSize
    i1 = TournamentSelect(trainingFitness, tournamentSelectionParameter, tournamentSize);
    i2 = TournamentSelect(trainingFitness, tournamentSelectionParameter, tournamentSize);
    chromosome1 = population(i1,:);
    chromosome2 = population(i2,:);
    
    r = rand;
    if (r < crossoverProbability)
      newChromosomePair = Cross(chromosome1, chromosome2);
      tempPopulation(i,:) = newChromosomePair(1,:);
      tempPopulation(i+1,:) = newChromosomePair(2,:);
    else
      tempPopulation(i,:) = chromosome1;
      tempPopulation(i+1,:) = chromosome2;
    end
  end

  %Mutation
  for i = 1:populationSize
    originalChromosome = tempPopulation(i,:);
    mutatedChromosome = Mutate(originalChromosome, mutationProbability, ...
      creepRate, creepProbability);
    tempPopulation(i,:) = mutatedChromosome;
  end

  tempPopulation = InsertBestIndividual(tempPopulation, bestIndividual, ...
    COPIES_OF_BEST_INDIVIDUAL);
  population = tempPopulation;
 
  if mod(iGeneration, NUMBER_OF_GENERATIONS/50)==0
    t = toc(t);
    fprintf('Generation %d/%d complete after %.2f seconds.\n', ...
      iGeneration, NUMBER_OF_GENERATIONS, t)
    t = tic;
  end
 
end








