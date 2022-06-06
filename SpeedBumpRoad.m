clear;
l = 0.80;
h = 0.2;
f =1/l;
road_x = 0:0.01:99.99;
omega = 2*pi*f;
%figure(1);
road_z = h*sin(omega*road_x);
%plot(road_x,road_z,'r-');
road_z(road_z < 0) = 0;
save('SpeedBump.mat')