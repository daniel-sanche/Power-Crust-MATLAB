function [officialLabels] = LabelPoles( polePoints, inputPoints, weights, poleSampleIdx, poleOppositeIdx )
% Assigns a label to each pole. 
% Each pole will be labeled as either inside (1) or outside (0)
%
% inputs:
% polePoints - the list of poles (extreme voroni vertices of point cloud)
% inputPoints - the original input point cloud
% weights - a list of the weight (radius) for each pole
% poleSampleIdx - the original point in the point cloud that created each pole
%                 represented as a list of indices into the inputPoints array
% poleOppositeIdx - the opposite pole associated with each pole in polePoints
%                   represented as a list of indices into polePoints
%
% output:
% officialLabels - a vector representing the label of each pole (1=inside,0=outside)


  %initialize the final label array
  officialLabels = ones(length(polePoints),1) * -1;

  %initialize in and out arrays, to keep track of the 
  %likelihood of a pole being on the inside or the outside

  out = zeros(length(polePoints),1);
  in = zeros(length(polePoints),1);

  %mark all poles outside of the bounding box as outer poles
  boundingBox = FindBoundingPoints(inputPoints, 0);
  inBox = IsInBoundingBox(polePoints, boundingBox);
  out(~inBox) = 1;

  %keep track of the indices of the remaining, unlabeled poles
  %this array will shrink as they are assigned labels, but can be used to map
  %between indices
  remainingIndices = (1:length(polePoints))';

  %generate the initial priority queue based on the in and out values of the poles
  priorityQueue = generatePriorityQueue(in, out);

  while(~isempty(remainingIndices))
    %pop the next value off of the priority queue
    nextIdx = priorityQueue(1,2);
    inVal = in(nextIdx);
    outVal = out(nextIdx);
    overallIdx = remainingIndices(nextIdx);
    sampleIdx = poleSampleIdx(nextIdx);
    oppIdx = poleOppositeIdx(nextIdx);
     
    %assign the label based on which value is most likely
    if(outVal >= inVal)
      officialLabels(overallIdx) = 0; 
    else 
      officialLabels(overallIdx) = 1;
    end
     
    %remove the value from all lists
    in(nextIdx) = [];
    out(nextIdx) = [];
    remainingIndices(nextIdx) = [];
    poleSampleIdx(nextIdx) = [];
    poleOppositeIdx(nextIdx) = [];
     
    %if there are still points left, recalculate in and out values
    if(~isempty(remainingIndices))
      %find which points overlap. They should likely be given the same label
      remainingPts = polePoints(remainingIndices, :);
      remainingPtRad = weights(remainingIndices);
      thisPt = polePoints(overallIdx,:);
      thisPtRad = weights(overallIdx);
      if(officialLabels(overallIdx) == 1)
        in = recalculateOverlapping(remainingPts, remainingPtRad, thisPt, thisPtRad, in);
        else
          out = recalculateOverlapping(remainingPts, remainingPtRad, thisPt, thisPtRad, out);
      end
      %calculate the probability that the opposite pole is assigned the opposite label
      if(~isempty(find(remainingIndices==oppIdx)))
        convertedIdx = find(remainingIndices==oppIdx);
        oppPt = polePoints(oppIdx,:);
        samplePt = inputPoints(sampleIdx,:);
        newValue = recalculateOppositePole(oppPt, samplePt, thisPt);
        
        if(officialLabels(overallIdx) == 1)
          out(convertedIdx) = max(newValue, out(convertedIdx)); 
        else
          in(convertedIdx) = max(newValue, out(convertedIdx));
        end
      end   
      %regenerate priority queue with new values
      priorityQueue = generatePriorityQueue(in, out);
     end
  end
  %convert the official labels into a logical. They should all be 0 or 1
  officialLabels = logical(officialLabels);
end

%recalculates the priority queue, using th emethod described in the paper
function priorityQueue = generatePriorityQueue(in, out)
  [numPoles, ~] = size(in);
  %find the priority queue values
  priority = abs(in - out) - 1;
  for i=1:numPoles
    %if only one of in or out has a value != 0, use that value instrad
    if((in(i) == 0 && out(i) ~=0) || (in(i)~=0 && out(i)==0))
      priority(i,1) = in(i) + out(i);
    end
  end  
  [sorted, I] = sort(priority, 'descend');
  priorityQueue = [sorted, I];
end

%calculates the probability that the opposite pole should be given the opposite label 
%from the current pole. This process is based on the angle formed between the original sample,
%and the two opposite poles
function [newValue] = recalculateOppositePole(oppositePt, samplePt, thisPt)
  v1 = oppositePt - samplePt;
  v1 = v1/norm(v1);
  v2 = thisPt - samplePt;
  v2 = v2/norm(v2);
  newValue = -cos(acos( dot(v1, v2) ));
end

%calculates new label values for poles that overlap with the current pole
%if they overlap by a large amount, they likely share the same label
function [sameLabel] = recalculateOverlapping(remainingPoints, remainingWeights, thisPt, thisRad, sameLabel)
  [numRemaining,~] = size(remainingPoints);
  thisPtMat = repmat(thisPt,numRemaining,1);
  thisPtRadMat = repmat(thisRad,numRemaining,1);
  distanceMat = thisPtMat - remainingPoints;
  distanceMat = distanceMat .^ 2;
  distanceMat = sum(distanceMat,2);
  distanceMat = sqrt(distanceMat);
  distanceMat = distanceMat - thisPtRadMat - remainingWeights;

  %use a sigmoid function to map overlap rating between 0 and 1
  quarterRadius = thisRad * 0.25;
  overlapRating = sigmf(-distanceMat, [0.01,quarterRadius]);

  sameLabel = max(sameLabel, overlapRating);
end