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

%% 2D Representation of All Configurations
figure(1)
bar(MPKI_bar)
set(gca, 'XTickLabel', benchmarks)
ylabel('MPKI')
xlabel('Benchmarks')
title('MPKI per Benchmark for All Predictor Type')
legend(config, 'Location', 'Best')

%% 3D Representation of All Configurations
figure(2)
bar3(MPKI_bar)
zlabel('MPKI')
ylabel('Benchmark')
xlabel('Configurations')

set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)

%% Comparing Schemes with Same Length
figure(3)
colors = ['b', 'm', 'c', 'r', 'g', 'b'];
syms = ['o', 'x', 's', '+', 'd', '*', 'v', 'p'];
MPKI_matrix = reshape(MPKI, 5, 3, 5);
for i=1:5
    for j=1:3
        col_index = randi(6,1);
        sym_index = randi(8,1);
        colsym = [colors(col_index), syms(sym_index)];
        scatter(width(1:5), MPKI_matrix(:,j,i), colsym)
        hold on
    end
end
xlabel('Width')
ylabel('MPKI')
hold off