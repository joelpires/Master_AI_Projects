function [out] = convertClasses(scenario, Y)
    [I,~] = size(Y);
    if scenario == 'A'
        for i = 1:I
            if Y(i) == 14
                Y(i) = 2;
            else
                Y(i) = 1;
            end
        end
    elseif scenario == 'B'
        for i = 1:I
            if Y(i) == 0 || Y(i) == 1 || Y(i) == 2 || Y(i) == 3 || Y(i) == 4 || Y(i) == 5 || Y(i) == 7 || Y(i) == 8
                Y(i) = 1;
            elseif Y(i) == 9 || Y(i) == 10 || Y(i) == 15 || Y(i) == 16
                Y(i) = 2;
            elseif Y(i) >= 33 && Y(i) <= 40
                Y(i) = 3;
            elseif Y(i) == 6 || Y(i) == 32 || Y(i) == 41 || Y(i) == 42
                Y(i) = 4;
            elseif Y(i) == 14 || Y(i) == 12 || Y(i) == 13 || Y(i) == 17
                Y(i) = 6;
            else
                Y(i) = 5;
            end
        end
    else
        for i = 1:I
            Y(i) = Y(i) + 1;
        end
    end
    
    out = Y;
end

