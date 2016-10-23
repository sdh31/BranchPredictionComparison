%% ECE 552
% Plotting 2 Level PAp Configuration Data

%% Importing csv-file
clear; close all; clf

fid = fopen('TwoLevelDataLonger.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);

benchmarks = categories(categorical(C{1})); % name of benchmarks
width = C{5};
percentage = C{7}.*100./C{8}; % misses per thousand instructions

%% Displaying Data
percentage_bar = reshape(percentage(1:2:end), 6, [])';
percentage_bar_xor = reshape(percentage(2:2:end), 6, [])';
config = categories(categorical(strcat(C{2}, num2str(C{5}))));

%% 2D Representation of PAp Configuration - 2 Level 
figure(1)
bar(percentage_bar)
set(gca, 'XTickLabel', benchmarks)
legend(config, 'Location', 'BestOutside')
ylabel('Percent Mispredicted')
xlabel('Benchmarks')
title('Percent Mispredicted per Benchmark for PAp Configuration - 2 Level')
 
print('2d_2lev_PAp_benchmark', '-djpeg')

%% 3D Representation of PAp Configurations - 2 Level
figure(2)
bar3(percentage_bar)
zlabel('Percent Mispredicted')
ylabel('Benchmark')
xlabel('Configurations')
title('3D Representation PAp Configuration - 2 Level')
set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)

print('3d_2lev_PAp_benchmark', '-djpeg')

%% 2D Representation of PAp Configurations - gshare 
figure(3)
bar(percentage_bar_xor)
set(gca, 'XTickLabel', benchmarks)
legend(config, 'Location', 'BestOutside')
ylabel('Percent Mispredicted')
xlabel('Benchmarks')
title('Percent Mispredicted per Benchmark for PAp Configuration - gshare')

print('2d_gshare_PAp_benchmark', '-djpeg')

%% 3D Representation of All Configurations - gshare
figure(4)
bar3(percentage_bar_xor)
zlabel('Percent Mispredicted')
ylabel('Benchmark')
xlabel('Configurations')
title('3D Representation PAp Configuration - gshare')
set(gca, 'YTickLabel', benchmarks)
set(gca, 'XTickLabel', config)

print('3d_gshare_PAp_benchmark', '-djpeg')