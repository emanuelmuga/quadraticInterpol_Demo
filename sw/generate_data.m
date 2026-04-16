Fs = 2e3;            % Frecuencia de muestreo
T = 1;               % Tiempo de observacion

% Ejes
t  = 0:1/Fs:T-1/Fs;  
N = length(t);
Fs2 = Fs*interpFactor;
t2 = 0:(1/Fs2):T-1/Fs2;
N2 = length(t2);

%% Generar proceso estocástico con distribución normal
Fc = 100;  % Frecuencia de corte (Hz)
orden = 6; % Orden del filtro
[b, a] = butter(orden, Fc/(Fs/2), 'low'); % Filtro Butterworth
xn = filter(b, a, randn(size(t)));

save("data_noise.mat","xn","t","t2","N","T")