clc;
clear all;
close all;
%% Step 0
%  In = input('Ii=','s');
I0= input('I0=');
tpw= input('tpw=');
% I0=75;
% tpw=0.2;
dt=0.01;

% loop=500;%number of iterations
Erest=-68;
ek=-74.7;
ena = 54.2; 
Cm=1;
Gk = 12; 
Gna = 30;
n(1)=0.3;
m(1)=0.065;
h(1)=0.6;
Vm(1)=-68; 


t=zeros();
v=zeros();
an=zeros(); bn=zeros(); am=zeros(); bm=zeros(); ah=zeros(); bh=zeros();
dn=zeros();dm=zeros();dh=zeros(); gk=zeros(); gna=zeros(); Ik=zeros();
Ina=zeros();Is=zeros();dVm=zeros();
tmax=15;  
i=1;

% tpw=0.2;
% I0=5;

%%Step 1
while(t(i)<tmax)
 v(i)= Vm(i)-Erest;
an(i)=(0.01*(10-v(i)))/(exp((10-v(i))/10)-1);
    bn(i)=0.125*exp((-1)*v(i)/80);
    am(i)=(0.1*(25-v(i)))/(exp((25-v(i))/10)-1);
    bm(i)=4*exp((-1)*v(i)/18);
    ah(i)=0.07*exp((-1)*v(i)/20);
    bh(i)=1/(exp((30-v(i))/10)+1);
    dn(i)=dt*((an(i)*(1-n(i)))-(bn(i)*n(i)));
    dm(i)=dt*((am(i)*(1-m(i)))-(bm(i)*m(i)));
    dh(i)=dt*((ah(i)*(1-h(i)))-(bh(i)*h(i)));
% dn(i)=dt*((an*(1-n(i)))-(bn*n(i)));
% dm(i)=dt*((am*(1-m(i)))-(bm*m(i)));
% dh(i)=dt*((ah*(1-h(i)))-(bh*h(i)));
n(i+1)=n(i)+dn(i);
m(i+1)=m(i)+dm(i);
h(i+1)=h(i)+dh(i);

gk(i)=Gk*(n(i)^4); gna(i)=Gna*(m(i)^3)*h(i);
 Ik(i)=gk(i)*(Vm(i)-ek);  Ina(i)=gna(i)*(Vm(i)-ena);

 if((t(i)>0)&&(t(i)<tpw))
      Is(i) = I0;
    else
        Is(i)=0;
 end
    % Total capacitive current
    Ic(i)= Is(i)-(Ik(i)+Ina(i));
     % membrane voltage
    dVm(i) = (Ic(i)/Cm)*dt;
    Vm(i+1)=Vm(i)+dVm(i);
     i=i+1;
    t(i)=t(i-1)+dt;
end
figure;
plot(t,Vm,'blue')
% ,t(1:end-1),gk,'red',t(1:end-1),gna,'green');
% legend('Action Potential')
% ,'gk','gna')
title('Nerve action potential');
%h=legend('Action potential','gk','gna',3);
%set(h,'Location','NorthEast');    
% xlabel('Time (msec)');
%  hold on
% Ic(1,1502)=0;
%  plot(t,Ic,'red')



