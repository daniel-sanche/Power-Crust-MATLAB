function [result] = LabelPoles( polePoints, inputPoints )

result = sum(polePoints,2)==0;


%figure;
boundingBox = FindBoundingPoints(inputPoints, 0);
%plot(polePoints(:,1), polePoints(:,2),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none');
%hold on
%plot(boundingBox(:,1), boundingBox(:,2),'Marker','.','MarkerEdgeColor','b','MarkerSize',10, 'LineStyle', 'none');
%plot(inputPoints(:,1), inputPoints(:,2),'Marker','.','MarkerEdgeColor','g','MarkerSize',10, 'LineStyle', 'none');

out = zeros(length(polePoints),1);
in = zeros(length(polePoints),1);

inBox = isInBoundingBox(polePoints, boundingBox);
out(~inBox) = 1;

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