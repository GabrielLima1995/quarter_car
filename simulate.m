%% Quarter car model
% Simulation and animation of a quarter car model.
%
%%
clear ; close all ; clc
%% Parameters
% Vehicle
M   = 325;                         % Sprung mass                   [kg]
m   = 39;                          % Unsprung mass                 [kg]
Ks  = 16182;                       % Spring constant suspension    [N/m]
Kt  = 232.5e3;                     % Spring constant tire          [N/m]
Cs  = 1200;                        % Damping constant suspension   [N.s/m]
L0_s    = 0.8;                     % Spring relaxed suspension     [m] 1.1
L0_u    = 0.6;                     % Spring relaxed tire           [m] 0.35

%simulation
dt = 0.005;
tmax = 1;
time = 0:dt:tmax;

%% Road

l = 0.8;                                %anomaly = l/2[m] (min 0.2)
h = 0.2;                                %anomaly height [m]
fx =1/l;                                %spatial frequency[1/m]
dx = 0.01;                              %spatial sample rate[m] 
n_anomalies=2000;                        %anomaly number[n] 
road_x = 0:dx:n_anomalies*l;
omega = 2*pi*fx;
road_z = h*sin(omega*road_x);
road_z(road_z < 0) = 0;

%%  State space model
A = [ 0               1         0       0       ;
      -(Ks+Kt)/m      -Cs/m     Ks/m    Cs/m    ;
      0               0         0       1       ;
      Ks/M            Cs/M      -Ks/M   -Cs/M   ];
B = [ 0     ;
      Kt/m  ;
      0     ;
      0     ];
C = [ 1 0 0 0 ; 
      0 0 1 0 ];
D = [0 ; 0];
sys = ss(A,B,C,D);

% Input
vel = 15;                            % Longitudinal speed of the car [m/s]
lon_pos = vel*time;                 % Longitudinal position of the car [m]
u_vet = interp1(road_x,road_z,lon_pos)';
[z,time,x] = lsim(sys,u_vet,time);
% Sprung mass absolute vertical position (lower center point)
z_s = z(:,2) + L0_u + L0_s; 
% Unsprung mass absolute vertical position (lower center point)
z_u = z(:,1) + L0_u; 

%% Animation 
%for i=1:length(time)
%    anime([u_vet(i), z_u(i), z_s(i), time(i)],road_x(i),road_z(i),L0_s,L0_u,vel);
%    refresh
%end

%% Plots
%color = cool(6);
figure(1);
plot(time,z_s,'k-');hold on;
plot(time,z_u,'g-');
plot(time,u_vet,'b-');
grid;
figure(2);
h = bodeplot(sys);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
grid;

