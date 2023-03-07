clc;
clear all;
close all;
global Cm r_Ca Ca_SR k_up A_K1 A_x1 g_Na;
global g_NaC V_Na g_s A_s t_on t_dur;
Cm = 1; % uC/cmˆ2 
r_Ca = 1e-7; % M*cmˆ2/nC 
Ca_SR = 1e-7; % M
k_up = 0.07; % 1/ms 
A_K1 = 0.35; % uA/cmˆ2 
A_x1 = 0.8; % uA/cmˆ2 
V_Na = 50; % mV 
g_Na = 4; % mS/cmˆ2 
g_NaC = 0.003; % mS/cmˆ2 
g_s = 0.09; % mS/cmˆ2 
A_s = 40; % uA/cmˆ2 
t_on = 1; % ms 
t_dur = 1; % ms
Y_init = [-83.3, 1.87e-7, 0.1644, 0.01, 0.9814, 0.9673,0.0033, 0.9884];
options = odeset('MaxStep', 0.1);
[time, Y_out] = ode15s(@BR_prime, [0 400], Y_init, options);
plot(time, Y_out(:,1), 'k');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
title('Beeler-Reuter Action Potential');

function y_prime = BR_prime(t,y)
global Cm r_Ca Ca_SR k_up A_K1 A_x1 g_Na;
global g_NaC V_Na g_s A_s t_on t_dur;
y_prime = zeros(8,1);
V = y(1);
Ca = y(2);
x1 = y(3);
m = y(4);
h = y(5);
j = y(6);
d = y(7);
f = y(8);
alpha_x1 = 0.0005*exp(0.083*(V+50))/(exp(0.057*(V+50))+1);
beta_x1 = 0.0013*exp(-0.06*(V+20))/(exp(-0.04*(V+20))+1);
alpha_m = -(V+47)/(exp(-0.1*(V+47))-1);
beta_m = 40*exp(-0.056*(V+72));
alpha_h = 0.126*exp(-0.25*(V+77));
beta_h = 1.7/(exp(-0.082*(V+22.5))+1);
alpha_j = 0.055*exp(-0.25*(V+78))/(exp(-0.2*(V+78))+1);
beta_j = 0.3/(exp(-0.1*(V+32))+1);
alpha_d = 0.095*exp(-0.01*(V-5))/(exp(-0.072*(V-5))+1);
beta_d = 0.07*exp(-0.017*(V+44))/(exp(0.05*(V+44))+1);
alpha_f = 0.012*exp(-0.008*(V+28))/(exp(0.15*(V+28))+1);
beta_f = 0.0065*exp(-0.02*(V+30))/(exp(-0.2*(V+30))+1);
V_Ca = -82.3-13.0287*log(Ca);

i_K1 = A_K1*(4*(exp(0.04*(V+85))-1)/(exp(0.08*(V+53))+exp(0.04*(V+53)))+0.2*(V+23)/(1-exp(-0.04*(V+23))));
i_x1 = A_x1*x1*(exp(0.04*(V+77))-1)/exp(0.04*(V+35));
i_Na = (g_Na*m^3*h*j + g_NaC)*(V-V_Na);
i_s = g_s*d*f*(V-V_Ca);

if ((t >= t_on)&&(t<t_on+t_dur))
    i_stim = A_s;
else
    i_stim = 0;
end
y_prime(1) = -(i_K1+i_x1+i_Na+i_s-i_stim)/Cm;
y_prime(2) = -r_Ca*i_s+k_up*(Ca_SR-Ca);
y_prime(3) = alpha_x1*(1-x1)-beta_x1*x1;
y_prime(4) = alpha_m*(1-m)-beta_m*m;
y_prime(5) = alpha_h*(1-h)-beta_h*h;
y_prime(6) = alpha_j*(1-j)-beta_j*j;
y_prime(7) = alpha_d*(1-d)-beta_d*d;
y_prime(8) = alpha_f*(1-f)-beta_f*f;
end
