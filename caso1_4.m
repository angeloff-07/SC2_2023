clear; clc; close;

R=220; L=99.11e-3; C=21.95e-6; %Valores deducidos
vin=-12;
i=1; %La iteracion comienza en 1
t=[]; %Genero t

%Calculo constantes de tiempo
h=4e-7;  
tf=0.1; 
pasos=tf/h;

te=0.04;%vamos cambiando cada 1ms la entrada

%Condiciones iniciales
vc(1)=0; i1(1)=0; u(1)=12;
vin=vin*-1;

%Modelado
A=[[-R/L -1/L] ; [1/C 0]];

B=[1/L ; 0];
C=[R 0];
X0=[0 0]';x=[0 0]'; %Transpuestas

while(i<=pasos+1)

t(i)=i*h; %t aumenta con i
u(i)=vin; %prearo la entrada para el cambio

%variables de estado del sistema
i1(i)=x(1);
vc(i)=x(2);

%Sistema modelado en el espacio de estados
xp=A*(x-X0)+B*u(i);
x=x+(h*xp);

if(t(i)>te)

vin=vin*(-1); %Cambiamos el signo de la entrada
te=te+0.04;
%cada 1mseg
end

i=i+1;
end

%Grafico
plot(t,i1,'r'); title('I1,t');
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%Para la corriente del circuito:
%Importo los datos de la tabla
data=xlsread('Curvas_Medidas_RLC.xls','Hoja1');

%sin tener encuenta el retraso
t=data(102:end,1)-0.01;
corriente=data(102:end,2);

clearvars data raw;
%Segun la tabla la corriente es:
 plot(t,corriente,'g'); title('I medida en tabla,t');

hold off
