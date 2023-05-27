clear; clc; close; 
%%Para encontrar los parametros del motor y encontrar el modelo
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
opt.StepAmplitude =12; %unitario

%Muestreo 3 puntos que describan la dinámica del sistema, es
% Importante tomar valores que si estén en la tabla. Por lo
% que tal vez no sea el doble o el triple de t1 pero si los
% mas cercanos
int=250;
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
 
 %%Para verificar el modelo obtenido con las curvas dadas
 
clear all;
X=[0; 0; 0; 0]; %Condiciones iniciales

t_etapa=1e-4; %Tiempo de integracion
tF=1; % Tiempo de Simulacion
ii=0;

u=0;

  TL=0;
for t=0:t_etapa:tF
 ii=ii+1;
if(t>=0.0249 & t<=0.15)
     u=12;
 end

 if(t>0.15)
     u=-12;
 end
  if (t>=0.1504)
  
      TL=-3.5e-2;
      % TL=-7.5e-2;
      
  end
      
 X=modmotor2(t_etapa, X, u,TL); %(Tiempo de integracion, Condiciones iniciales, accion de control, carga)

 x1(ii)=X(1); %Omega
 x2(ii)=X(2); %wp
 x3(ii)=X(3); %ia
 x4(ii)=X(4); %theta

   
 acc(ii)=u;
 Carga(ii)=TL;
end
%Grafico
t=0:t_etapa:tF;

hold on;
subplot(4,1,1);hold on;
plot(t,x1,'r');title('Salida omega, w');grid

subplot(4,1,2);hold on;
plot(t,x3,'b');title('Salida corriente de armadura, ia');
xlabel('Tiempo [Seg.]');

subplot(4,1,3);hold on;
plot(t,acc,'g');title('Entrada, Va');
xlabel('Tiempo [Seg.]');

subplot(4,1,4);hold on;
plot(t,Carga,'m');title('Carga, TL');
xlabel('Tiempo [Seg.]');


hold off

% clear; clc; close; 

%Importo los datos de la tabla
data=xlsread('Curvas_Medidas_Motor_2023.xlsx','Hoja1');
%1_t Tiempo
%2_omega VelAngular
%3_ia Corriente armadura
%4_v Tension
%5_TL Torque

%Sin tener encuenta el retardo, solo la respuesta a los +12
t=data(:,1);
omega=data(:,2);
ia=data(:,3);
v=data(:,4);
TL=data(:,5);

clearvars data raw;
hold on
subplot(4,1,1); plot(t,omega,''); title('Velocidad angular w,t');
subplot(4,1,2); plot(t,ia,''); title('Corriente de armadura ia,t');
subplot(4,1,3); plot(t,v,''); title('Tension v,t');
subplot(4,1,4); plot(t,TL,''); title('Carga TL,t');
