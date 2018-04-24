function [dehexed] = dehexer(hexed)
    len = length(hexed);
    dehexed = '';
    for i = 1 : len;
        binstr = dec2bin(hexed(i));
        blen = length(binstr);
        diff = 16 - blen;
        tmp = '000000000000';
        if diff ~= 0
            for k = diff + 1 : 16
                tmp(k) = binstr(k - diff);
            end
            binstr = tmp;
        end
        dehexed = [dehexed, binstr];
    end
    dehexed = regexprep(dehexed,'^0*','');
    dehexed = fliplr(dehexed);
    dehexed(dehexed ~= '0' & dehexed ~= '1') = '0';
end
