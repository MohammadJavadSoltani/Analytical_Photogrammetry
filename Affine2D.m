clear all;close all;clc
%%
% inputs
UA = 100 ;
VA = 250 ;
UB = 200 ;
VB = 423.205 ;
UC = 286.602 ;
VC = 373.205 ;
UD = 157.735 ;
VD = 150 ;
XA = 140 ;
YA = 230 ;
XB = 173.398 ;
YB = 410.885 ;
XC = 302.320 ;
YC = 387.535 ;
XD = 259.282 ;
YD = 154.434 ;
U=[UA;UB;UC;UD];
V=[VA;VB;VC;VD];
X=[XA;XB;XC;XD];
Y=[YA;YB;YC;YD];
numberofpoint = length(X);
numberofunknown = 6;
%%
% Q
L = zeros( numberofpoint * 2, 1 );
L(1:2:end,1) =X;
L(2:2:end,1) =Y;

A = zeros(numberofpoint *2, numberofunknown);
for i=1:numberofpoint
    A(2*i-1,1) =U(i);
    A(2*i,3) =U(i);
    A(2*i-1,2) =V(i);
    A(2*i,4) =V(i);
    A(2*i-1,5) =1;
    A(2*i,6) =1;
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
