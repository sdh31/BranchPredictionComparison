%% ECE 552
% Plotting 2 Level Predictor Data

%% Importing csv-file
clear; close all; clf

fid = fopen('TwoLevelData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);

benchmarks = categories(categorical(C{1})); % name of benchmarks
type = categories(categorical(C{2})); % type of predictor
width = C{5};
MPKI = C{7}./(C{8}/1000); % misses per thousand instructions

%% Displaying Data
MPKI_bar = reshape(MPKI, 15, [])';
config = categories(categorical(strcat(C{2}, num2str(C{5}))));

figure(1)
bar(MPKI_bar)
set(gca, 'XTickLabel', benchmarks)
ylabel('MPKI')
xlabel('Benchmarks')
title('MPKI per Benchmark for All Predictor Type')
legend(config, 'Location', 'Best')

%% Determining the Effects of Width
figure(2)
bar3(MPKI_bar)
zlabel('MPKI')
ylabel('Benchmark')
xlabel('Configurations')

set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)