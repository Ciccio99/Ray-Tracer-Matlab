% Main entry point into the ray tracer.
%
% RUN THIS FILE TO START THE RAY TRACER PROGRAM
%
function mainRayTracer ()
    % Instantiation of objects/scene
    % Spheres
   %     glassSphere      = Sphere([0,   2, -28],   3.0, [1.0 1.0 1.0], [1.0 1.0 1.0], [1 1 1],  0.075, 0.075, 0.2, 20, 0.01, 0.8, 0.95);
    glassSphere      = Sphere([0,   2, -28],   3.0, [1.0 1.0 1.0], [1.0 1.0 1.0], [1 1 1],  0.075, 0.075, 0.2, 20, 0.75, 0, 0);
    reflectiveSphere = Sphere([-5, -0.5, -55], 3.3, [0.7 0.7 0.7], [0.7 0.7 0.7], [1 1 1],  0.15,  0.25,  0.1,   20, 0.75, 0,   0);

    % Plane
    plane = Plane([-25, -8, -600], [0,1,0], 75, 1400, [1 1 1], [1 0 0], [1 1 1], 0.5, 0.99, 0.01, 10, 0, 0, 0);
    
    % Point light
    pointLight1 = PointLight([-2, 12, 20], [1 1 1]);
    
    % Placing objects into a cell array (allows for different Classes in
    % the array)
    objects = {glassSphere, reflectiveSphere, plane};
    
    % Lights in an array
    lightObjects = (pointLight1);
    
    % Tic and toc is how you time functions in matlab (pretty convenient).
    % Tic starts the counter, tic reports the final stopwatch time
    tic
    render(objects, lightObjects);
    toc
end