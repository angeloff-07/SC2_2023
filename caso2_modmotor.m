function [X]=modmotor(t_etapa, xant, accion,TL)


Laa=366e-6; J=5e-9;Ra=55.6;B=0;Ki=6.49e-3;Km=6.53e-3;
Va=accion;
h=1e-7;

omega= xant(1);
wp= xant(2);
ia= xant(3);
theta= xant(4);

for ii=1:t_etapa/h
 wpp =(-wp*(Ra*J+Laa*B)-omega*(Ra*B+Ki*Km)+Va*Ki)/(J*Laa); %Ec 6
 iap=(-Ra*ia -Km*omega+Va)/Laa; %Ec 5
 wp=wp+h*wpp; %Integrando
 wp=wp-((1/J)*TL); %Considerado el torque externo

 omega = omega + h*wp; %Integrando
 
 ia=ia+iap*h; %Integrando

 thetap=omega; %Ec 7
 theta=theta+thetap*h; %Integrando
end
X=[omega,wp,ia,theta];
