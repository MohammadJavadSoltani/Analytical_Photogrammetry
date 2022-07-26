clear all;close all;clc
%%
%% Data
data=xlsread('POINTS_Image.csv');%  data structure --> PointID c r X Y Z
datag=xlsread('GCPS_POINTS.csv');%   data structure --> PointID c r X Y Z
datac=xlsread('CHEACK_POINTS.csv');% data structure --> PointID c r X Y Z
U=data(:,1);
V=data(:,2);
X=data(:,3);
Y=data(:,4);

UG=datag(:,2);
VG=datag(:,3);
XG=datag(:,4);
YG=datag(:,5);
ZG=datag(:,6);

UI=datac(:,2);
VI=datac(:,3);
XI=datac(:,4);
YI=datac(:,5);
ZI=datac(:,6);
%%
%q1
numberofpoint = length(UG);
numberofunknown1 = 15;
L1 = zeros( numberofpoint * 2, 1 );
L1(1:2:end,1) = XG;
L1(2:2:end,1) = YG;

A1 = zeros(numberofpoint *2, numberofunknown1);
for i=1:numberofpoint
    A1(2*i-1,2) =UG(i);
    A1(2*i,5) =UG(i);
    A1(2*i-1,1) =1;
    A1(2*i-1,3) =VG(i);
    A1(2*i,6) =VG(i);
    A1(2*i,4) =1;
end
xcap1 = inv(A1' * A1) * A1' * L1 ;

disp(['X = ',num2str(xcap1(2)),' x + ',num2str(xcap1(3)),' y + ',num2str(xcap1(1))]);
disp(['Y = ',num2str(xcap1(5)),' x + ',num2str(xcap1(6)),' y + ',num2str(xcap1(4))]);
%%
%RMSE :
numberofcheak = length(UI);
Xcom1 = zeros(numberofcheak,1);
Ycom1 = zeros(numberofcheak,1);
for i=1:numberofcheak
    Xcom1(i,1) = xcap1(2)*UI(i)+xcap1(3)*VI(i)+xcap1(1);
    Ycom1(i,1) = xcap1(5)*UI(i)+xcap1(6)*VI(i)+xcap1(4);
end
Xrem1 = zeros(numberofcheak,1);
Yrem1 = zeros(numberofcheak,1);
for i=1:numberofcheak
    Xrem1(i,1) = XI(i) - Xcom1(i);
    Yrem1(i,1) = YI(i) - Ycom1(i);
end

teta1 = zeros(numberofcheak,1);
dr1 = zeros(numberofcheak,1);
for i=1:numberofcheak
    teta1(i,1) = atand(Yrem1(i)/Xrem1(i));
    dr1(i,1) = sqrt( (Xrem1(i))^2 + (Yrem1(i))^2 );
end

RMSE1 = 0;
for i=1:numberofcheak
    RMSE1 = RMSE1 + sqrt(   (dr1(i)^2) / (numberofcheak-1)   );
end
RMSE1
disp('_______________________________________________________________________________________________________')
%%
%dx,dy for GCPs:
dX=zeros(length(XG),1);
dY=zeros(length(YG),1);
for i=1:numberofpoint
    dX(i)=XG(i)-(xcap1(2)*UG(i)+xcap1(3)*VG(i)+xcap1(1));
    dY(i)=YG(i)-(xcap1(5)*UG(i)+xcap1(6)*VG(i)+xcap1(4));
end

%%
%F matrix
F = zeros(length(UG),length(UG));
for i=1:numberofpoint
    for j=1:numberofpoint
        F(i,j)=sqrt( (XG(i)-XG(j))^2+(YG(i)-YG(j))^2 );
    end
end
%%
%LINIER:
a=zeros(length(UG),1);
b=zeros(length(UG),1);
a=inv(F'*F)*F'*dX;
b=inv(F'*F)*F'*dY;

%%
%now go for ICPs:
F = zeros(2*numberofcheak,numberofpoint);
k=1;

for i=1:numberofcheak
    for j=1:numberofpoint
        F(i,j) = sqrt( (XI(i)-XG(j))^2+(YI(i)-YG(j))^2 );
    end
end

%%
%dX,dY for ICPs:
c=zeros(numberofpoint*2,1);
for i=1:numberofpoint
    c(i,1)=a(i);
end
for i=numberofpoint+1:numberofpoint*2
    c(i,1)=b(i-numberofpoint);
end
d=zeros(numberofcheak*2,1)
for i=1:numberofcheak
   d(i,1) = F(i)*c; 
end
%%
%ICPs in GP:
XICP_GP=zeros(length(UI),1);
YICP_GP=zeros(length(UI),1);
for i=1:numberofcheak
    XICP_GP(i)=xcap1(2)*UI(i)+xcap1(3)*VI(i)+xcap1(1);
    YICP_GP(i)=xcap1(5)*UI(i)+xcap1(6)*VI(i)+xcap1(4);
end
dX_ICP=zeros(numberofcheak,1);
dY_ICP=zeros(numberofcheak,1);
dX_ICP(1)=d1(1);
dX_ICP(2)=d2(1);
dX_ICP(3)=d3(1);
dY_ICP(1)=d1(2);
dY_ICP(2)=d2(2);
dY_ICP(3)=d3(2);
XMQ_ICP=zeros(length(UI),1);
YMQ_ICP=zeros(length(UI),1);
for i=1:numberofcheak
    XMQ_ICP(i)=XICP_GP(i)+dX_ICP(i);
    YMQ_ICP(i)=YICP_GP(i)+dY_ICP(i);
end
%%
%CALC RMSE:
Xrem2 = zeros(numberofcheak,1);
Yrem2 = zeros(numberofcheak,1);
for i=1:numberofcheak
    Xrem2(i,1) = XI(i) - XMQ_ICP(i);
    Yrem2(i,1) = YI(i) - YMQ_ICP(i);
end

teta2 = zeros(numberofcheak,1);
dr2 = zeros(numberofcheak,1);
for i=1:numberofcheak
    teta2(i,1) = atand(Yrem2(i)/Xrem2(i));
    dr2(i,1) = sqrt( (Xrem2(i))^2 + (Yrem2(i))^2 );
end

RMSE2 = 0;
for i=1:numberofcheak
    RMSE2 = RMSE2 + sqrt(   (dr2(i)^2) / (numberofcheak-1)   );
end
RMSE2
disp('_______________________________________________________________________________________________________')

