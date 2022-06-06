function anime(x,road_x,road_z,L0_s,L0_u,vel) 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h_s     = 0.4;                      % Height of the sprung block    [m]
h_u     = 0.2;                      % Height of the unsprung block  [m]
a       = 0.8;                      % Width of the blocks           [m]
l_win   = 2.2;                      % Length window analysis        [m]

%x(4) is the time(i)
x_inst = vel*x(4);
figure(1);clf
set(gca,'xlim',[x_inst-l_win/2    x_inst+l_win/2],'ylim',[-0.1 -0.1+l_win])
plot([0 road_x],[0 road_z],'k')

% Sprung mass plot
fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],[x(3) x(3) x(3)+h_s x(3)+h_s],[65 105 225]/255)

fill([x_inst-a/2 x_inst+a/2 x_inst+a/2 x_inst-a/2],[x(2) x(2) x(2)+h_u x(2)+h_u],[65 105 225]/255)
end

