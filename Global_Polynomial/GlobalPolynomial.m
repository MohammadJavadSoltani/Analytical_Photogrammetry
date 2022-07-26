clear all;close all;clc
%%
U1 = 103 ;
V1 = -100.1 ;
U2 = 0.8 ;
V2 = -69 ;
U3 = -20 ;
V3 = -69 ;
U4 = -60 ;
V4 = -47 ;
U5 = -102 ;
V5 = -47.2 ;
U6 = -101.7 ;
V6 = 10.8 ;
U7 = -86 ;
V7 = 75.8 ;
U8 = -40 ;
V8 = 45.7 ;
U9 = 11 ;
V9 = 36.8 ;
U10 = 63 ;
V10= 34 ;
U11 = 63 ;
V11 = 17.7 ;
U12 = 63 ;
V12 = 64.3 ;
U13 = 106 ;
V13 = 47.7 ;

X1 = 500083.4 ;
Y1 = 5003683.5;
X2 = 504092.3 ;
Y2 = 5002499.5;
X3 = 504907.5;
Y3 = 5002499.5;
X4 = 506493.3;
Y4 = 5001673.5;
X5 = 508101.3;
Y5 = 5001651 ;
X6 = 508090.1;
Y6 = 4999384;
X7 = 507475.9;
Y7 = 4996849;
X8 = 505689.2;
Y8 = 4998022;
X9 = 503679.2;
Y9 = 4998368;
X10 = 501657.9;
Y10= 4998479.5;
X11 = 501669.1;
Y11 = 4999116;
X12 = 501680.3;
Y12 = 4997269 ;
X13 = 500005.3;
Y13 = 4997943.5;

U=[U1;U2;U3;U4;Y5;U6;U7;U8;U9;U10;U11;12;U13];
V=[V1;V2;V3;V4;V5;V6;V7;V8;V9;V10;V11;V12;V13];
X=[X1;X2;X3;X4;X5;X6;X7;X8;X9;X10;X11;X12;X13];
Y=[Y1;Y2;Y3;Y4;Y5;Y6;Y7;Y8;Y9;Y10;Y11;Y12;Y13];

UG=[U1;U3;U4;Y5;U7;U8;U9;U11;12;U13];
VG=[V1;V3;V4;V5;V7;V8;V9;V11;V12;V13];
XG=[X1;X3;X4;X5;X7;X8;X9;X11;X12;X13];
YG=[Y1;Y3;Y4;Y5;Y7;Y8;Y9;Y11;Y12;Y13];

UI=[U2;U6;U10];
VI=[V2;V6;V10];
XI=[X2;X6;X10];
YI=[Y2;Y6;Y10];

%By using from AUTOCAD we picked point 2 & 6 &10 as ICPs 
%%
%plot the points
hold on
for i=1:13
    x=X(i);
    y=Y(i);
    plot(x,y,'rs','LineWidth',5,'MarkerSize',2);
    if (i==2 || i==6 || i==10)
        text(mean(x),mean(y)-1,'ICP');
    end
end
figure();
hold on
for i=1:13
    u=U(i);
    v=V(i);
    plot(u,v,'bs','LineWidth',5,'MarkerSize',2);
    
end
%%
%
numberofpoint = length(UG);
numberofunknown1 = 6;
numberofunknown2 = 12;
numberofunknown3 = 20;
L = zeros( numberofpoint * 2, 1 );
L(1:2:end,1) =XG;
L(2:2:end,1) =YG;

A = zeros(numberofpoint *2, numberofunknown1);
for i=1:numberofpoint
    A(2*i-1,2) =UG(i);
    A(2*i,5) =UG(i);
    A(2*i-1,3) =VG(i);
    A(2*i,6) =VG(i);
    
end

xcap = inv(A' * A) * A' * L ;














%%
%TEKRARI
zg=[0,0,0,0];
z = fsolve(@affine4point,zg)
lambdaX=z(1);
lambdaY=z(2);
alpha=z(3);
teta=z(4);
Tx=xcap(5);
Ty=xcap(6);
format long g
disp(['the lambdaX is :',num2str(lambdaX)]);
disp(['the lambdaY is :',num2str(lambdaY)]);
disp(['the teta is :',num2str(teta)]);
disp(['the alpha is :',num2str(alpha)]);
disp(['the Tx is :',num2str(Tx)]);
disp(['the Ty is :',num2str(Ty)]);
disp('_____________________________________________________________________')
disp(['X = ',num2str(xcap(1)),' U + ',num2str(xcap(2)),' V + ',num2str(xcap(5))]);
disp(['Y = -',num2str(xcap(3)),' U + ',num2str(xcap(4)),' V + ',num2str(xcap(6))]);
disp('********************************************************************************************')
%-----------------------------------------------------------------------------------------------------------------------
%%
%Area1
areaP1 = (UA*VB+UB*VC+UC*VD+UD*VA)-(UB*VA+UC*VB+UD*VC+UA*VD);
areaP1 =abs(areaP1)/2;
areaG1 = (XA*YB+XB*YC+XC*YD+XD*YA)-(XB*YA+XC*YB+XD*YC+XA*YD);
areaG1 =abs(areaG1)/2;

figure();
plot(U,V);
text(mean(U),mean(V),'pic.CS');
figure();
plot(X,Y);
text(mean(X),mean(Y),'ground.CS');

%%
%length1
ABG = sqrt((XB-XA)^2+(YB-YA)^2)
BCG = sqrt((XC-XB)^2+(YC-YB)^2)
CDG = sqrt((XD-XC)^2+(YD-YC)^2)
DAG = sqrt((XA-XD)^2+(YA-YD)^2)
ABP= sqrt((UB-UA)^2+(VB-VA)^2)
BCP = sqrt((UC-UB)^2+(VC-VB)^2)
CDP = sqrt((UD-UC)^2+(VD-VC)^2)
DAP = sqrt((UA-UD)^2+(VA-VD)^2)
%comparing
X1A =xcap(1) * UA + xcap(2)*VA +xcap(5); 
Y1A =xcap(3) * UA + xcap(4)*VA +xcap(6);
X1B = xcap(1) * UB + xcap(2)*VB +xcap(5);
Y1B =xcap(3) * UB + xcap(4)*VB +xcap(6);
ABG2 = sqrt((X1B-X1A)^2+(Y1B-Y1A)^2);
%%
%ANGLE1
MGAB = ((YB-YA) /(XB-XA));
MGBC = ((YC-YB) /(XC-XB));
MGCD = ((YD-YC) /(XD-XC));
MGDA = ((YA-YD) /(XA-XD));
AG1 =180 - atand(abs((MGAB-MGDA)/(1+MGAB*MGDA)));
BG1 = atand(abs((MGBC-MGAB)/(1+MGBC*MGAB)));
CG1 = atand(abs((MGCD-MGBC)/(1+MGCD*MGBC)));
DG1 = atand(abs((MGDA-MGCD)/(1+MGDA*MGCD)));
MPAB = ((VB-VA) /(UB-UA));
MPBC = ((VC-VB) /(UC-UB));
MPCD = ((VD-VC) /(UD-UC));
MPDA = ((VA-VD) /(UA-UD));
AP1 = 180 - atand(abs((MPAB-MPDA)/(1+MPAB*MPDA)));
BP1 = atand(abs((MPBC-MPAB)/(1+MPBC*MPAB)));
CP1 = atand(abs((MPCD-MPBC)/(1+MPCD*MPBC)));
DP1 = atand(abs((MPDA-MPCD)/(1+MPCD*MPDA)));
