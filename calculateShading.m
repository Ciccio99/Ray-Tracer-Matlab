% Calculates the shading for the given pixel
% @param obj
% @param hit point
% @param objects
% @param light objects
% @param ray 
% @return final luminance
function finalL = calculateShading(obj, Phit, objects, lights, ray)
    hitNorm = obj.getHitNormal(Phit);
    hitNorm = hitNorm / norm(hitNorm);
    viewVect = -ray.Direction;
    viewVect = viewVect / norm(viewVect);

    % Bias variable so that shadow ray doesn't intersect it's own object
    shadowBias = 1e-6;

    % Ambient light calc
    
    % Calculate shading for all of the lights
    for light = lights
        lightDir = light.Position - Phit;
        lightDir = lightDir / norm(lightDir);


        % Cast Shadow Ray
        shadowRay = Ray(Phit + hitNorm * shadowBias, lightDir, 10000); 
        [hitBool, t, hitObj] = trace(shadowRay, objects);
        
        % if object is a plane, don't calculalate phong shading. Only
        % render the texture
        if isa(obj, 'Plane')
            texColor = obj.getTextureColor(Phit);
            finalL = texColor;
            
            % If shadow ray intersects, than multiply texColor by ambient
            % coef
            if hitBool
                finalL = texColor * obj.Ka;
            end
        else
            albedo = obj.Albedo;
            La = obj.Ka * obj.Ambient .* albedo;
            Ld = zeros(1, 3);
            Ls = zeros(1, 3);
            
            % If an object is hit before the light, don't calculate diff & spec
            if (~hitBool)
                % Reflection Vector
                Refl = reflectVector(-lightDir, hitNorm);
                Refl = Refl / norm(Refl);

                % Diffuse  
                Ld = Ld + ( ( albedo .* light.Color ) * max( 0, dot( lightDir, hitNorm ) ) );

                % Specular
                Ls = Ls + ( light.Color .* obj.SpecColor ) * max( 0, dot( Refl, viewVect )^obj.Ke );

            end

            finalL = La + (Ld * obj.Kd) + (Ls * obj.Ks); 
        end
     end
end


% Reflects a given vector along a normal point
% @param inVect    | The in Vector
% @param inNormal  | The normal point to reflect across
% @return reflVect | Reflection Vector
function reflVect = reflectVector(d, n)
    reflVect = d - ( 2 * dot(d, n) * n );
end