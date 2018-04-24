function vec = numify(instr)
    for i = 1 : length(instr)
        if instr(i) == '0'
            vec(i) = 0;
        else
            vec(i) = 1;
        end
    end
end
