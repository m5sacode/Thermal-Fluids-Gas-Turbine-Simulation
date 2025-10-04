function [idx] = findvalue(vector, value)
    idx = 1;

    while idx <= length(vector)
        if value < vector(idx)
            break
        else
            idx = idx + 1;
        end
    end
end