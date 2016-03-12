function [  ] = GeneratePowerDiagram( inputVerts, weights )
    %a power diagram in n dimensions is equavalent to a voronoi diagram
    %in n+1 directions, using sqrt(C-weight) for the n+1st dimension
    %where c is a large constant
    
    C = max(weights) * 10;
    WeightDimension = sqrt(C - weights);
    [outputVerts,outputCells]=voronoin([inputVerts,WeightDimension]); 
    %remove the extra dimension
    outputVerts = outputVerts(:,1:3);
end

