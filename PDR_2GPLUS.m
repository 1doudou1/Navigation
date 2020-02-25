clear;clc;clf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���㲽������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �˲�ֻ������һ�Σ������˲�����Խ��Խ�࣬north_angle��û��

load('C:\Users\CGK-nudt\Desktop\PDR_2G+\matlab.mat')
ZACC1=smooth(ZACC,50);                  % ���ɼ������ݳ���Ҳ�й�ϵ
north_angle=smooth(north_angle,3);   % �ѷ�������ݽ����˲�
for i=1:size(north_angle,2)             % ��Է���ǲɼ���������
 if north_angle(i)<50
    north_angle(i)=north_angle(i)+360;
 end
end
north_angle=(north_angle*pi)./180;plot(0:length(ZACC1)-1,ZACC1);
[value,index]=findpeaks(ZACC1);
for i=1:length(value)
  if  value(i)<9.5;               %11���ֵ�е�����ε�������
      value(i)=0;
  end
end

  %%COUNT����
  b=value' ;        %��valueת�ã���Ϊ��bÿ�з���ĸ���
  b=(b>0|b<0);      %��b��Ԫ�ز�����0�ļ�Ϊ1������0�ļ�Ϊ0
  count=sum(b);     %��b������ͣ� c����������a��Ӧ���з���Ԫ�صĸ���
  %   count=ones(size(north_angle));                  %��֤����
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���㲽��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��̬����ģ��
L=0.25;
  
%% ��̬����ģ�� ��λ����ʱӦ�ø�Ϊ��L��k-1��
% %���������ٶ�ֵ����
% %���amax,amax_point
% %count�������Ԫ�صĸ���
% q=1;
% for m=1:length(value)
%     if value(m)~=0
%       amax(q)=value(m);   %�����ٶ�ֵ
%       amax_point(q)=index(m);   %��Ӧ��������
%       q=q+1;
%     end
% end
% 
% 
% %������С���ٶ�ֵ����
% %���amin
% for i=1:length(amax_point)
%     phase_range=ZACC(1,1:amax_point(i));
%     amin(i)=min(phase_range);
% end 
% 
% 
% %SCARLET�㷨,���ز�������1*count
% L=0.81*((mean(ZACC)-amin)./(amax-amin));
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��λ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x(1)=0;   %�趨��ʼֵ ���Ը���GPS��ʧλ�ý����趨
y(1)=0;
index=round((index'./length(ZACC))*length(north_angle));  %���ٶȲɼ�����ֵ��ʱ��ת���������Ƿ�ֵ����ֵ

for k=2:count+1
  x(k)=x(k-1)+L*sin(north_angle(index(k-1))+(north_angle(index(k))-north_angle(index(k-1)))./2);
  %ʽ8.3
  y(k)=y(k-1)+L*cos(north_angle(index(k-1))+(north_angle(index(k))-north_angle(index(k-1)))./2);
  %ʽ8.4
end
plot(0,0,'ks');                                            %ʵ�������ԭ��
hold on;
figure(1);
x=-x;
y=-y;
plot(x,y);
xlabel('��������')
ylabel('��������')
hold on

%% REAL_TRACE_PLOT
X=[0 3.3 -0.2 -3.6];            % �ĸ����� 7m*5.5m
Y=[0 6.4 8.8 2.4];             % �ĸ�����
X=[X X(1)];                               % ��β���
Y=[Y Y(1)];
axis([-5 5 -2 10])
plot(X,Y,'color','r');
legend('��ʼ������','PDR����켣','��ʵ�켣')
%% Calculate Error
IPS_ERROR=Calculate_error(x,y);
disp('IPS error is:');
disp(IPS_ERROR);

% %% �ں�Barometer
% figure(2)
% z=[zeros(1,83)];
% z=[z,0:0.05:1,ones(1,100)];
% x=[x,x];
% y=[y,y];
% plot3(0,0,0,'ro')
% hold on
% plot3(x,y,z);
% hold on
% plot3(0.6,1.3,1,'kd')
% grid on
% legend('�������','���˹켣','�����յ�')
% xlabel('X��')
% ylabel('Y��')
% zlabel('Z��')