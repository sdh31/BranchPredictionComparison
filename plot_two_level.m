%% ECE 552
% Plotting 2 Level Predictor Data

%% Importing csv-file
clear; close all

fid = fopen('TwoLevelData.csv');
C = textscan(fid, '%s %s %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);

benchmarks = categories(categorical(C{1})); % name of benchmarks
parameters = cellstr(C{2}); % benchmark parameters
MPKI = C{3}./(C{4}/1000); % misses per thousand instructions

%% Parsing Parameters
% Find GAg configurations
% GAg_index = find(~cellfun(@isempty,strfind(parameters, '2lev_1')))

MPKI = reshape(MPKI, 15, [])';

figure(1); clf
bar(MPKI)
set(gca, 'XTickLabel', benchmarks)
ylabel('MPKI')
xlabel('Benchmarks')