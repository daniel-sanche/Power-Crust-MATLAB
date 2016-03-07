function [ radMat ] = FindPolarBalls( poleVerts, points )
    radMat = zeros(length(poleVerts), 1);
    numPts = length(points);
    for i=1:length(poleVerts)
       vertMat = repmat(poleVerts(i,:), numPts, 1);
       distMat = (points - vertMat) .^2;
       distMat = sum(distMat, 2);
       distMat = sqrt(distMat);
       radius = min(distMat);
       radMat(i) = radius;
    end
end

