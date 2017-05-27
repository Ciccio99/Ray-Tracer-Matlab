% Class for Sphere objects
classdef Sphere < ObjectClass
    % Base Properties of the Spheres
    properties
        CenterPos
        Radius
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
        Inside = false;
    end
    
    % Class Methods
    methods
        % Consturctor class for sphere
        % @param all of teh ray tracing properties
        % @return a new sphere
        function newSphere = Sphere(pos, rad, amb, albedo, specColor, ka, kd, ks, ke, kr, kt, ior)
            newSphere.CenterPos = pos;
            newSphere.Radius = rad;
            newSphere.Ambient = amb;
            newSphere.Albedo = albedo;
            newSphere.SpecColor = specColor;
            newSphere.Ka = ka;
            newSphere.Kd = kd;
            newSphere.Ks = ks;
            newSphere.Ke = ke;
            newSphere.Kr = kr;
            newSphere.Kt = kt;
            newSphere.IOR = ior;
        end
        
        % Calculates the normal based on a given hit point
        % @param sphere object
        % @param hit point
        % @ return the hit normal
        function hitNormal = getHitNormal(sphere, Phit)
            hitNormal = Phit - sphere.CenterPos;
        end
        
        % Checks for intersections
        % @param the sphere
        % @param the ray
        % @return bool true if intersect, false otherwise
        % @retrun t distance of ray
        function [bool, t] = checkIntersect(sphere, ray)
            bool = false;
            t = inf;
            
            L = ray.Origin - sphere.CenterPos;
            a = dot(ray.Direction, ray.Direction);
            b = 2 * dot(ray.Direction, L);
            c = dot(L, L) - sphere.Radius^2;
            [hitBool, t0, t1] = Sphere.solveQuadratic(a, b, c);
            if hitBool == false
                return
            end

            if t0 > t1 
                temp = t0;
                t0 = t1;
                t1 = temp;
            end
            
            if (t0 < 0 ) 
                t0 = t1; % If t- is negative, use t1 instead
                if (t0 < 0) % Both t0 and t1 are negative
                    return
                end
            end
            
            t = t0;
            bool = true;
        end
        
    end
    methods (Static)
        % Solves quadratic formula for sphere intersection
        % @param a variables
        % @param b variables
        % @param c variables
        % @return bool if intersected
        % @return result 1
        % @return result 2
        function [bool, x0, x1] = solveQuadratic(a, b, c)
            % Starting variables
            bool = false;
            x0 = false;
            x1 = false;
            
            
            discr = b^2 - 4 * a * c;
            if (discr < 0 )
                return
            elseif (discr == 0)
                x0 = -0.5 * b / a;
                x1 = x0;
            else
                q = inf;
                
                if b > 0
                    q = -0.5 * (b + sqrt(discr));
                else
                    q = -0.5 * (b - sqrt(discr));
                end
                
                x0 = q / a;
                x1 = c / q;
            end
            
            % Return true if intersected
            bool = true;           
        end
    end
end