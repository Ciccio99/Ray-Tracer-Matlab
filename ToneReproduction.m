% Simple class maintain enumerables for the TR operators
classdef ToneReproduction
    enumeration
        Perceptual, Photographic
    end
    methods (Static)
        % Calculate ward operator
        % @param luminance matrix
        % @param Ldmax
        % @param Lmax
        % @retrun scaling factor
        function sf = calculateWardOperator(Lmat, Ldmax, Lmax)
            Lwa = ToneReproduction.calculateLwa(Lmat);
            sf = ((1.219 + (Ldmax / 2)^0.4) / (1.219 + Lwa^0.4))^2.5;
        end
        
        % Calculate reinhard operator
        % @param image matrix
        % @param Ldmax
        % @param Lmax
        % @retrun final image TR matrix
        function final_matrix = calculateReinhardOperator(im_matrix, Lmat, Ldmax)
            a = 0.18;
            Lwa = ToneReproduction.calculateLwa(Lmat);
            scaled_matrix = im_matrix .* a ./ Lwa;
            target_matrix = scaled_matrix ./ (scaled_matrix + 1) * Ldmax;
            final_matrix = target_matrix;
        end
        
        % Calculate Lwa element for TR
        % @param luminance matrix
        % @return Lwa variable
        function Lwa = calculateLwa(Lmat)
            [height, width, useless] = size(Lmat);
            Lwa = 0;
            for y = 1:height
                for x = 1:width
                    Lwa = Lwa + log(1e-10 + Lmat(y, x));
                end
            end
            Lwa = Lwa / (height * width);
            Lwa = exp(Lwa);
        end
    end
end