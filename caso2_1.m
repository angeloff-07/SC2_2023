clear all;
X=[0; 0; 0; 0]; %Condiciones iniciales

t_etapa=1e-4; %Tiempo de integracion
tF=5; % Tiempo de Simulacion
ii=0;

u=12;
% TL=2.1e-5;
  TL=0;
for t=0:t_etapa:tF
 ii=ii+1;
  if (TL<2.1e-5)
  
     TL=(t/100000)-0.5e-5; %incremento linealmente la carga
  
  else
      TL=2.1e-5;
  end
  
    
 X=modmotor(t_etapa, X, u,TL); %(Tiempo de integracion, Condiciones iniciales, accion de control, carga)

 x1(ii)=X(1); %Omega
 x2(ii)=X(2); %wp
 x3(ii)=X(3); %ia
 x4(ii)=X(4); %theta

 acc(ii)=u;
 Carga(ii)=TL;
end
%Grafico
t=0:t_etapa:tF;
subplot(3,1,1);
hold on;
plot(t,x1,'r');title('Salida omega, w');grid


subplot(3,1,2);hold on;
plot(t,Carga,'m');title('Carga, TL');
xlabel('Tiempo [Seg.]');

 subplot(3,1,3);hold on;
 plot(t,x3,'b');title('Salida corriente de armadura, ia');
 xlabel('Tiempo [Seg.]');
hold off
