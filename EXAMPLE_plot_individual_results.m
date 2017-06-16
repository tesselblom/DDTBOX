% EXAMPLE_plot_indiv_results.m
%
% This script is used for plotting single subject results of 
% classifier accuracy/SVR performance.
% Please make copies of this script for your own projects.
%
% More information about the plotting settings in this script can be found
% in the DDTBOX Wiki, available at: https://github.com/DDTBOX/DDTBOX/wiki
%
% This script calls display_indiv_results_erp
%
%
% Copyright (c) 2013-2017, Daniel Feuerriegel and contributors 
% 
% This file is part of DDTBOX.
%
% DDTBOX is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.



%% Filepaths of Single Subject Results Files
% The following variables are used to locate the saved single subject results files

% Select subject datasets to plot, e.g. [1:10] for first ten subjects
sbj_todo = [1:10];

% Specify directory in which results were saved
output_dir = '/Users/danielfeuerriegel/Desktop/Decoding Results';

% Name of the study
study_name = 'EXAMPLE';

% Name of the discrimination group
dcg_labels{1} = 'Correct vs. Error';
dcg_labels{2} = ''; % Use this second entry when plotting cross-decoding results

% Decoding parameters
cross = 0; % Specify whether cross-decoding was performed (1 = Yes / 0 = No)
analysis_mode = 1; % ANALYSIS mode (1=SVC with LIBSVM / 2=SVC with liblinear / 3=SVR with LIBSVM)
stmode = 3; % SPACETIME mode (1=spatial / 2=temporal / 3=spatio-temporal)
avmode = 1; % AVERAGE mode (1=no averaging; single-trial / 2=run average) !!! need single trials for SVR !!!
window_width_ms = 10; % width of sliding window in ms
step_width_ms = 10; % step size with which sliding window is moved through the trial

% Create labels based on SVM method used
switch analysis_mode
    case 1 % SVC with LIBSVM
        analysis_mode_label = 'SVM_LIBSVM';
    case 2 % SVC with LIBLINEAR
        analysis_mode_label = 'SVM_LIBLIN';
    case 3 % SVR with LIBSVM
        analysis_mode_label = 'SVR_LIBSVM';
end % of avmode switch



%% Settings for Plotting Decoding Performance Results

PLOT.perm_disp = 1; % display the results from permuted labels decoding in figure as separate line? 0=no / 1=yes

% Temporal decoding results settings
PLOT.channellocs = ['/Users/danielfeuerriegel/Desktop/DDTBOX Project/MVPA_WORKSHOP/locations/']; % Path of directory containing channel information file
PLOT.channel_names_file = 'channel_inf_flanker.mat'; % Name of .mat file containing channel labels and channel locations
PLOT.temporal_decoding_colormap = 'jet'; % Colormap for temporal decoding results scalp maps

% figure position on the screen
PLOT.FigPos = [100 100 800 400]; % Default [100 100 800 400]

% Figure title settings
PLOT.TitleFontSize = 14; % Default 14
PLOT.TitleFontWeight = 'Bold'; % 'Normal' (Regular) or 'Bold'



%% Decoding Performance X and Y Axis Properties

% Axis label properties
PLOT.xlabel.FontSize = 12; % Default 12
PLOT.ylabel.FontSize = 12; % Default 12
PLOT.xlabel.FontWeight = 'Bold'; % 'Normal' (Regular) or 'b' / 'Bold'
PLOT.ylabel.FontWeight = 'Bold'; % 'Normal' (Regular) or 'b' / 'Bold'



%% Define Properties of Lines Showing Decoding Performance

% Actual decoding results
PLOT.Res.Line = '-ks'; % Line colour and style. Default '-ks'
PLOT.Res.LineWidth = 2; % Default 2
PLOT.Res.MarkerEdgeColor = 'k'; % Default 'k' (black)
PLOT.Res.MarkerFaceColor = 'w'; % Default 'w' (white)
PLOT.Res.MarkerSize = 5; % Default 5

% Properties of line showing permutation / chance results
PLOT.PermRes.Line = '-ks'; % Line colour and style. Default '-ks'
PLOT.PermRes.LineWidth = 2; % Default 2
PLOT.PermRes.MarkerEdgeColor = 'b'; % Default 'b' (blue)
PLOT.PermRes.MarkerFaceColor = 'w'; % Default 'w' (white)
PLOT.PermRes.MarkerSize = 5; % Default 5



%% Decoding Performance Plot Annotations

% Define properties of line showing event onset
PLOT.PointZero.Color = 'r'; % Colour of line denoting event onset. Default 'r' (red)
PLOT.PointZero.LineWidth = 3; % Width of line denoting event onset. Default 3



%% Plot the Classification Accuracy/SVR Performance Results

for sbj = sbj_todo % Plot for all selected subjects

    if cross == 0 % If not using cross-decoding
        
        % Load single subject results file
        load([output_dir, '/', study_name, ...
            '_SBJ', int2str(sbj), ...
            '_win', int2str(window_width_ms), ...
            '_steps', int2str(step_width_ms), ...
            '_av', int2str(avmode), ...
            '_st', int2str(stmode), ...
            '_', analysis_mode_label, '_DCG', dcg_labels{1} '.mat']);
        
    elseif cross == 1 % If using cross-decoding
        
        load([output_dir, '/', study_name, ...
            '_SBJ', int2str(sbj), ...
            '_win', int2str(window_width_ms), ...
            '_steps', int2str(step_width_ms), ...
            '_av', int2str(avmode), ...
            '_st', int2str(stmode), ...
            '_', analysis_mode_label, '_DCG', dcg_labels{1}, 'toDCG', dcg_labels{2}, '.mat']);
        
    end % of if cross
    
    % Overwrite selected cfg settings related to plotting results
    cfg.perm_disp = PLOT.perm_disp;
    cfg.pointzero = pointzero;
    
    % Plot the single subject results
    display_indiv_results_erp(cfg, RESULTS, PLOT);

end % of for sbj