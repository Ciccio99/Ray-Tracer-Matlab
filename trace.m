% Basic trace function
% @param ray objects
% @param objects to check
% @return bool if intersected
% @return tNear for ray distance
% @return object hit
function [bool, tNear, hitObject] = trace(ray, objects)
    tNear = inf;
    bool = false;
    hitObject = 0;
    [ useless length ] = size(objects);
    for i = 1:length
        obj = objects{i};
        [hit, t] = obj.checkIntersect(ray);
        
        if (hit && t < tNear)
            hitObject = obj;
            tNear = t;
            bool = true;
        end
    end
end
