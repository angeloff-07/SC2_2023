clear all;
X=[0; 0; 0; 0]; %Condiciones iniciales

t_etapa=1e-4; %Tiempo de integracion
tF=0.1; % Tiempo de Simulacion

thetaRef=1; %Valor de referencia que busco en la salida

%%PID 
Kp=22.5;Ki=0;Kd=0;color_='b';

Ts=t_etapa; % Ts=Tiempo de muestreo

%Coeficientes A, B, y C se relacionan con los parametros del PID
 A1=((2*Kp*Ts)+(Ki*(Ts^2))+(2*Kd))/(2*Ts); 
 B1=(-2*Kp*Ts+Ki*(Ts^2)-4*Kd)/(2*Ts); 
 C1=Kd/Ts; 

e=zeros(round(tF/t_etapa),1);

ii=0;

u=0;
u_min=-12;
u_max=12;
 
TL=-3.5e-2;

for t=0:t_etapa:tF
 ii=ii+1;

 k=ii+2;
      
 X=modmotor2(t_etapa, X, u,TL); %(Tiempo de integracion, Condiciones iniciales, accion de control, carga)

    e(k)=thetaRef-X(4); %ERROR en k---> theta deseada - theta actual
    
    u=u+A1*e(k)+B1*e(k-1)+C1*e(k-2); %PID-->Usamos el error de k, el de k-1 y el de k-2  

 x1(ii)=X(1); %Omega
 x2(ii)=X(2); %wp
 x3(ii)=X(3); %ia
 x4(ii)=X(4); %theta

 %Limito la accion de control
    if u<u_min
    u=u_min
     end

    if u>u_max
    u=u_max
    end

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
plot(t,x4,'m');title('Angulo, theta');
xlabel('Tiempo [Seg.]');

hold off
