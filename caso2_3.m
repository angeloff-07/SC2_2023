clear; clc; close; 

%Importo los datos de la tabla
data=xlsread('Curvas_Medidas_Motor_2023.xlsx','Hoja1');
%1_t Tiempo
%2_omega VelAngular
%3_ia Corriente armadura
%4_v Tension
%5_TL Torque

%Sin tener encuenta el retardo, solo la respuesta a los +12
t=data(102:15306,1)-0.0250;
omega=data(102:15306,2);
% ia=data(:,3);
% v=data(:,4);
% TL=data(:,5);

clearvars data raw;
hold on
% subplot(4,1,1); plot(t,omega,'r'); title('Velocidad angular w,t');
% subplot(4,1,2); plot(t,ia,'b'); title('Corriente de armadura ia,t');
% subplot(4,1,3); plot(t,v,'g'); title('Tension v,t');
% subplot(4,1,4); plot(t,TL,'b'); title('Carga TL,t');

plot(t,omega,'r'); title('Velocidad angular w,t');


%Metodo de Chena:
%Defino el escalon
opt = stepDataOptions;
opt.StepAmplitude =1; %unitario

%Muestreo 3 puntos que describan la dinámica del sistema, es
% Importante tomar valores que si estén en la tabla. Por lo
% que tal vez no sea el doble o el triple de t1 pero si los
% mas cercanos
int=2000;
t_inic=t(int); %tomando como tiempo inicial
[val lugar] =min(abs(t_inic-t));
y1=omega(lugar);
t1=t(lugar);
[val lugar] =min(abs(2*t_inic-t));
t2=t(lugar);
y2=omega(lugar);
[val lugar] =min(abs(3*t_inic-t));
t3=t(lugar);
y3=omega(lugar);

K=198.2488;
% K=omega(end)/opt.StepAmplitude; %ganancia estatica
ii=1;
%siguiendo el método

k1=(1/opt.StepAmplitude)*y1/K-1;
k2=(1/opt.StepAmplitude)*y2/K-1;
k3=(1/opt.StepAmplitude)*y3/K-1;

be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;

alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));
beta=(k1+alfa2)/(alfa1-alfa2);

T1_ang=-t1/log(alfa1);
T2_ang=-t1/log(alfa2);
T3_ang=beta*(T1_ang-T2_ang)+T1_ang;
T1(ii)=T1_ang;
T2(ii)=T2_ang;
T3(ii)=T3_ang;
T3_ang=sum(T3/length(T3));
T2_ang=sum(T2/length(T2));
T1_ang=sum(T1/length(T1));

 sys_G_ang=tf(K*[T3_ang 1],conv([T1_ang 1],[T2_ang 1]));
 sys_G_ang
 step(sys_G_ang,stepDataOptions,'y'); title('w del metodo,t'); %Grafico la ft modelada
 hold off
