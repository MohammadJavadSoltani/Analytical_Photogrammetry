clear all;close all;clc;format long g
%%
%first we should pick our ckeack points and GCPs
%so we make a plot from points:
data = xlsread('POINTS_Image.csv');% data structure --> PointID c r X Y Z
img = imread('image1.tif');
id = data(:,1);c = data(:,2);r = data(:,3);
X = data(:,4);Y = data(:,5);Z = data(:,6);
NOG=27;NOC=15;%NUMBER OF GCPS & CHECKs

c0 = 1894 ; r0 = 514 ; ps = .0001; %pixel size per meter
img = imshow('image1.tif');
hold on
for i=1:(NOG+NOC)
    
    plot( c(i), r(i), 'r.', 'LineWidth', 16, 'MarkerSize', 14);
    text( c(i), r(i), num2str(id(i)), 'FontSize', 12);
end
%now we should pick points :
%%
%after picking points, we should add them to program;
data_C = xlsread('CHEACK_POINTS.csv');% data structure --> PointID c r X Y Z
data_G = xlsread('GCPS_POINTS.csv');% data structure --> PointID c r X Y Z
%check:
idc = data_C(:,1);cc = data_C(:,2);rc = data_C(:,3);
Xc = data_C(:,4);Yc = data_C(:,5);Zc = data_C(:,6);
%GCP
idg = data_G(:,1);cg = data_G(:,2);rg = data_G(:,3);
Xg = data_G(:,4);Yg = data_G(:,5);Zg = data_G(:,6);
for i=1:NOC
    x__c(i,1) = ( cc(i)-c0 ) * ps;
    y__c(i,1) = ( rc(i)-r0 ) * ps;
end
for i=1:NOG
    %convert to photogrammetry cordinate system
    x(i,1) = ( cg(i)-c0 ) * ps;
    y(i,1) = ( rg(i)-r0 ) * ps;
end
%%
% now for GCPs we have:
%A = zeros(2*NOG , 11)*0.;L1 = zeros(2*NOG,1)*0.;
L1 = zeros(2*NOG,1);
for i=1:NOG
    A(2*i-1,1) = Xg(i);
    A(2*i-1,2) = Yg(i);
    A(2*i-1,3) = Zg(i);
    A(2*i-1,4) = 1;
    A(2*i-1,5) = 0.;
    A(2*i-1,6) = 0.;
    A(2*i-1,7) = 0.; 
    A(2*i-1,8) = 0.;
    A(2*i-1,9) =  -Xg(i)*x(i);
    A(2*i-1,10) = -Yg(i)*x(i);
    A(2*i-1,11) = -Zg(i)*x(i);
    L1(2*i-1,1) = x(i);
    A(2*i,1) = 0.;
    A(2*i,2) = 0.;
    A(2*i,3) = 0.; 
    A(2*i,4) = 0.;
    A(2*i,5) = Xg(i);
    A(2*i,6) = Yg(i);
    A(2*i,7) = Zg(i);
    A(2*i,8) = 1;
    A(2*i,9) =  -Xg(i)*y(i);
    A(2*i,10) = -Yg(i)*y(i);
    A(2*i,11) = -Zg(i)*y(i);   
    L1(2*i,1) = y(i);
end
xcap = inv(A' * A) * A' * L1 ;
%%
%now compute the x & y for checks based on DLT:
x_com = zeros(NOC,1);
y_com = zeros(NOC,1);
for i=1:NOC
    x_com(i,1) = ( xcap(1)*Xc(i) + xcap(2) *Yc(i) + xcap(3) *Zc(i)   +xcap(4) ) / ...
            ( xcap(9)*Xc(i) + xcap(10)*Yc(i) + xcap(11)*Zc(i)   +1 );
    y_com(i,1) = ( xcap(5)*Xc(i) + xcap(6) *Yc(i) + xcap(7) *Zc(i)   +xcap(8) ) / ...
            ( xcap(9)*Xc(i) + xcap(10)*Yc(i) + xcap(11)*Zc(i)   +1 ); 
end
xrem = zeros(NOC,1);
yrem = zeros(NOC,1);
for i=1:NOC
    xrem(i,1) = x_com(i)-x__c(i);
    yrem(i,1) = y_com(i)-y__c(i);
end

teta = zeros(NOC,1);
dr = zeros(NOC,1);
for i=1:NOC
    teta(i,1) = atand(yrem(i)/xrem(i));
    dr(i,1) = sqrt( (xrem(i))^2 + (yrem(i))^2 );
end
RMSE = 0;
for i=1:NOC
    RMSE = RMSE + sqrt(   (dr(i)^2) / (NOC-1)   );
end
RMSE
xx=zeros(NOC,1);
yy=zeros(NOC,1);;
figure();

for i=1:NOC
    polarplot(teta(i),dr(i));
end
disp('_______________________________________________________________________________________________________')
%plot RMSE:
quiver(x_com,y_com,x__c,y__c,.5);
hold on;
quiver(x_com,y_com,x__c,y__c,.5);
text(X,Y,int2str(data(:,1)));
legend('CONTROL','CHECK','FontSize',12)
title('Error Vectors (Ground Space)')
figure;
quiver(x_com,y_com,x__c,y__c,.5);
text(X,Y,int2str(data(:,1)));
legend('CHECK WD','FontSize',12)
title('Error Vectors (Ground Space)')


