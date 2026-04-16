clc; clear; close all;
set(0,'DefaultFigureWindowStyle','docked');

% Parametros
interpFactor = 16;    % factor de interpolacion

generate_data

% señal de prueba
load("data_noise.mat");
% x = real(h_shift);

% otros métodos de interpolación
spline_interp = interp1(t,xn,t2,'spline'); 
lineal_interp = interp1(t,xn,t2,'linear');

% Algoritmo de interpolación cuadratica al vuelo
signalLen = numel(xn);
interpLen = interpFactor*(signalLen-2);
invU = 1/interpFactor;
invU2 = (1/interpFactor)^2;
quad_interp = intpol2_full(xn, signalLen, interpFactor, interpLen, invU, invU2);

figure
plot(t, xn,'o');
hold on
plot(t2, spline_interp,'-k', t2, lineal_interp,'--b');
plot(t2(1:interpLen), quad_interp,'.r');
legend('original','spline','lineal','QuadraticOntheFly', FontSize = 10)
xlim([0 T/100]);
title(['Interpolation factor: ',num2str(interpFactor)],'Interpreter','latex', FontSize = 14)
xl = xlabel('Tiempo $t$, (seg.)','Interpreter','latex'); xl.FontSize = 14;
yl = ylabel('Amplitud','Interpreter','latex'); yl.FontSize = 14;

error_lineal = immse(spline_interp(1:interpLen), lineal_interp(1:interpLen))
error_quad = immse(spline_interp(1:interpLen), quad_interp)

