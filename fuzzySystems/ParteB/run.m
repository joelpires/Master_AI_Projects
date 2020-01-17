numerator = [2];
denominator = [1 2 2.5 1.5];
[numerator, denominator]= c2dm(numerator,denominator, 1,'zoh');

load('DiscreteOut.mat');
load('InputRandom.mat');


DataSet = [];
for i=4:length(DiscreteOut)
    aux = [DiscreteOut(i-1) DiscreteOut(i-2) DiscreteOut(i-3) InputRandom(i-1) InputRandom(i-2) InputRandom(i-3) DiscreteOut(i)];
    DataSet = [DataSet; aux];
end

testingSet = DataSet(round(length(DataSet)*0.7)+1:length(DataSet),:);
trainingSet = DataSet(1:round(length(DataSet)*0.7),:);

fismat = genfis3(trainingSet(:,1:6), trainingSet(:,7), 'sugeno',5);


Roots = roots(denominator);
time = zeros(length(Roots),1);
for i=1:length(Roots)
    time(i)=-1/Roots(i)
end