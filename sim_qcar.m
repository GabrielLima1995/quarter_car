% Simulate and animate quarter-car suspension model. Model used originally
% for an optimization demonstration in ME 149, Engineering System Design
% Optimization, a graduate course taught at Tufts University in the
% Mechanical Engineering Department. A corresponding video is available at:
% %
% The model is based on the electric vehicle design case study found in the
% dissertation by James T. Allison:
%
% http://deepblue.lib.umich.edu/handle/2027.42/58449
%
% Author: James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 3/4/12


% Clear workspace and set plotting flags
clear;
ploton1 = 1;            % animate qcar response
ploton2 = 2;            % plot response

% Initialize vehicle parameters:
Suspension = 3;               % specify suspension design case
switch Suspension
    case 1           % tuned for comfort
        k = 500.4;
        c = 24.67;
    case 2           % tuned for handling
        k = 505.33;
        c = 850;
    case 3           % not optimal
        k = 16182;
        c = 1000;
end

ms = 325;               % 1/4 sprung mass (kg)
mus = 65;               % 1/4 unsprung mass (kg)
kus = 232.5e3;          % tire stiffness (N/m)
grav = 9.81;            % acceleration of gravity (m/s^2)
v = 12;                 % vehicle velocity (m/s)
dt = 0.005;             % simulation time step  

                        
% Construct linear state space model 
Aqcar = [ 0               1         0       0       ;
      -(k+kus)/mus      -c/mus     k/mus    c/mus    ;
      0               0         0       1       ;
      k/ms            c/ms      -k/ms   -c/ms   ];
Bqcar = [ 0     ;
      kus/mus  ;
      0     ;
      0     ];
Cqcar = [ 1 0 0 0 ; 
      0 0 1 0 ];
Dqcar = [0 ; 0];

qcar = ss(Aqcar,Bqcar,Cqcar,Dqcar);

% Initialize simulation 
x0 = [0 0 0 0]';                        % initial state
load SpeedBump
%load IRI_737b                           % road profile data
%dx = road_x(2) - road_x(1);             % spacial step for input data
%dt2 = dx/v;                             % time step for input data
tmax = 1;
t = 0:dt:tmax;lon_pos = v*t;
u_vet = interp1(road_x,road_z,lon_pos)';
[z,time,x] = lsim(qcar,u_vet,t);
umf = 1;

%{
z0dot = [0 diff(road_z)/dt];            % road profile velocity     
tmax = 3;                               % simulation time length
t = 0:dt:tmax; x = v*t;                 % time/space steps to record output
u = interp1(road_x,z0dot,x);umf = 1;    % prepare simulation input

% Simulate quarter car model
y = lsim(qcar,u*umf,t,x0);     

%deltamaxf = max(abs(y(:,1)));           % max x3 amplitude  
%z2dotdot = [0 diff(y(:,4))'/dt2];       % sprung mass acceleration
%}
% animate response

if ploton1
    z0 = interp1(road_x,road_z,lon_pos)'*umf; % road elevation
    z1 = z0 + z(:,1);                   % wheel cm position
    z2 = z1 + z(:,2); 
    %z2 = z1 + y(:,3);                   % sprung mass position
    zmf = 1;    % exaggerate response for better visualization
    %plot(t,z0,'r-');
    %hold on;
    plot(t,z1,'k-');hold on;
    plot(t,z2,'g-')

    %for i=1:length(t)
    %    plotsusp([z0(i), z1(i)*zmf, z2(i)*zmf, t(i)],road_x,road_z,x(i),umf);
    %    refresh
    %end
end

%{
% plot response
if ploton2
   figure(2);clf   
    plot(t,y(:,3),'r-',t,y(:,5),'k-'); hold on         
    plot(t,u*umf);
    plot(t,z2dotdot,'g-')
    legend('stroke','stroke velocity', ...
        'road input velocity','sprung mass accel')    
end
%}
