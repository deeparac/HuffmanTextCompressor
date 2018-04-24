function [comp, map, avglen] = encoder(file_path)
    fid = fopen(file_path, 'r');
    content = fread(fid, inf, 'uchar');
    fclose(fid);

    % calculate symbols' probs
    probs = get_probs(content);

    % filter out 0-prob symbols
    idx = find(probs~=0);
    symbols = char(0:255);
    symbols = [symbols(idx)];
    probs = [probs(idx)];
    
    % sort in order to match prob and l_codeword to minimize avglen
    [probs, sprobs_idx] = sort(probs);
    symbols = symbols(sprobs_idx);
    
    fprintf('start huffman dictionary builder.\n');
    [codewords, map] = dict(symbols, probs);
    fprintf('dict generated!\n');

    % avglen = sum(probs .* L_codewords)
    for j = 1 : length(codewords)
        tmp(j) = size(codewords{j}, 2);
    end
    avglen = probs * tmp';
    fprintf('the average code length is %f!\n', avglen);
    
    
    % encoding process
    fprintf('start encoding process.\n');
    enco = '';
    clen = length(content);
    percent = 5;
    for i = 1 : clen
        % search for codes
        if uint32(percent / 100 * clen) == i
            fprintf('current encoding progress: %d%%\n', percent);
            percent = percent + 5;
        end
        character = content(i);
        idx = find(symbols==character);
        codes = num2str(codewords{idx});
        % clear spacing
        codes(codes == ' ') = [];
        % concatenation
        % this part is insanely slow!
        % cannot find suitable way to optimize it
        % why built-in matlab function so fast!
        enco = [enco codes];
    end
    
    % further encoding in uint16 format to minimize file size.
    % one problem is that I have achieved avglen as 4.6 which
    % is comparable to built-in function, but the real problem 
    % is to store binary string efficiently. If I just store binary
    % string, then it takes megabytes; however, in uint16 format,
    % it only takes 227kb. This part is not about how encoding 
    % algorithm works, but the data format. What annoying is that this
    % matters most in grade. The same binary string but different in size.
    % most of time I spent tuning hexer & dehexer function rather than
    % huffman algorithm.
    comp = hexer(enco);
    fprintf('encoding part done!\n');
end

