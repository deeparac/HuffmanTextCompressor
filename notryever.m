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
symbols = double(symbols);
probs = [probs(idx)];

[dict,avglen] = huffmandict(symbols, probs);
enco = huffmanenco(content,dict);

enco = num2str(enco');
enco(enco == ' ') = [];

comp = hexer(enco);

fid = fopen('compressed.txt', 'wb');
fwrite(fid, comp, 'uint16');
fclose(fid);

fid = fopen('compressed.txt','rb');
recon = fread(fid, inf, 'uint16')';
recon = uint16(recon);
fclose(fid);

recon = dehexer(recon);
recon_vector = numify(recon);

deco = huffmandeco(recon_vector,dict);
equal = isequal(content,deco);

fid = fopen('recon.txt', 'wt');
fprintf(fid, '%s', deco);
fclose(fid);