% Small function to check for even numbers
% @param number
% @return true if even, else false
function bool = isEven(num) 
    if mod(num, 2) == 0
        bool = true;
    else
        bool = false;
    end
end
