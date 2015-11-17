%% ECE 552
% Plotting 2 Level Predictor Data

%% Importing csv-file
clear; close all; clf

fid = fopen('TwoLevelData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);

% swapping columns for easier sorting
% cellHolder = C{6};
% C{6} = C{8};
% C{8} = cellHolder;

benchmarks = categories(categorical(C{1})); % name of benchmarks
type = categories(categorical(C{2})); % type of predictor
width = C{5};
MPKI = C{7}./(C{8}/1000); % misses per thousand instructions

%[sortA, sortI] = sort(C{8});
% for i=1:7
%     sort(C{i}
%sortedC = C(sortI, :);

%% Displaying Data
MPKI_bar = reshape(MPKI(1:2:150), 15, [])';
MPKI_bar_xor = reshape(MPKI(2:2:150), 15, [])';
config = categories(categorical(strcat(C{2}, num2str(C{5}))));

%% 2D Representation of All Configurations - 2 Level 
figure(1)
bar(MPKI_bar)
set(gca, 'XTickLabel', benchmarks)
legend(config, 'Location', 'BestOutside')
ylabel('MPKI')
xlabel('Benchmarks')
title('MPKI per Benchmark for All Predictor Type - 2 Level')

print('2d_2lev_benchmark', '-djpeg')

%% 3D Representation of All Configurations - 2 Level
figure(2)
bar3(MPKI_bar)
zlabel('MPKI')
ylabel('Benchmark')
xlabel('Configurations')
title('3D Representation - 2 Level')
set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)

print('3d_2lev_benchmark', '-djpeg')

%% 2D Representation of All Configurations - gshare 
figure(3)
bar(MPKI_bar_xor)
set(gca, 'XTickLabel', benchmarks)
legend(config, 'Location', 'BestOutside')
ylabel('MPKI')
xlabel('Benchmarks')
title('MPKI per Benchmark for All Predictor Type - gshare')

print('2d_gshare_benchmark', '-djpeg')

%% 3D Representation of All Configurations - gshare
figure(4)
bar3(MPKI_bar_xor)
zlabel('MPKI')
ylabel('Benchmark')
xlabel('Configurations')
title('3D Representation - gshare')
set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)

print('3d_gshare_benchmark', '-djpeg')