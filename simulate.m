%% Quarter car model
% Simulation and animation of a quarter car model.
%
%%
clear ; close all ; clc
%% Parameters
% Vehicle
M   = 325;                        % Sprung mass                   [kg]
m   = 39;                         % Unsprung mass                 [kg]
Ks  = 16182;                      % Spring constant suspension    [N/m]
Kt  = 232.5e3;                    % Spring constant tire          [N/m]
Cs  = 2000;                       % Damping constant suspension   [N.s/m]
L0_s    = 1.0;                    % Spring relaxed suspension     [m] 1.1
L0_u    = 0.35;                   % Spring relaxed tire           [m] 0.35
h_s     = 0.4;                    % Height of the sprung block    [m]
h_u     = 0.2;                    % Height of the unsprung block  [m]
a       = 0.6;                    % Width of the blocks           [m]
l_win   = 0.8;                    % Length window analysis        [m]
dim =[0.13, 0.9, 0.1, 0.1];       %position of text

%simulation
dt = 0.005;
tmax = 1;
time = 0:dt:tmax;
vel = 10;                          % Longitudinal speed of the car [m/s]

%% Road

l = 0.8;                          %anomaly = l/2[m] (min 0.2)
h = 0.15;                          %anomaly height [m]
fx =1/l;                          %spatial frequency[1/m]
dx = 0.005;                        %spatial sample rate[m] 
n_anomalies=2000;                 %anomaly number[n] 
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
lon_pos = vel*time;                 % Longitudinal position of the car [m]
u_vet = interp1(road_x,road_z,lon_pos)';
[z,time,x] = lsim(sys,u_vet,time);

% Sprung mass absolute vertical position (lower center point)
z_s = z(:,2) + L0_u + L0_s; 
% Unsprung mass absolute vertical position (lower center point)
z_u = z(:,1) + L0_u; 

set(gcf,'Position',[50 50 854 480])
v = VideoWriter('simulation.mp4','MPEG-4');
v.Quality   = 100;
open(v);

%% Animation 
for i=1:length(time)
    
    figure(1);clf
    tiledlayout(3,2)
    nexttile([3,1])
    x_inst = vel*time(i);
    plot(vel*time,u_vet,'k-'); hold on;
    str=sprintf('Simulation Time %.2f',time(i)); 
    annotation('textbox',dim,'String',str,'FitBoxToText','on');

    xlabel('Distance [m]')
    ylabel('Vertical reaction [m]')
    ylim([0 2])
    set(gca,'xlim',[x_inst-l_win/2    x_inst+l_win/2])
    
    % Tire
    plot(x_inst,u_vet(i),'ko','MarkerFacecolor','k','MarkerSize',10)
    % Spring
    plotSpring(L0_u,L0_s,h_u,u_vet,z_s,z_u,i,x_inst)
    % Unsprung mass plot
    fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],...
    [z_u(i) z_u(i) z_u(i)+h_u z_u(i)+h_u],[234 117 0]/255,'LineWidth',2)
    % Damper
    plotDamper(L0_s,h_u,z_s,z_u,i,x_inst)
    % Sprung mass plot
    fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],...
    [z_s(i) z_s(i) z_s(i)+h_s z_s(i)+h_s],[234 117 0]/255,'LineWidth',2)

    nexttile;
    plot(time,u_vet,'k-');hold on;
    % where is the car
    plot(time(i),u_vet(i),'ko','MarkerFacecolor','k','MarkerSize',5)
    set(gca,'xlim',[time(i)-l_win/2    time(i)+l_win/2])
    xlabel('Time[s]')
    ylabel('Vertical Input [m]')
    
    nexttile;
    plot(time,z_s,'k-');hold on;
    % where is the car
    plot(time(i),z_s(i),'ko','MarkerFacecolor','k','MarkerSize',5)
    set(gca,'xlim',[time(i)-l_win/2    time(i)+l_win/2])
    xlabel('Time[s]')
    ylabel('Sprung reaction [m]')
    
    nexttile;
    plot(time,z_u,'k-');hold on;
    
    % where is the car
    plot(time(i),z_u(i),'ko','MarkerFacecolor','k','MarkerSize',5)
    set(gca,'xlim',[time(i)-l_win/2    time(i)+l_win/2])
    xlabel('Time[s]')
    ylabel('Unsprung reaction [m]')
    
    refresh
    frame = getframe(gcf);
    if time(i) == 0.62
    	imwrite(frame.cdata,'dcl.jpg');
    end
       
    
    writeVideo(v,frame);
    
end
close(v);


function plotSpring(L0_u,L0_s,h_u,u_vet,z_s,z_u,i,x_inst)
    rodPct      = 0.11;     % Length rod percentage of total L0 
    springPct   = 1/3;      % Spring pitch percentage of total gap
    spring_wid  = 3;        % Spring line width
    
    % Spring 1 and 2 length without rods
    L_s = (z_s - (z_u+h_u)) - 2*rodPct*L0_s;
    L_u = (z_u - u_vet)     - 2*rodPct*L0_u;
    
    % Spring sprung suspension geometry
    c_s = x_inst-0.2;       % Longitudinal position
    w_s = 0.1;              % Width
    
    % Spring unsprung tire geometry 
    c_u = x_inst;           % Longitudinal position
    w_u = 0.1;              % Width
    % Spring unsprung tire 
    spring_u_X = [ 
                c_u                                             % Start
                c_u                                             % rod
                c_u+w_u                                         % Part 1   
                c_u-w_u                                         % Part 2
                c_u+w_u                                         % Part 3
                c_u-w_u                                         % Part 4
                c_u+w_u                                         % Part 5
                c_u-w_u                                         % Part 6
                c_u                                             % Part 7
                c_u                                             % rod/End
                ];
    
	spring_u_Z = [ 
                u_vet(i)                                        % Start
                u_vet(i)+  rodPct*L0_u                          % rod
                u_vet(i)+  rodPct*L0_u                          % Part 1 
                u_vet(i)+  rodPct*L0_u+  springPct*L_u(i)       % Part 2
                u_vet(i)+  rodPct*L0_u+  springPct*L_u(i)       % Part 3
                u_vet(i)+  rodPct*L0_u+2*springPct*L_u(i)       % Part 4
                u_vet(i)+  rodPct*L0_u+2*springPct*L_u(i)       % Part 5
                u_vet(i)+  rodPct*L0_u+3*springPct*L_u(i)       % Part 6
                u_vet(i)+  rodPct*L0_u+3*springPct*L_u(i)       % Part 7
                u_vet(i)+2*rodPct*L0_u+3*springPct*L_u(i)       % rod/End
               ]; 
           
    % Spring sprung suspension
    spring_s_X = [ 
                c_s                                             % Start
                c_s                                             % rod
                c_s+w_s                                         % Part 1   
                c_s-w_s                                         % Part 2
                c_s+w_s                                         % Part 3
                c_s-w_s                                         % Part 4
                c_s+w_s                                         % Part 5
                c_s-w_s                                         % Part 6
                c_s                                             % Part 7
                c_s                                             % rod/End
                ];
    
	spring_s_Z = [ 
                z_u(i)+h_u                                      % Start
                z_u(i)+h_u +   rodPct*L0_s                      % rod
                z_u(i)+h_u +   rodPct*L0_s                      % Part 1 
                z_u(i)+h_u +   rodPct*L0_s +   springPct*L_s(i) % Part 2
                z_u(i)+h_u +   rodPct*L0_s +   springPct*L_s(i) % Part 3
                z_u(i)+h_u +   rodPct*L0_s + 2*springPct*L_s(i) % Part 4
                z_u(i)+h_u +   rodPct*L0_s + 2*springPct*L_s(i) % Part 5
                z_u(i)+h_u +   rodPct*L0_s + 3*springPct*L_s(i) % Part 6
                z_u(i)+h_u +   rodPct*L0_s + 3*springPct*L_s(i) % Part 7
                z_u(i)+h_u + 2*rodPct*L0_s + 3*springPct*L_s(i) % rod/End
               ];
    % PLOT
    plot(spring_u_X,spring_u_Z,'k','LineWidth',spring_wid)
    plot(spring_s_X,spring_s_Z,'k','LineWidth',spring_wid)
        
end

function plotDamper(L0_2,h1,z_s,z_u,i,x_inst)
 
    rodLowerPct = 0.15;      % Length lower rod percentage of total gap 
    rodUpperPct = 0.4;      % Length upper rod percentage of total gap
    cylinderPct = 0.4;      % Length cylinder porcentage of total gap
    damper_line_wid  = 3;   % Damper line width
    
    % Damper geometry
    c = 0.2+x_inst;         % Longitudinal position
    w= 0.1;                % Width
    % rod attached to unsprung mass
    rod_1_X = [c c];
    rod_1_Z = [z_u+h1 z_u+h1+rodLowerPct*L0_2];
    
    % Damper base cylinder - rod - base 
    c_X =   [   
                c-w
                c-w
                c+w
                c+w
            ];
    c_Z =   [
                z_u(i) + h1 + rodLowerPct*L0_2 + cylinderPct*L0_2
                z_u(i) + h1 + rodLowerPct*L0_2 
                z_u(i) + h1 + rodLowerPct*L0_2 
                z_u(i) + h1 + rodLowerPct*L0_2 + cylinderPct*L0_2
            ];
    
    % rod attached to sprung mass
    rod2X = [c c];
    rod2Z = [z_s z_s-rodUpperPct*L0_2];
    % Piston inside cylinder
    pistonX = [c-0.8*w c+0.8*w];
    pistonZ = [z_s-rodUpperPct*L0_2 z_s-rodUpperPct*L0_2];
    
    % Iteration values
    rod1Zval = rod_1_Z(i,:);
    rod2Zval = rod2Z(i,:);
    pistonZVal = pistonZ(i,:);
    
    % PLOT
    % rods
    plot(rod_1_X,rod1Zval,'k','LineWidth',damper_line_wid)
    plot(rod2X,rod2Zval,'k','LineWidth',damper_line_wid)
    % Damper parts
    plot(pistonX,pistonZVal,'k','LineWidth',damper_line_wid)
    plot(c_X,c_Z,'k','LineWidth',damper_line_wid)
end

