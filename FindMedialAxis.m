function [ MedialAxis, MAT ] = FindMedialAxis( poles, labels, powerDiagram )
% This process finds the medial axis and medial axis transform of the points
%
% inputs:
% poles - the set of poles from transform
% labels - a vector representing the label of each pole (1=inside,0=outside)
% powerDiagram - the power diagram from the labels. It is a set of cells,
%                where each cell contains a list of all vertices for each pole's power region.
%
% outputs:
% MedialAxis - the set of points representing the medial axis of the point cloud
% MAT - the medial axis transform. Represents a set of edges between MedialAxis points


% the MedialAxis is just the set of poles labeled as being on the inside
MedialAxis = poles(labels, :);

% find the neighbouring voronoi cells to find the MAT
MAT = cell(length(MedialAxis),1);
idx = 1;
for i=1:length(powerDiagram)
   if(labels(i))
      % if this pole is on the inside, look for neighbours aslo on the inside
       verts = powerDiagram{i}; 
       [rows,~] = size(verts);
       for k=i+1:length(powerDiagram)
           if(labels(k))
               foundMatch = false;
               for j=1:rows
                   thisVert = verts(j,:);
                   otherVerts = powerDiagram{k};
                   containsThisVert = ~isempty(find(otherVerts(:,1)==thisVert(1) & otherVerts(:,2)==thisVert(2)));
                   if(containsThisVert)
                       % we foud a shared vertex between these regions. They are connected, stop looking
                       foundMatch = true;
                       break;
                   end
               end
               if(foundMatch)
                  % since these regions are touching, add an edge between them in the MAT
                  newEdge = [poles(i,:) ; poles(k,:)];
                  MAT(idx) = {newEdge};
                  idx = idx+1;
               end
           end
       end
   end
end
end

