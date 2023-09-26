%% Modelo Quarto de carro
%%
clear ; close all ; clc
%% Parâmetros
% Veículo
M   = 330;                      % Sprung mass                   [kg]
m   = 62;                       % Unsprung mass                 [kg]
k  = 20e3;                       % Spring constant suspension    [N/m]
kt  = 200e3;                    % Spring constant tire          [N/m]
c  = 2e3;                     % Damping constant suspension   [N.s/m]

%% Função de transferencia massa não amortecida
alphaunsp = M*m;
betaunsp = c*(M+m);
gamaunsp = (M*(k+kt))+ (k*m) ;
thetaunsp = c*kt;
episolonunsp = k*kt; 
numunsp = [M,c,k]*kt;
denunsp = [alphaunsp,betaunsp,gamaunsp,thetaunsp,episolonunsp];
TransferFunctionUnsprung = tf(numunsp,denunsp);


%% Parâmetros
lb = 0.5;   %[m]
hb = 0.1;   %[m]
v  = 13.88; %[m/s]
tp = lb/v;
w  = (2*pi)/tp;
ds = 1/3000;

tempo_analise = 10;
t  = 0:ds:(tempo_analise*tp);

%zr = (hb/2)*(1-cos(w*t));
%zr(round(tp/ds)+1:end) = 0;

omeganw = sqrt((k+kt)/m)/(2*pi);
zetha = c/(2*sqrt((k+ kt)*m));


%ar = (((hb*(w^2))/2)/((omeganw^2)*hb))*cos(w*t); 

ar = ((hb*(w^2))/2)*cos(w*t);
ar(round(tp/ds)+1:end) = 0;

[resp,tresp] = lsim(TransferFunctionUnsprung,ar,t);

Plot_Bode(TransferFunctionUnsprung,omeganw)
Plot_FFT(resp,t,ds,v)
Plot_transitorio(resp,t,v)