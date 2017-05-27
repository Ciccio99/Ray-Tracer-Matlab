% Plane class
classdef Plane < ObjectClass
    % Properties of Plane class objects
    properties
        CenterPos
        Normal
        Width
        Length
        Ambient
        Albedo
        SpecColor
        Ka
        Kd
        Ks
        Ke
        Kr
        Kt
        IOR
        U = 3.6;
        V = 10;
        Yellow = [1 1 0];
    end
    
    % Plane Class Methods
    methods
        % Constructor for a Plane
        % @param all the necessary ray tracing decriptors
        % @return a new plane
        function newPlane = Plane(pos, normal, width, length, ambient, albedo, specular, ka, kd, ks, ke, kr, kt, ior)
            newPlane.CenterPos = pos;
            newPlane.Normal = normal;
            newPlane.Width = width;
            newPlane.Length = length;
            newPlane.Ambient = ambient;
            newPlane.Albedo = albedo;
            newPlane.SpecColor = specular;
            newPlane.Ka = ka;
            newPlane.Kd = kd;
            newPlane.Ks = ks;
            newPlane.Ke = ke;
            newPlane.Kr = kr;
            newPlane.Kt = kt;
            newPlane.IOR = ior;
        end
        
        % Gets the normal, given the hit point
        % @param the plane object
        % @param the hit point
        function hitNormal = getHitNormal(plane, Phit)
            hitNormal = plane.Normal;
        end
        
        % Checks for an intersection with plane
        % @param plane object
        % @param ray object
        % @return bool true if intersected, false otherwise
        % @return t the ray distance
        function [bool, t] = checkIntersect(plane, ray)
            bool = false;
            t = dot((plane.CenterPos - ray.Origin), plane.Normal) / dot(ray.Direction, plane.Normal);
%           Check if the ray hit is within the bounds of the plane
            if t > 0
                Phit = ray.Direction + ray.Direction * t;
                x = Phit(1); 
                z = Phit(3);
                if (x < plane.CenterPos(1) + plane.Width / 2 && x > plane.CenterPos(1) - plane.Width / 2 )
                    if (z < plane.CenterPos(3) + plane.Length / 2 && z > plane.CenterPos(3) - plane.Length / 2)
                        bool = true;
                    end
                end
            end 
        end
        
        % Gets the procedural texture color for a plane
        % @param Phit | The point vector of the hit
        % @return color | The final albedo
        function color = getTextureColor(plane, Phit)
            x = Phit(1);
            z = Phit(3);
            col = round(x / plane.U);
            row = round(z / plane.V);
            if isEven(row) && isEven(col)
                color = plane.Albedo;
            elseif isOdd(row) && isOdd(col)
                color = plane.Albedo;
            else
                color = plane.Yellow;
            end   
        end
    end
end