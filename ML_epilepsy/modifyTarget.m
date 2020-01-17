%The main objective here is to create a target vector like Trg vector but
%with some changes in order to identify the four classes: 1 for
%interictal, 2 for preictal, 3 for ictal, 4 for postictal

function [ targetCopy, crysisStart, crysisEnd ] = modifyTarget( Trg )
    
    targetCopy = Trg;
    
    difference = diff(targetCopy);
    
    targetCopy = targetCopy*2+1; %let's change the ictal states to 3 and the inter-ictal states to 1
    
    crysisStart = find(difference == 1);          
    crysisEnd = find(difference == -1);
    
    
    %let's change the 600 points before the crysis to the pre-ictal state(2)
    %and the 300 points after the crysis to the pos-ictal state(4)
    for i=1:length(crysisStart)
        targetCopy(crysisStart(i)-600 : crysisStart(i)) = 2;
        targetCopy(crysisEnd(i)+1 : crysisEnd(i) + 301) = 4;
    end
    
    crysisStart = crysisStart-600;
    crysisEnd = crysisEnd+301;
end