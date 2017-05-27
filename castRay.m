% Casts the ray
% @param ray object
% @param objects
% @param light objects
% @param ray depth
% @return final ray traced pixel color
function pixelColor = castRay (ray, objects, lightObjects, depth)
    % Max Depth
    maxDepth = 6;
    
    % Ray Length
    rayLength = 10000;
    
    % Background color set to Cyan
    backGroundColor = [ 0 0.7 1 ];
    % Reflection bias to prevent refleciton acne
    reflBias = 1e-6;
    
    % Cast the inital ray trace
    [hit, t, hitObj] = trace(ray, objects);
    
    if ~hit
           pixelColor = backGroundColor;
    else
       Phit = ray.Origin + ray.Direction * t;
       pixelColor = calculateShading(hitObj, Phit, objects, lightObjects, ray);
       
       % Check if the ray tracer has gone to deep into the matrix
       if (depth < maxDepth)
           hitNormal = hitObj.getHitNormal(Phit);
           hitNormal = hitNormal / norm(hitNormal);
           
           Ir = [0 0 0];
           It = [0 0 0];

           % Trace the reflection ray if Kr says so
           if hitObj.Kr > 0


              incidentVect = getIncidentReflection(-ray.Direction, hitNormal);
              incidentVect = incidentVect / norm(incidentVect);

              % Make reflection ray
              reflRay = Ray(Phit + hitNormal * reflBias, incidentVect, rayLength);

              % Cast reflection ray
              Ir = castRay(reflRay, objects, lightObjects, depth + 1);
           end

           % Tracer the transmission ray if Kt says so
           if hitObj.Kt > 0
               N = hitNormal;
               D = ray.Direction;
               
               if dot(D, N) < 0
                   N = N * -1;
               end

               [transVect, TIR] = getTransmissionVector(D, N, hitObj);
               
               % If total internal reflection, set the It to Ir
               if (TIR)
                   It = Ir;
               else
                   transVect = transVect / norm(transVect);

                   transmissionRay = Ray(Phit + N * reflBias, transVect, rayLength);
                   It = castRay(transmissionRay, objects, lightObjects, depth + 1);
               end
           end
           
           % Add base pixel color to reflection and tranmission colors
           pixelColor = pixelColor + hitObj.Kr * Ir + hitObj.Kt * It;
       end
    end 
end

% Calculates the incident reflection ray
% @param I              | Direction vector towards light source
% @param N              | Normal vector to reflect across
% @return refleVector   | The incident vector (Not normalized)
function reflVector = getIncidentReflection(I, N)
    % 2N(I*N) - I
    reflVector = 2 * N * dot(I, N) - I;
end

% Gets the transmission vector
% @param D incoming vector
% @param Normal
% @param object passing through
% @return tranmission vector
% @return boolean if the tranmission is Total Internal Refraction
function [transVector, TIR] = getTransmissionVector(D, N, obj)
    
    % Index of refraction air
    IORi = 1.0;
    IORt = obj.IOR;
    
    if dot(D, N) < 0
       IORi = obj.IOR;
       IORt = 1.0;
   end
    
    Nit = IORi / IORt;
    
    discriminate = 1 + (Nit^2 * (dot(D, N)^2 - 1));
    if discriminate < 0
        TIR = true;
        transVector = inf;
    else
        TIR = false;
        transVector = (Nit * D) + ((Nit * dot(D, N)) - sqrt(discriminate)) * N;
    end
end



