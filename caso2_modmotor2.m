function [X]=modmotor(t_etapa, xant, accion,TL)

Laa=495.28e-6;
J=4.129e-6;
Ra=100;
B=0;
Ki=16.52;
Km=0.0605;

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
