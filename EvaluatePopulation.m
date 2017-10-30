function fitness = EvaluatePopulation(population)

nbrOfIndividuals = size(population, 1);
results = zeros(nbrOfIndivudals);
for i = 1:nbrOfIndividuals
    for j = 1:nbrOfIndividuals
        chromosome1 = population(i,:);
        chromosome2 = population(j,:);
        network1 = DecodeChromosome(chromosome1);
        network2 = DecodeChromosome(chromosome2);
        outcome = PlayTicTacToe(network1, network2);
        results(i,j) = outcome;
    end
end

fitness = zeros(nbrOfIndividuals, 1);
for i = 1:nbrOfIndividuals
   fitness(i) = sum(results(i,:)); 
end

end