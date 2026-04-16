%% interpolator TB: generate & compare complex exponential
% This program is for generate fixed point signal & writes it into files,
% in order to introduced to the Hardware implementation and the comparison.
clc; clear; close all;
set(0,'DefaultFigureWindowStyle','docked');

DATA_WIDTH = 16;
FRAC_BITS = 13;
INT_BITS = DATA_WIDTH-FRAC_BITS;
file_format = '.dat';
savePath = './test_data/';
file_name = 'data_in';
file_config = 'config';
result_file_name = 'data_result.dat';

fxd_type = fi([],1, DATA_WIDTH, FRAC_BITS);
DT_flt = mytypes_D4('single');

%% Parameters
interpFactor  = 16;

% Test Signal
generate_data

% señal de prueba
load("data_noise.mat");

%% interpolation algorithm
% Fixed
xn_fxd = cast(xn', 'like', fxd_type);

fi2file(xn_fxd, [savePath ,file_name, file_format]);

% inpol2 D4
fxd_config_type = fi([], 1, 32, 31);
invU = (1/interpFactor);
invU2 = (1/(interpFactor)^2);
signalLen = numel(xn);
interpLen = (N-5)*interpFactor;

config_file(signalLen, interpFactor, interpLen, [savePath ,'config.dat'])

% fiTypes = mytypes_D4('fixed');
% y_fi = intpol2_D4_types(xn_fxd, invU, invU2, interpFactor, signalLen, interpLen,fiTypes);

%%<======================== Break point here
result_fxd_hw = funcfile2Vector(DATA_WIDTH, FRAC_BITS, [savePath,result_file_name]);

y_fxd_hw = single(result_fxd_hw)';

% float
fiTypes = mytypes_D4('single');
y_flt = intpol2_D4_types(xn, invU, invU2, interpFactor, signalLen, interpLen, fiTypes);

figure(1)
plot(t, xn,'o');
hold on;
plot(t2(1:interpLen), y_flt(1:interpLen), '-sqk', t2(1:interpLen), y_fxd_hw,'*--');
legend('data points','sw','hw')
xlim([0 T/interpFactor]);
title(['Interpolation factor: ',num2str(interpFactor)],'Interpreter','latex')


% SQNR
sqnr = SQNR_eval(y_flt(1:interpLen), y_fxd_hw)

