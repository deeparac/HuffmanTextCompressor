%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dump compressed text and map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;

% for time watching
tic;

filepath = 'original.txt';
[comp, map, avglen] = encoder(filepath);

savepath = 'compressed.txt';

fid = fopen(savepath, 'wb');
fwrite(fid, comp, 'uint16');
fclose(fid);
save('CodewordsMap', 'map');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only load compressed text and map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

savepath = 'compressed.txt';
load('CodewordsMap', 'map');
fid = fopen(savepath, 'rb');
comp = fread(fid, inf, 'uint16')';
comp = uint16(comp);
fclose(fid);

recon = decoder(comp, map);

fid = fopen('recon.txt', 'wt');
fprintf(fid, '%s', recon);
fclose(fid);

time_elapsed = toc;
fprintf('the total running time is %f\n', time_elapsed);