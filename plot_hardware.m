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

figure
 ap = get(gca, 'position');
for i=1:5
    
    if(i<=4)
        subplot(3,2,i)
       
    else
        sh = subplot(3,2,5)
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
    pos = get(h, 'position')
    set(h, 'position', [pos(1)+0.3 pos(2)-0.05 0.123 0.1])
    end

end

print('hardware_analysis_combined', '-djpeg')