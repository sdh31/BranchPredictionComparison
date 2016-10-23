%% ECE 552
% Percentage Misses vs. Hardware Cost

%% Importing csv-files
clear; close all; clf; 

fid = fopen('TwoLevelGshareData.csv');
C = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
gshare_percentage = C{7}.*100./C{8}; % percentage mispredicted

fid = fopen('PerceptronData.csv');
D = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
perceptron_percentage = D{7}.*100./D{8}; % percentage mispredicted

fid = fopen('PiecewiseLinearData.csv');
E = textscan(fid, '%s %s %f %f %f %f %f %f', 'Delimiter', ',', 'EmptyValue', -Inf);
fclose(fid);
piecewise_percentage = E{7}.*100./E{8}; % percentage mispredicted

benchmarks = categories(categorical(C{1})); % name of benchmarks
hardware = [1 2 4 8 16 32 64]; % hardware cost in KB

%% Reshaping the Data
gshare_percentage = reshape(gshare_percentage, 7, [])';
perceptron_percentage = reshape(perceptron_percentage, 7, [])';
piecewise_percentage = reshape(piecewise_percentage, 7, [])';

figure(1)
 ap = get(gca, 'position');
for i=1:5
    
    if(i<=4)
        subplot(3,2,i)
       
    else
        sh = subplot(3,2,5);
        sp = get(sh, 'position');
        set(sh, 'position', [sp(1)+.5*(ap(3)-sp(3)), sp(2:end)]);
    end
    
    plot(hardware, gshare_percentage(i,:), 'k^-')
    graph_title = strcat('Hardware vs. Percent Mispredict for', {' '}, benchmarks(i));
    title(graph_title)
    xlabel('Hardware Cost (KB)')
    ylabel('Percent Mispredict')
    hold on
    plot(hardware, perceptron_percentage(i,:), 'rx-')
    plot(hardware, piecewise_percentage(i,:), 'bo-')
    hold off
    
    if(i==5)
    h = legend('Gshare', 'Perceptron', 'Piecewise Linear');
    pos = get(h, 'position');
    set(h, 'position', [pos(1)+0.3 pos(2)-0.05 0.123 0.1])
    end

end

print('hardware_analysis_combined', '-djpeg')

%% Quantitative Analysis
gshare_perceptron = abs(gshare_percentage - perceptron_percentage);
gshare_piecewise = abs(gshare_percentage - piecewise_percentage);
perceptron_piecewise = abs(perceptron_percentage - piecewise_percentage); 

fileID = fopen('quantitative_analysis.txt', 'w');
for j=1:5
    fprintf(fileID, 'Percentage Difference Between gshare and perceptron for %s\n', char(benchmarks(j)));
    fprintf(fileID, '%7.2f %%', gshare_perceptron(j,:));
    fprintf(fileID, '\n');
    fprintf(fileID, 'Percentage Difference Between gshare and piecewise for %s\n', char(benchmarks(j)));
    fprintf(fileID, '%7.2f %%', gshare_piecewise(j,:));
    fprintf(fileID, '\n');
    fprintf(fileID, 'Percentage Difference Between perceptron and piecewise for %s\n', char(benchmarks(j)));
    fprintf(fileID, '%7.2f %%', perceptron_piecewise(j,:));
    fprintf(fileID, '\n');
end

fclose(fileID);

%% Visualization of Average Percentage Differences
gshare_avg = sum(reshape(C{7}, 7, [])',2)./sum(reshape(C{8}, 7, [])',2)*100;
perceptron_avg = sum(reshape(D{7}, 7, [])',2)./sum(reshape(D{8}, 7, [])',2)*100;
piecewise_avg = sum(reshape(E{7}, 7, [])',2)./sum(reshape(E{8}, 7, [])',2)*100;

bar_diff = [gshare_avg perceptron_avg piecewise_avg];

figure(2)
bar(bar_diff)
set(gca, 'XTickLabel', benchmarks)
config = {'gshare', 'perceptron', 'piecewise'};
legend(config, 'Location', 'Best')
ylabel('Average Mispredict Percentage')
xlabel('Benchmarks')
title('Average Mispredict Percentage per Benchmark for All Configurations')

print('average_mispredict_percentages', '-djpeg')