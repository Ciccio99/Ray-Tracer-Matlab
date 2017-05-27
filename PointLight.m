% Point light class
classdef PointLight
    % Properties of point light class
    properties
        Position
        Color
    end
    
    methods
        % Constructor for point light class
        % @param position
        % @param color
        % @return the new light
        function newLight = PointLight(pos, color)
            newLight.Position = pos;
            newLight.Color = color;
        end
    end
end