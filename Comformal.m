clear all;close all;clc

% inputs
UA = 100 ;
VA = 250 ;
UB = 200 ;
VB = 423.205 ;
UC = 286.602 ;
VC = 373.205 ;
UD = 157.735 ;
VD = 150 ;
U1=[UA;UB;UC;UD;UA];
V1=[VA;VB;VC;VD;VA];

% input for Q1 & Q2
XA = 126.962 ;
YA = 99.904 ;
XB = 230.885 ;
YB = 159.904 ;
XC = 260.884 ;
YC = 107.942 ;
XD = 126.962 ;
YD = 30.622 ;
X1=[XA;XB;XC;XD;XA];
Y1=[YA;YB;YC;YD;YA];

% Q1
L = [XA;YA;XB;YB;XC;YC;XD;YD];
A1 = [UA VA 1 0 ; VA -UA 0 1;UB VB 1 0 ; VB -UB 0 1;UC VC 1 0 ; VC -UC 0 1;UD VD 1 0 ; VD -UD 0 1];
XQ1 = inv(A1'*A1)*A1'*L;
lambda1 = sqrt(XQ1(1)^2 +XQ1(2)^2);
teta1 = atan(XQ1(2)/XQ1(1))*180/pi;
Tx1 = XQ1 (3);
Ty1 = XQ1 (4);

format long g
disp(['the lambda is :',num2str(lambda1)]);
disp(['the teta is :',num2str(teta1)]);
disp(['the Tx is :',num2str(Tx1)]);
disp(['the Ty is :',num2str(Ty1)]);
disp('_____________________________________________________________________')
disp(['X = ',num2str(XQ1(1)),' U + ',num2str(XQ1(2)),' V + ',num2str(XQ1(3))]);
disp(['Y = -',num2str(XQ1(2)),' U + ',num2str(XQ1(1)),' V + ',num2str(XQ1(4))]);
disp('***********************************************************************')
%Area1
areaP1 = (UA*VB+UB*VC+UC*VD+UD*VA)-(UB*VA+UC*VB+UD*VC+UA*VD);
areaP1 =abs(areaP1)/2;
areaG1 = (XA*YB+XB*YC+XC*YD+XD*YA)-(XB*YA+XC*YB+XD*YC+XA*YD);
areaG1 =abs(areaG1)/2;

figure();
plot(U1,V1);
text(mean(U1),mean(V1),'pic1.CS');
figure();
plot(X1,Y1);
text(mean(X1),mean(Y1),'ground1.CS');

%length1
ABG1 = sqrt((XB-XA)^2+(YB-YA)^2);
BCG1 = sqrt((XC-XB)^2+(YC-YB)^2);
CDG1 = sqrt((XD-XC)^2+(YD-YC)^2);
DAG1 = sqrt((XA-XD)^2+(YA-YD)^2);
ABP1= sqrt((UB-UA)^2+(VB-VA)^2);
BCP1 = sqrt((UC-UB)^2+(VC-VB)^2);
CDP1 = sqrt((UD-UC)^2+(VD-VC)^2);
DAP1 = sqrt((UA-UD)^2+(VA-VD)^2);

%ANGLE1
MGAB = ((YB-YA) /(XB-XA));
MGBC = ((YC-YB) /(XC-XB));
MGCD = ((YD-YC) /(XD-XC));
MGDA = ((YA-YD) /(XA-XD));
AG1 =90 - atand(abs((MGAB)));
BG1 = atand(abs((MGBC-MGAB)/(1+MGBC*MGAB)));
CG1 = atand(abs((MGCD-MGBC)/(1+MGCD*MGBC)));
DG1 =90 + atand(abs((MGCD)));
MPAB = ((VB-VA) /(UB-UA));
MPBC = ((VC-VB) /(UC-UB));
MPCD = ((VD-VC) /(UD-UC));
MPDA = ((VA-VD) /(UA-UD));
AP1 = atand(abs((MPAB-MPDA)/(1+MPAB*MPDA)));
BP1 = atand(abs((MPBC-MPAB)/(1+MPBC*MPAB)));
CP1 = atand(abs((MPCD-MPBC)/(1+MPCD*MPBC)));
DP1 = atand(abs((MPDA-MPCD)/(1+MPCD*MPDA)));

%Q2
L2= L;
A2 = [UA VA ; VA -UA ;UB VB ; VB -UB ;UC VC ; VC -UC ;UD VD ; VD -UD];
X2 = inv(A2'*A2)*A2'*L2;
lambda2 = sqrt(X2(1)^2 +X2(2)^2);
teta2 = atan(X2(2)/X2(1))*180/pi;

format long g
disp(['the lambda is :',num2str(lambda2)]);
disp(['the teta is :',num2str(teta2)]);
disp('_____________________________________________________________________')
disp(['X = ',num2str(X2(1)),' U + ',num2str(X2(2)),' V  ']);
disp(['Y = -',num2str(X2(2)),' U + ',num2str(X2(1)),' V  ']);
disp('***********************************************************************')

%Area2
areaP2 = (UA*VB+UB*VC+UC*VD+UD*VA)-(UB*VA+UC*VB+UD*VC+UA*VD);
areaP2 =abs(areaP2)/2;
areaG2 = (XA*YB+XB*YC+XC*YD+XD*YA)-(XB*YA+XC*YB+XD*YC+XA*YD);
areaG2 =abs(areaG2)/2;

figure();
plot(U1,V1);
text(mean(U1),mean(V1),'pic2.CS');
figure();
plot(X1,Y1);
text(mean(X1),mean(Y1),'ground2.CS');

%length2
ABG2 = sqrt((XB-XA)^2+(YB-YA)^2);
BCG2 = sqrt((XC-XB)^2+(YC-YB)^2);
CDG2 = sqrt((XD-XC)^2+(YD-YC)^2);
DAG2 = sqrt((XA-XD)^2+(YA-YD)^2);
ABP2= sqrt((UB-UA)^2+(VB-VA)^2);
BCP2 = sqrt((UC-UB)^2+(VC-VB)^2);
CDP2 = sqrt((UD-UC)^2+(VD-VC)^2);
DAP2 = sqrt((UA-UD)^2+(VA-VD)^2);

%ANGLE2
MGAB = ((YB-YA) /(XB-XA));
MGBC = ((YC-YB) /(XC-XB));
MGCD = ((YD-YC) /(XD-XC));
MGDA = ((YA-YD) /(XA-XD));
AG2 =90 - atand(abs((MGAB)));
BG2 = atand(abs((MGBC-MGAB)/(1+MGBC*MGAB)));
CG2 = atand(abs((MGCD-MGBC)/(1+MGCD*MGBC)));
DG2 =90 + atand(abs((MGCD)));
MPAB = ((VB-VA) /(UB-UA));
MPBC = ((VC-VB) /(UC-UB));
MPCD = ((VD-VC) /(UD-UC));
MPDA = ((VA-VD) /(UA-UD));
AP2 = atand(abs((MPAB-MPDA)/(1+MPAB*MPDA)));
BP2 = atand(abs((MPBC-MPAB)/(1+MPBC*MPAB)));
CP2 = atand(abs((MPCD-MPBC)/(1+MPCD*MPBC)));
DP2 = atand(abs((MPDA-MPCD)/(1+MPCD*MPDA)));

%Q3
XA3 = 211.603 ;
YA3 = 166.506 ;
XB3 = 384.808 ;
YB3 = 266.506 ;
XC3 = 434.807 ;
YC3 = 179.904 ;
XD3 = 211.603 ;
YD3 = 51.036 ;
X33 = [XA3;XB3;XC3;XD3;XA3];
Y3 = [YA3;YB3;YC3;YD3;YA3];
L3= [211.603;166.506;384.808;266.506;434.807;179.904;211.603;51.036];
A3 = [UA VA ; VA -UA ;UB VB ; VB -UB ;UC VC ; VC -UC ;UD VD ; VD -UD];
X3 = inv(A3'*A3)*A3'*L3;
teta3 = asin(X3(2))*180/pi;

format long g
disp(['the teta is :',num2str(teta3)]);
disp('_____________________________________________________________________')
disp(['X = ',num2str(X2(1)),' U + ',num2str(X2(2)),' V  ']);
disp(['Y = -',num2str(X2(2)),' U + ',num2str(X2(1)),' V  ']);
disp('***********************************************************************')

%Area3
areaP3 = (UA*VB+UB*VC+UC*VD+UD*VA)-(UB*VA+UC*VB+UD*VC+UA*VD);
areaP3 =abs(areaP3)/2;
areaG3 = (XA3*YB3+XB3*YC3+XC3*YD3+XD3*YA3)-(XB3*YA3+XC3*YB3+XD3*YC3+XA3*YD3);
areaG3 =abs(areaG3)/2;
text(mean(U1),mean(V1),'pic3.CS');
text(mean(X33),mean(Y3),'ground3.CS');

figure();
plot(U1,V1);
text(mean(U1),mean(V1),'pic3.CS')
figure();
plot(X33,Y3);
text(mean(X33),mean(Y3),'ground3.CS')

%length
ABG3 = sqrt((XB3-XA3)^2+(YB3-YA3)^2);
BCG3 = sqrt((XC3-XB3)^2+(YC3-YB3)^2);
CDG3 = sqrt((XD3-XC3)^2+(YD3-YC3)^2);
DAG3 = sqrt((XA3-XD3)^2+(YA3-YD3)^2);
ABP3= sqrt((UB-UA)^2+(VB-VA)^2);
BCP3 = sqrt((UC-UB)^2+(VC-VB)^2);
CDP3 = sqrt((UD-UC)^2+(VD-VC)^2);
DAP3 = sqrt((UA-UD)^2+(VA-VD)^2);

%ANGLE2
MGAB3 = ((YB3-YA3) /(XB3-XA3));
MGBC3 = ((YC3-YB3) /(XC3-XB3));
MGCD3 = ((YD3-YC3) /(XD3-XC3));
MGDA3 = ((YA3-YD3) /(XA3-XD3));
AG3 =90 - atand(abs((MGAB3)));
BG3 = atand(abs((MGBC3-MGAB3)/(1+MGBC3*MGAB3)));
CG3 = atand(abs((MGCD3-MGBC3)/(1+MGCD3*MGBC3)));
DG3 =90 + atand(abs((MGCD3)));
MPAB3 = ((VB-VA) /(UB-UA));
MPBC3 = ((VC-VB) /(UC-UB));
MPCD3 = ((VD-VC) /(UD-UC));
MPDA3 = ((VA-VD) /(UA-UD));
AP3 = atand(abs((MPAB-MPDA)/(1+MPAB*MPDA)));
BP3 = atand(abs((MPBC-MPAB)/(1+MPBC*MPAB)));
CP3 = atand(abs((MPCD-MPBC)/(1+MPCD*MPBC)));
DP3 = atand(abs((MPDA-MPCD)/(1+MPCD*MPDA)));
