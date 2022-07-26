%MohammadJavadSoltani 9822663 09187071499
%%clear all;close all;clc
%% Data
data=xlsread('points.xlsx');% data structure --> PointID x y X Y
U=data(:,1);
V=data(:,2);
X=data(:,3);
Y=data(:,4);

UG=[U(1);U(2);U(4);U(5);U(6);U(7);U(9);U(11);U(12);U(13)];
VG=[V(1);V(2);V(4);V(5);V(6);V(7);V(9);(11);V(12);V(13)];
XG=[X(1);X(2);X(4);X(5);X(6);X(7);X(9);X(11);X(12);X(13)];
YG=[Y(1);Y(2);Y(4);Y(5);Y(6);Y(7);Y(9);Y(11);Y(12);Y(13)];

UI=[U(3);U(8);U(10)];
VI=[V(3);V(8);V(10)];
XI=[X(3);X(8);X(10)];
YI=[Y(3);Y(8);Y(10)];
%%
%plot the points
hold on
for i=1:13
    x=X(i);
    y=Y(i);
    plot(x,y,'rs','LineWidth',5,'MarkerSize',2);
    if (i==3 || i==8 || i==10)
        text(mean(x),mean(y)-1,'ICP');
    end
end
figure();
hold on
for j=1:13
    u=U(j);
    v=V(j);
    plot(u,v,'bs','LineWidth',5,'MarkerSize',2);
    if (j==3 || j==8 || j==10)
        text(mean(u),mean(v)-1,'ICP');
    end
end

%%
%GP---> linear term
numberofpoint = length(UG);
numberofunknown1 = 6;
numberofcheck = 3;
L1 = zeros( numberofpoint * 2, 1 );
L1(1:2:end,1) =XG;
L1(2:2:end,1) =YG;

A = zeros(numberofpoint *2, numberofunknown1);
for i=1:numberofpoint
    A(2*i-1,2) =UG(i);
    A(2*i,5) =UG(i);
    A(2*i-1,1) =1;
    A(2*i-1,3) =VG(i);
    A(2*i,6) =VG(i);
    A(2*i,4) =1;
end

xcap1 = inv(A' * A) * A' * L1 ;
disp(['X = ',num2str(xcap1(2)),' x + ',num2str(xcap1(3)),' y + ',num2str(xcap1(1))]);
disp(['Y = ',num2str(xcap1(5)),' x + ',num2str(xcap1(6)),' y + ',num2str(xcap1(4))]);
%%
%RMSE for GP_linear:
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
%dX,dY for GCPs in GP:
dX=zeros(length(XG),1);
dY=zeros(length(YG),1);
dX_icp=zeros(length(XI),1);
dY_icp=zeros(length(YI),1);
for i=1:10
    dX(i)=XG(i)-(xcap1(2)*UG(i)+xcap1(3)*VG(i)+xcap1(1));
    dY(i)=YG(i)-(xcap1(5)*UG(i)+xcap1(6)*VG(i)+xcap1(4));
end
for i=1:3
    dX_icp(i)=XI(i)-(xcap1(2)*UI(i)+xcap1(3)*VI(i)+xcap1(1));
    dY_icp(i)=YI(i)-(xcap1(5)*UI(i)+xcap1(6)*VI(i)+xcap1(4));
end
%%
%choose the effective points (part A):
%distance of checks:
F=zeros(length(UG),3);%distance of cheak1
for i=1:10
    F(i,1)=sqrt( (XI(1)-XG(i))^2+(YI(1)-YG(i))^2 );
    F(i,2)=sqrt( (XI(2)-XG(i))^2+(YI(2)-YG(i))^2 );
    F(i,3)=sqrt( (XI(3)-XG(i))^2+(YI(3)-YG(i))^2 );
end
[B,I] = sort(F);

RMSE_AA = zeros(length(UG),1);
dists = zeros(length(UG),3);
W = zeros(length(UG),3);
sum1=0;sum2=0;sum3=0;sum4=0;sum5=0;sum6=0;sum7=0;sum8=0;sum9=0;
dX_u=zeros(length(UI),1);dY_u=zeros(length(UI),1);
X_F=zeros(length(UI),1);Y_F=zeros(length(UI),1);
Xrem11=zeros(length(UI),1);Yrem11=zeros(length(UI),1);
dr11 = zeros(numberofcheak,1);
for i=1:10
    %weighted distance:
    for j=1:i
        dists(j,1)=B(j,1);
        dists(j,2)=B(j,2);
        dists(j,3)=B(j,3);
        W(j,1)=1/F(j,1)^2;
        W(j,2)=1/F(j,2)^2;
        W(j,3)=1/F(j,3)^2;
        sum1=sum1+W(j,1)*dX(j);
        sum2=sum2+W(j,1)*dY(j);
        sum3=sum3+W(j,1);
        sum4=sum4+W(j,2)*dX(j);
        sum5=sum5+W(j,2)*dY(j);
        sum6=sum6+W(j,2);
        sum7=sum7+W(j,3)*dX(j);
        sum8=sum8+W(j,3)*dY(j);
        sum9=sum9+W(j,3);
    end
    sum=zeros(3,3);
    sum(1,1)=sum1;sum(1,2)=sum2;sum(1,3)=sum3;
    sum(2,1)=sum4;sum(2,2)=sum5;sum(2,3)=sum6;
    sum(3,1)=sum7;sum(3,2)=sum8;sum(3,3)=sum9;
    for o=1:3
        dX_u(o,1)=sum(o,1)/sum(o,3);
        dY_u(o,1)=sum(o,2)/sum(o,3);
        X_F(o,1)=dX_u(o,1)+Xcom1(o,1);
        Y_F(o,1)=dY_u(o,1)+Ycom1(o,1);
        Xrem11(o,1) = XI(o) - X_F(o,1);
        Yrem11(o,1) = YI(o) - Y_F(o,1);
        dr11(o,1) = sqrt( (Xrem11(o,1))^2 + (Yrem11(o,1))^2 );
        RMSE_AA(i,1) = RMSE_AA(i,1) + sqrt( (dr11(o,1)^2) / (numberofcheak-1) );
    end
    disp(['RMSE_wieghted_',num2str(i),'  is :  ',num2str(RMSE_AA(i,1))]);
end
disp('_______________________________________________________________________________________________________')
%moving average
A1 = zeros(numberofpoint,3);
RMSE_A2=0;
for i =1:10
    A1(i,1)=1;
    A1(i,2)=UG(i);
    A1(i,3)=VG(i);
end
xcap11 = inv(A1'*A1)*A1'*dX;%Ai
xcap12 = inv(A1'*A1)*A1'*dY;%Bi
  
for i=1:3
    dX_MA(i,1)=(xcap11(2)*Xcom1(i)+xcap11(3)*Ycom1(i)+xcap11(1));
    dY_MA(i,1)=(xcap12(2)*Xcom1(i)+xcap12(3)*Ycom1(i)+xcap12(1));
    
    XFM(i,1)=(xcap1(2)*UI(i)+xcap1(3)*VI(i)+xcap1(1))+dX_MA(i);%XFM=X FINAL MOVING
    YFM(i,1)=(xcap1(5)*UI(i)+xcap1(6)*VI(i)+xcap1(4))+dY_MA(i);%YFM=Y FINAL MOVING
    
    Xrem12(i,1) = XI(i) - XFM(i,1);
    Yrem12(i,1) = YI(i) - YFM(i,1);
    dr12(i,1) = sqrt( (Xrem12(i,1))^2 + (Yrem12(i,1))^2 );
    RMSE_A2 = RMSE_A2 + sqrt( (dr12(i,1)^2) / (numberofcheak-1) );
end
disp(['RMSE_MOVING  is :  ',num2str(RMSE_A2)]);
disp('_______________________________________________________________________________________________________')
%%
%now for secound method that we should make 4 parts:
dists_secound = zeros(4,3);
% for j=1:3
%     for i=1:10
%         if ((XG(i)-XI(j)>0) & (YG(i)-YI(j)>0))
%             dists_secound(1,j) = B(i);
%         end
%         if ((XG(i)-XI(j)<0) & (YG(i)-YI(j)>0))
%             dists_secound(2,j) = B(i);
%         end
%         if ((XG(i)-XI(j)<0) & (YG(i)-YI(j)<0))
%             dists_secound(3,j) = B(i);
%         end
%         if ((XG(i)-XI(j)>0) & (YG(i)-YI(j)<0))
%             dists_secound(4,j) = B(i);
%         end
%     end
% end
%also as we picked points from autocad:
dists_secound(1,1)=F(2,1);
dists_secound(1,2)=F(3,1);
dists_secound(1,3)=F(7,1);
dists_secound(1,4)=0;
dists_secound(2,1)=F(6,2);
dists_secound(2,2)=F(7,2);
dists_secound(2,3)=F(5,2);
dists_secound(2,4)=F(9,2);
dists_secound(3,1)=F(7,3);
dists_secound(3,2)=F(8,3);
dists_secound(3,3)=F(10,3);
dists_secound(3,4)=F(9,3);
%weighted distance:
WW=zeros(4,3);%4 part and 3 check point
WW(1,1)=1/F(3,1)^2;
WW(2,1)=1/F(2,1)^2;
WW(3,1)=1/F(7,1)^2;

WW(1,2)=1/F(6,2)^2;
WW(2,2)=1/F(7,2)^2;
WW(3,2)=1/F(5,2)^2;
WW(4,2)=1/F(9,2)^2;

WW(1,3)=1/F(7,3)^2;
WW(2,3)=1/F(8,3)^2;
WW(3,3)=1/F(9,3)^2;
WW(4,3)=1/F(10,3)^2;
sum12=0;sum22=0;sum32=0;sum42=0;sum52=0;
sum62=0;sum72=0;sum82=0;sum92=0;RMSE_AA2=0;
for j=1:4
    sum12=sum12+W(j,1)*dX(j);
    sum22=sum22+W(j,1)*dY(j);
    sum32=sum32+W(j,1);
    
    sum42=sum42+W(j,2)*dX(j);
    sum52=sum52+W(j,2)*dY(j);
    sum62=sum62+W(j,2);
    
    sum72=sum72+W(j,3)*dX(j);
    sum82=sum82+W(j,3)*dY(j);
    sum92=sum92+W(j,3);
end
sum_2=zeros(3,3);
sum_2(1,1)=sum12;sum_2(1,2)=sum22;sum_2(1,3)=sum32;
sum_2(2,1)=sum42;sum_2(2,2)=sum52;sum_2(2,3)=sum62;
sum_2(3,1)=sum72;sum_2(3,2)=sum82;sum_2(3,3)=sum92;
for o=1:3
    dX_u2(o,1)=sum_2(o,1)/sum_2(o,3);
    dY_u2(o,1)=sum_2(o,2)/sum_2(o,3);
    X_F2(o,1)=dX_u2(o,1)+Xcom1(o,1);
    Y_F2(o,1)=dY_u2(o,1)+Ycom1(o,1);
    Xrem112(o,1) = XI(o) - X_F2(o,1);
    Yrem112(o,1) = YI(o) - Y_F2(o,1);
    dr112(o,1) = sqrt( (Xrem112(o,1))^2 + (Yrem112(o,1))^2 );
    RMSE_AA2 = RMSE_AA2 + sqrt( (dr112(o,1)^2) / (numberofcheak-1) );
end
disp(['RMSE_wieghted_2 is :  ',num2str(RMSE_AA2)]);
disp('_______________________________________________________________________________________________________')
%moving average
%for first cheack:4&2&9
A12 = zeros(4,3);
RMSE_A22=0;

A12(1,1)=1;A12(1,2)=UG(3);A12(1,3)=VG(3);
A12(2,1)=1;A12(2,2)=UG(2);A12(2,3)=VG(2);
A12(3,1)=1;A12(3,2)=UG(7);A12(3,3)=VG(7);
A12(4,1)=0;A12(4,2)=0;A12(4,3)=0;

dX_1=zeros(4,1);
dY_1=zeros(4,1);

dX_1(1,1)=dX(3);
dX_1(2,1)=dX(2);
dX_1(3,1)=dX(7);
dX_1(4,1)=0;
dY_1(1,1)=dY(3);
dY_1(2,1)=dY(2);
dY_1(3,1)=dY(7);
dY_1(4,1)=0;

xcap11_1 = inv(A12'*A12)*A12'*dX_1;%Ai
xcap12_1 = inv(A12'*A12)*A12'*dY_1;%Bi
  
dX_MA2=(xcap11_1(2)*Xcom1(1)+xcap11_1(3)*Ycom1(1)+xcap11_1(1));
dY_MA2=(xcap12_1(2)*Xcom1(1)+xcap12_1(3)*Ycom1(1)+xcap12_1(1));

XFM2=Xcom1(1)+dX_MA2;%XFM=X FINAL MOVING
YFM2=Ycom1(1)+dY_MA2;%YFM=Y FINAL MOVING

Xrem122 = XI(1) - XFM2;
Yrem122 = YI(1) - YFM2;
dr122_1 = sqrt( (Xrem122)^2 + (Yrem122)^2 );

%C_P_2 (7 9 6 12)
A12 = zeros(4,3);
RMSE_A22=0;

A12(1,1)=1;
A12(1,2)=UG(6);
A12(1,3)=VG(6);
A12(2,1)=1;
A12(2,2)=UG(7);
A12(2,3)=VG(7);
A12(3,1)=1;
A12(3,2)=UG(5);
A12(3,3)=VG(5);
A12(4,1)=1;
A12(4,2)=UG(9);
A12(4,3)=VG(9);

dX_1=zeros(4,1);
dY_1=zeros(4,1);
dX_1(1,1)=dX(6);
dX_1(2,1)=dX(7);
dX_1(3,1)=dX(5);
dX_1(4,1)=dX(9);
dY_1(1,1)=dY(6);
dY_1(2,1)=dY(7);
dY_1(3,1)=dY(5);
dY_1(4,1)=dY(9);

xcap11_2 = inv(A12'*A12)*A12'*dX_1;%Ai
xcap12_2 = inv(A12'*A12)*A12'*dY_1;%Bi
  

dX_MA2=(xcap11_2(2)*Xcom1(2)+xcap11_2(3)*Ycom1(2)+xcap11_2(1));
dY_MA2=(xcap12_2(2)*Xcom1(2)+xcap12_2(3)*Ycom1(2)+xcap12_2(1));

XFM2=Xcom1(2)+dX_MA2;%XFM=X FINAL MOVING
YFM2=Ycom1(2)+dY_MA2;%YFM=Y FINAL MOVING

Xrem122 = XI(2) - XFM2;
Yrem122 = YI(2) - YFM2;
dr122_2 = sqrt( (Xrem122)^2 + (Yrem122)^2 );

%C_P_3 (9 11 12 13)
A12 = zeros(4,3);
RMSE_A22=0;

A12(1,1)=1;
A12(1,2)=UG(7);
A12(1,3)=VG(7);
A12(2,1)=1;
A12(2,2)=UG(8);
A12(2,3)=VG(8);
A12(3,1)=1;
A12(3,2)=UG(9);
A12(3,3)=VG(9);
A12(4,1)=1;
A12(4,2)=UG(10);
A12(4,3)=VG(10);

dX_1=zeros(4,1);
dY_1=zeros(4,1);
dX_1(1,1)=dX(7);
dX_1(2,1)=dX(8);
dX_1(3,1)=dX(9);
dX_1(4,1)=dX(10);
dY_1(1,1)=dY(7);
dY_1(2,1)=dY(8);
dY_1(3,1)=dY(9);
dY_1(4,1)=dY(10);

xcap11_3 = inv(A12'*A12)*A12'*dX_1;%Ai
xcap12_3 = inv(A12'*A12)*A12'*dY_1;%Bi
 
dX_MA2=(xcap11_3(2)*Xcom1(3)+xcap11_3(3)*Ycom1(3)+xcap11_3(1));
dY_MA2=(xcap12_3(2)*Xcom1(3)+xcap12_3(3)*Ycom1(3)+xcap12_3(1));

XFM2=Xcom1(3)+dX_MA2;%XFM=X FINAL MOVING
YFM2=Xcom1(3)+dY_MA2;%YFM=Y FINAL MOVING

Xrem122 = XI(3) - XFM2;
Yrem122 = YI(3) - YFM2;
dr122_3 = sqrt( (Xrem122)^2 + (Yrem122)^2 );

%*************************************************************************************************
RMSE_A2 =sqrt( (dr122_1^2)+(dr122_2^2)+(dr122_3^2) / (2) );
disp(['RMSE_MOVING_2  is :  ',num2str(RMSE_A2)]);
disp('_______________________________________________________________________________________________________')
%%