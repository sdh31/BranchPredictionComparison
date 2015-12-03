%% ECE 552
% Percentage Misses vs. Hardware Cost

%% Importing csv-files
clear; close all; clf

fid = fopen('TwoLevelGshareData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
gshare_percentage = C{7}.*100./C{8}; % percentage mispredicted

fid = fopen('PerceptronData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
perceptron_percentage = C{7}.*100./C{8}; % percentage mispredicted

fid = fopen('PiecewiseLinearData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
piecewise_percentage = C{7}.*100./C{8}; % percentage mispredicted

benchmarks = categories(categorical(C{1})); % name of benchmarks
hardware = [1 2 4 8 16 32 64]; % hardware cost in KB

%% Reshaping the Data
gshare_percentage = reshape(gshare_percentage, 7, [])';
perceptron_percentage = reshape(perceptron_percentage, 7, [])';
piecewise_percentage = reshape(piecewise_percentage, 7, [])';

for i=1:5
    figure(i)
    plot(hardware, gshare_percentage(i,:), 'k-')
    graph_title = strcat('Hardware vs. Percent Mispredict for', {' '}, benchmarks(i));
    title(graph_title)
    xlabel('Hardware Cost (KB)')
    ylabel('Percent Mispredict')
    hold on
    plot(hardware, perceptron_percentage(i,:), 'r-')
    plot(hardware, piecewise_percentage(i,:), 'b-')
    hold off
    legend('Gshare', 'Perceptron', 'Piecewise Linear', 'Location', 'Best')
    
    filename = char(strcat('hardware_analysis_', benchmarks(i), '.png'));
    saveas(gcf, filename, 'png')
end

