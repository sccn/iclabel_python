% this script compares the MATLAB and Python version of the function
pyenv('Version', '/Users/arno/miniconda3/envs/p39env/bin/python');

% call Python function
system('/Users/arno/miniconda3/envs/p311env/bin/python eeg_rpsd_compare_helper.py');
res = load('eeg_rpsd_data.mat');
%delete('eeg_rpsd_data.mat');

% call EEGLAB function
if ~exist('pop_loadset')
    addpath('~/eeglab');
end
eeglabpath = which('eeglab.m');
eeglabpath = eeglabpath(1:end-length('eeglab.m'));
EEG = pop_loadset(fullfile(eeglabpath, 'sample_data', 'eeglab_data_epochs_ica.set'));
temp2 = eeg_rpsd(EEG, 100);

%% compare the two
figure('position', [924   752   912   565])

subplot(2,2,1);
imagesc(temp2); title('MATLAB'); 
cl = clim;
ylabel('Component index')
title('MATLAB');

subplot(2,2,3);
imagesc(res.grid); title('Python'); 
xlabel('Frequency (Hz)')
ylabel('Component index')
clim(cl)
title('Python');
cbar;

subplot(2,2,2);
imagesc(temp2-res.grid); 
clim(cl-mean(cl))
title('Difference');
cbar;

subplot(2,2,4);
imagesc(temp2-res.grid); 
xlabel('Frequency (Hz)')
cl = clim;
clim(cl-mean(cl))
title('Magnified difference');
cbar;

setfont(gcf, 'fontsize', 20)
set(gcf, 'color', 'w')
set(gcf, 'PaperPositionMode', 'auto');
print('-djpeg', 'ersp_diff.jpg')
print('-depsc', 'ersp_diff.eps')

compare_variables(temp2, res.grid);
