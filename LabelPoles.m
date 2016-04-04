function [officialLabels] = LabelPoles( polePoints, inputPoints, weights, poleSampleIdx, poleOppositeIdx )
boundingBox = FindBoundingPoints(inputPoints, 0);

out = zeros(length(polePoints),1);
in = zeros(length(polePoints),1);

%mark all poles outside of the bounding box as outer poles
inBox = isInBoundingBox(polePoints, boundingBox);
out(~inBox) = 1;

priorityQueue = generatePriorityQueue(in, out);

officialLabels = ones(length(polePoints),1) * -1;

remainingIndices = (1:length(polePoints))';

while(~isempty(remainingIndices))
   %assign the next value
   nextIdx = priorityQueue(1,2);
   inVal = in(nextIdx);
   outVal = out(nextIdx);
   
   overallIdx = remainingIndices(nextIdx);
   sampleIdx = poleSampleIdx(nextIdx);
   oppIdx = poleOppositeIdx(nextIdx);
   
   if(inVal > outVal)
      officialLabels(overallIdx) = 1; 
   else 
       officialLabels(overallIdx) = 0;
   end
   
   in(nextIdx) = [];
   out(nextIdx) = [];
   remainingIndices(nextIdx) = [];
   poleSampleIdx(nextIdx) = [];
   poleOppositeIdx(nextIdx) = [];
   
   [numRemaining,~] = size(remainingIndices);
   
   if(~isempty(remainingIndices))
       %find which points overlap. They should likely be given the same label
       remainingPts = polePoints(remainingIndices, :);
       remainingPtRad = weights(remainingIndices);
       thisPtRad = weights(overallIdx);
       thisPt = polePoints(overallIdx,:);
       thisPtMat = repmat(thisPt,numRemaining,1);
       thisPtRadMat = repmat(thisPtRad,numRemaining,1);
       distanceMat = thisPtMat - remainingPts;
       distanceMat = distanceMat .^ 2;
       distanceMat = sum(distanceMat,2);
       distanceMat = sqrt(distanceMat);
       distanceMat = distanceMat - thisPtRadMat - remainingPtRad;

       %use a sigmoid function to map overlap rating between 0 and 1
       quarterRadius = thisPtRad * 0.25;
       overlapRating = sigmf(-distanceMat, [0.01,quarterRadius]);
       if(officialLabels(overallIdx) == 1)
          in = max(in, overlapRating); 
       else
          out = max(out, overlapRating);
       end
       %look at the opposite pole, and see how far apart they are
       %the angle between them will inform whether to mark the opposite
       %pole as being on the opposite side
       if(~isempty(find(remainingIndices==oppIdx)))
            convertedIdx = find(remainingIndices==oppIdx);
            oppPt = polePoints(oppIdx,:);
            samplePt = inputPoints(sampleIdx,:);
       
            v1 = oppPt - samplePt;
            v1 = v1/norm(v1);
            v2 = thisPt - samplePt;
            v2 = v2/norm(v2);
            angle = -cos(acos( dot(v1, v2) ));
            if(officialLabels(overallIdx) == 1)
                out(convertedIdx) = max(angle, out(convertedIdx)); 
            else
                in(convertedIdx) = max(angle, out(convertedIdx));
            end
       end
       
       
       %regenerate priority queue
       priorityQueue = generatePriorityQueue(in, out);
   end
end


end


function circle(x,y,r,c)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'color',c);
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