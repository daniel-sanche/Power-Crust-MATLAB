function [result] = LabelPoles( polePoints, inputPoints )


boundingBox = FindBoundingPoints(inputPoints, 0);
plot(polePoints(:,1), polePoints(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
hold on
plot(boundingBox(:,1), boundingBox(:,2),'Marker','.','MarkerEdgeColor','b','MarkerSize',10, 'LineStyle', 'none');
plot(inputPoints(:,1), inputPoints(:,2),'Marker','.','MarkerEdgeColor','g','MarkerSize',10, 'LineStyle', 'none');

out = zeros(length(polePoints),1);
in = zeros(length(polePoints),1);

%mark all poles outside of the bounding box as outer poles
inBox = isInBoundingBox(polePoints, boundingBox);
out(~inBox) = 1;

priorityQueue = generatePriorityQueue(in, out);

officialLabels = ones(length(polePoints),1) * -1;

remainingIndices = (1:length(polePoints))';

while(~isempty(priorityQueue))
   %assign the next value
   nextIdx = priorityQueue(1,2);
   inVal = in(nextIdx);
   outVal = out(nextIdx);
   
   overallIdx = remainingIndices(nextIdx);
   
   if(inVal > outVal)
      officialLabels(overallIdx) = 1; 
   else 
       officialLabels(overallIdx) = 0;
   end
   
   in(nextIdx) = [];
   out(nextIdx) = [];
   remainingIndices(nextIdx) = [];
   
   priorityQueue = generatePriorityQueue(in, out);
end


end

function priorityQueue = generatePriorityQueue(in, out)
    [numPoles, ~] = size(in);
    %find the priority queue values
    priority = abs(in - out) - 1;
    for i=1:numPoles
        if((in(i) == 0 && out(i) ~=0) || (in(i)~=0 && out(i)==0))
            priority(i,1) = in(i) + out(i);
        end
    end
    
    [sorted, I] = sort(priority, 'descend');
    priorityQueue = [sorted, I];
end


function [inBox] = isInBoundingBox(pts, box)

[rows, cols] = size(box);

inBox = ones(length(pts), 1);

    for i=1:cols
      ptDim = pts(:,i);
      maxVal = max(box(:,i));
      minVal = min(box(:,i));
    
      lessThanMax = ptDim < maxVal;
      moreThanMin = ptDim > minVal;
      matchesBoth = lessThanMax .* moreThanMin;
      inBox = inBox .* matchesBoth;
    end
end