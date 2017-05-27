% Ray class
classdef Ray
    % Properties of ray class
    properties
        Origin
        Direction
        Length
    end
    methods
        % Constructor method
        % @param ray origina
        % @param direction of ray
        % @param length of ray
        % @retrun the final ray
        function newRay = Ray(orig, dir, len)
            newRay.Origin = orig;
            newRay.Direction = dir;
            newRay.Length = len;
        end
    end
end