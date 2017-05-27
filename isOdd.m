% Small function to check for odd numbers
% @param number
% @return true if odd, else false
function bool = isOdd(num)
    bool = false;
    if mod(num,2) ~= 0
        bool = true;
    end
end