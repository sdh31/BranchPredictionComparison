%% ECE 552
% Percentage Misses vs. Hardware Cost

%% Importing csv-file
clear; close all; clf

fid = fopen('TwoLevelDataGshare.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);

benchmarks = categories(categorical(C{1})); % name of benchmarks
width = categories(categorical(C{5})); % shift width
percentage = C{7}.*100./C{8}; % percentage mispredicted
hardware = [1 2 4 8 16 32 64]; % hardware cost in KB

%% Displaying Data
percentage_bar = reshape(percentage(1:2:end), 6, [])';
percentage_bar_xor = reshape(percentage(2:2:end), 6, [])';
config = categories(categorical(strcat(C{2}, num2str(C{5}))));

%% 2D Representation of PAp Configuration - 2 Level 
figure(1)
% bar(percentage_bar)
% set(gca, 'XTickLabel', benchmarks)
% legend(config, 'Location', 'BestOutside')
% ylabel('Percent Mispredicted')
% xlabel('Benchmarks')
% title('Percent Mispredicted per Benchmark for PAp Configuration - 2 Level')
 
print('2d_2lev_PAp_benchmark', '-djpeg')
