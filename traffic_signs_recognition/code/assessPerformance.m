function [ ] = assessPerformance(scenario, expected_y, predicted_y, filename )
expected_y = expected_y';
predicted_y = predicted_y';

k = unique(expected_y);

[~, targetSize] = size(expected_y);

newTarget = zeros(length(k), targetSize);
output = zeros(length(k), targetSize);
targetIdx = sub2ind(size(newTarget), expected_y, 1:targetSize);
outputIdx = sub2ind(size(output), predicted_y, 1:targetSize);

newTarget(targetIdx) = 1;
output(outputIdx) = 1;
figure('visible', 'off')
[C,CM,IND,PER] = confusion(newTarget, output);
figure('Visible','off');
plotconfusion(newTarget, output);
filename1 = strcat('../results/testing/confusionmatrix/', filename{1}, "_confusionMatrix.png");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
saveas(gcf, filename1{1});

if scenario == 'A'
    % ----------
    % ROC Curves
    positive_class = 1;
    [roc_tpr, roc_fpr] = perfcurve(expected_y, predicted_y, positive_class);
    figure('Visible','off');
    plot(roc_tpr,roc_fpr)
    xlabel('False positive rate')
    ylabel('True positive rate')
    title('ROC Curve')
    filename1 = strcat('../results/testing/roc/', filename{1}, "_rocCurve.png");
    saveas(gcf, filename1{1});
end

true_positives = CM(1,1);
true_negatives = CM(2,2);
false_positives = CM(1,2);
false_negatives = CM(2,1);

% ------------------- %
% Analysis of results %
% ------------------- %

population = true_positives + true_negatives + false_positives + false_negatives;

true_condition_positive = true_positives + false_negatives;
true_condition_negative = false_positives + true_negatives;

predicted_condition_positive = true_positives + false_positives;
predicted_condition_negative = false_negatives + true_negatives;

% -----------------------
% True Condition Analysis

% True positive rate
TPR = true_positives / (true_condition_positive);

% False negative rate - Type II error
FNR = false_negatives / (true_condition_positive);

% False positive rate - Type I error
FPR = false_positives / (true_condition_negative);

% True negative rate
TNR = true_negatives / (true_condition_negative);

true_condition = [TPR, FNR, FPR, TNR];

% ----------------------------
% Predicted Condition Analysis

% Positive prediction value
PPV = true_positives / predicted_condition_positive;

% False discovery rate
FDR = false_positives / predicted_condition_positive;

% False omission rate
FOR = false_negatives / predicted_condition_negative;

% Negative predictive value
NPV = true_negatives / predicted_condition_negative;

predicted_condition = [PPV, FDR, FOR, NPV];

% -----------------------
% Diagnostic Analysis

% Positive likelyhood ratio
PLR = TPR / FPR;

% Negative likelyhood ratio
NLR = FNR / TNR;

% Diagnostic odds ratio
DOR = PLR / NLR;

diagnostic_analysis = [PLR, NLR, DOR];

% ---------------------
% Statistical Relevance
accuracy = (true_positives + true_negatives) / population;

precision = true_positives / (true_positives + false_positives);

recall = true_positives / true_condition_positive;

prevalence = true_condition_positive / population;

sensitivity = TPR;

specificity = TNR;

f_measure = 2 * ((precision * recall)/(precision + recall));

filename1 = strcat('../results/testing/stats/', filename{1}, "_results.txt");
fid=fopen(filename1{1},'w');
fprintf(fid,'PRECISÃO: %6.4f\n',precision);
fprintf(fid,'ACCURACY: %6.4f\n',accuracy);
fprintf(fid,'RECALL: %6.4f\n',recall);
fprintf(fid,'PREVALENCE: %6.4f\n',prevalence);
fprintf(fid,'SPECIFICITY: %6.4f\n',specificity);
fprintf(fid,'SENSITIVITY: %6.4f\n',sensitivity);
fprintf(fid,'PREVALENCE: %6.4f\n',prevalence);
fprintf(fid,'F MEASURE: %6.4f\n',f_measure);

fclose(fid);

end
%EOF