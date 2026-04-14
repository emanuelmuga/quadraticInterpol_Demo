clc; clear; close all;
set(0,'DefaultFigureWindowStyle','docked');

% Parametros
interpFactor = 16;    % factor de interpolacion
Fs = 2e3;            % Frecuencia de muestreo
T = 1;               % Tiempo de observacion

% Ejes
t  = 0:1/Fs:T-1/Fs;  
N = length(t);
Fs2 = Fs*interpFactor;
t2 = 0:(1/Fs2):T-1/Fs2;
N2 = length(t2);

% % señal de prueba
load("x_n.mat");
x = real(h_shift);

% otros métodos de interpolación
spline_interp = interp1(t,x,t2,'spline'); 
lineal_interp = interp1(t,x,t2,'linear');

% Algoritmo de interpolación cuadratica al vuelo
signalLen = numel(x);
interpLen = interpFactor*(signalLen-2);
invU = 1/interpFactor;
invU2 = (1/interpFactor)^2;
quad_interp_full = intpol2_full(x, signalLen, interpFactor, interpLen, invU, invU2);
quad_interp_suacc = intpol2_succ_acc(x, signalLen, interpFactor, interpLen, invU, invU2);


figure
plot(t, x,'o');
hold on
plot(t2, spline_interp,'-k', t2, lineal_interp,'--b');
plot(t2(1:interpLen), quad_interp_full,'.r', t2(1:interpLen), quad_interp_suacc,'.r');
legend('original','spline','lineal','QuadraticOntheFly', FontSize = 10)
xlim([0 T/100]);
title(['Interpolation factor: ',num2str(interpFactor)],'Interpreter','latex', FontSize = 14)
xl = xlabel('Tiempo $t$, (seg.)','Interpreter','latex'); xl.FontSize = 14;
yl = ylabel('Amplitud','Interpreter','latex'); yl.FontSize = 14;

error_lineal = immse(spline_interp(1:interpLen), lineal_interp(1:interpLen))
error_quad_full = immse(spline_interp(1:interpLen), quad_interp_full)
error_succ_acc = immse(spline_interp(1:interpLen), quad_interp_suacc)


