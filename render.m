% https://www.scratchapixel.com/lessons/3d-basic-rendering/ray-tracing-generating-camera-rays/generating-camera-rays

% Main renderer for ray tracer. Sets up important variables such as screen
% size and whether or not to add tone reproduction
% @param objects in scene
% @param light objects in scene
function render(objects, lightObjects)
    im_width = 640;
    im_height = 480;
    im_aspect_ratio = im_width / im_height;
    
    % TR variables
    Ldmax = 500;
    Lmax = 10;
    
    % Holds the enumerable signifying the TR operator
    whichTR = ToneReproduction.Photographic;
    
    % Set to true if you want tone reproduction
    withTR = false;
    
    % Starting ray tracer depth ( start at 0)
    startDepth = 0;
    % Max Ray length
    rayLength = 10000;
    % FOV in degrees
    FOV = 90;
    
    scale = tan(deg2rad(FOV * 0.5));
    
    % Matrix to store the image
    im_matrix  = zeros(im_height, im_width, 3);
    
    % MAtrix to store the TR luminance image
    Luminance_Matrix = zeros(im_height, im_width);
    
    rayOrigin = [ 0 0 0 ];
    
    % Initiate raytracing
    for y = 1:im_height
        pixel_ndc_y = (y + 0.5 ) / im_height;
        pixel_screen_y = (1 - 2 * pixel_ndc_y) * scale;
        for x = 1:im_width
            pixel_ndc_x = (x + 0.5) / im_width;
            pixel_screen_x = (2 * pixel_ndc_x - 1) * im_aspect_ratio * scale;
            
            
            
            % Pixel in camera space on the image place
            pixel_cam = [pixel_screen_x, pixel_screen_y, -5];    
            
            % Direction from camera/ray origin to image plane pixel
            rayDir = pixel_cam - rayOrigin;
            
            % Normalize Ray direction
            rayDir = rayDir / norm(rayDir);
            
            % Create a new ray object
            ray = Ray(rayOrigin, rayDir, rayLength);
            
            hitColor = castRay(ray, objects, lightObjects, startDepth);
            % Add color to image matrix
            im_matrix(y, x, :) = hitColor;
            
            % Add luminance value to TR matrix
            Luminance_Matrix(y, x) = dot(hitColor / Lmax, [0.27; 0.67; 0.06]);
            
        end
    end
    % Calculate TR operator
    if withTR == true
        if(whichTR == ToneReproduction.Perceptual)
            sf = ToneReproduction.calculateWardOperator(Luminance_Matrix, Ldmax, Lmax);
            RTargetMatrix = im_matrix * sf;

            % Apply Device model
            RTargetMatrixFinal = RTargetMatrix / Ldmax;
            figure, imshow(RTargetMatrixFinal);
        else
            reinhard_im = ToneReproduction.calculateReinhardOperator(im_matrix, Luminance_Matrix, Ldmax);
            figure, imshow(reinhard_im);
        end
    end
    
    
    % Displays the final ray traced rendering
    figure, imshow(im_matrix);
end
