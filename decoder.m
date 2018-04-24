function [recon] = decoder(comp, map)
    enco = dehexer(comp);
    fprintf('binary string converted.\n');
    
    fprintf('decoding progress working on...\n');
    len = length(enco);
    recon = '';
    code = '';
    i = 1;
    percent = 5;
    rid = 1;
    while i <= len
        if uint16(i / len * 100) == percent
            fprintf('current decoding progress: %d%%\n', percent);
            percent = percent + 5;
        end
        code = [code, enco(i)];
        if isKey(map, code) == 1
            recon(rid) = map(code);
            rid = rid + 1;
            code = '';
        end
        i = i + 1;
    end
    fprintf('everything done well so far, check recon.txt out now!\n');
end