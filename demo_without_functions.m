clear;
clc;

% file operation
file_path = "original.txt";
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

[probs, sprobs_idx] = sort(probs);
symbols = symbols(sprobs_idx);

[codewords, map] = dict(symbols, probs);

for j = 1 : length(codewords)
    tmp(j) = size(codewords{j}, 2);
end
avglen = probs * tmp'

enco = '';
clen = length(content);
percent = 1;
for i = 1 : clen
    % search for codes
    if uint32(percent / 100 * clen) == i
        fprintf('current encoding progress: %d%%\n', percent);
        percent = percent + 1;
    end
    character = content(i);
    idx = find(symbols==character);
    codes = num2str(codewords{idx});
    % clear spacing
    codes(codes == ' ') = [];
    % concatenation
    enco = [enco codes];
end

encobak = enco;
comp = hexer(enco);

fid = fopen('compressed.txt', 'wb');
fwrite(fid, comp, 'uint16');
fclose(fid);
save('CodewordsMap', 'map');

clear;
clc;

load('CodewordsMap', 'map');
fid = fopen('compressed.txt','rb');
comp = fread(fid, inf, 'uint16')';
comp = uint16(comp);
fclose(fid);

enco = dehexer(comp);

len = length(enco);
recon = '';
code = '';
i = 1;
percent = 1;
rid = 1;
while i <= len
    if uint16(i / len * 100) == percent
        fprintf('current decoding progress: %d%%\n', percent);
        percent = percent + 1;
    end
    code = [code, enco(i)];
    if isKey(map, code) == 1
        recon(rid) = map(code);
        rid = rid + 1;
        code = '';
    end
    i = i + 1;
end

fid = fopen('recon.txt', 'wt');
fprintf(fid, '%s', recon);
fclose(fid);