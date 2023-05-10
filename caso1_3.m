clear; clc; close; 

%Para la tension del capacitor:
%Importo los datos de la tabla
data=xlsread('Curvas_Medidas_RLC.xls','Hoja1');
t=data(:,1);
corriente=data(:,2);
tension_c=data(:,3);
clearvars data raw;
%Segun la tabla la tension en el cap es:
% figure (1)
plot(t,tension_c,'r'); title('Vc medida en tabla,t');
hold on

%Metodo de Chena:
%Defino el escalon
opt = stepDataOptions;
opt.StepAmplitude =1; %unitario



%Muestreo 3 puntos que describan la dinámica del sistema, es
% Importante tomar valores que si estén en la tabla. Por lo
% que tal vez no sea el doble o el triple de t1 pero si los
% mas cercanos
% t_inic=1e-4; %tomando como tiempo inicial
% [val lugar] =min(abs(t_inic-t));
% y1=tension_c(lugar);
% t1=t(lugar);
% [val lugar] =min(abs(2*t_inic-t));
% t2=t(lugar);
% y2=tension_c(lugar);
% [val lugar] =min(abs(3*t_inic-t));
% t3=t(lugar);
% y3=tension_c(lugar);

t1=0.0110;
t2=0.0220;
t3=0.0330;
y1=1.4295;
y2=11.1509;
y3=11.9332;
K=12;

ii=1;
%siguiendo el método
% K=tension_c(end)/opt.StepAmplitude; %ganancia estatica

k1=(1/opt.StepAmplitude)*y1/K-1;
k2=(1/opt.StepAmplitude)*y2/K-1;
k3=(1/opt.StepAmplitude)*y3/K-1;

be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;

alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));

% alfa1= (k3 + k1*k2 - (4*k1^3*k3 - 3*k1^2*k2^2 + 6*k1*k2*k3 - 4*k2^3 + k3^2)^(1/2))/(2*(k1^2 + k2));
% alfa2= (k3 + k1*k2 + (4*k1^3*k3 - 3*k1^2*k2^2 + 6*k1*k2*k3 - 4*k2^3 + k3^2)^(1/2))/(2*(k1^2 + k2));



beta=(k1+alfa2)/(alfa1-alfa2);
% beta=(2*k1^3+3*k1*k2+k3-sqrt(be))/(sqrt(be));



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

Config = RespConfig('InputOffset',0,'Amplitude',1,'Delay',0);
step(sys_G_ang,Config,'y'); title('Vc del metodo,t'); %Grafico la ft modelada
hold off

