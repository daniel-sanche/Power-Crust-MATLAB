function [ MedialAxis, MAT ] = FindMedialAxis( poles, labels, powerDiagram )

MedialAxis = poles(labels, :);

%find the neighbouring voronoi cells
MAT = cell(length(MedialAxis),1);
idx = 1;
for i=1:length(powerDiagram)
   if(labels(i))
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
                       foundMatch = true;
                       break;
                   end
               end
               if(foundMatch)
                  newEdge = [poles(i,:) ; poles(k,:)];
                  MAT(idx) = {newEdge};
                  idx = idx+1;
               end
           end
       end
   end
end
end

