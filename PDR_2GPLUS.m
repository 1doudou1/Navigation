clear;clc;clf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算步数程序%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 滤波只能运行一次，否则滤波次数越来越多，north_angle就没了

load('C:\Users\CGK-nudt\Desktop\PDR_2G+\matlab.mat')
ZACC1=smooth(ZACC,50);                  % 跟采集的数据长度也有关系
north_angle=smooth(north_angle,3);   % 把方向角数据进行滤波
for i=1:size(north_angle,2)             % 针对方向角采集存在问题
 if north_angle(i)<50
    north_angle(i)=north_angle(i)+360;
 end
end
north_angle=(north_angle*pi)./180;plot(0:length(ZACC1)-1,ZACC1);
[value,index]=findpeaks(ZACC1);
for i=1:length(value)
  if  value(i)<9.5;               %11这个值有点像调参调出来的
      value(i)=0;
  end
end

  %%COUNT函数
  b=value' ;        %将value转置，改为求b每列非零的个数
  b=(b>0|b<0);      %将b中元素不等于0的记为1，等于0的记为0
  count=sum(b);     %将b按列求和， c各分量就是a对应行中非零元素的个数
  %   count=ones(size(north_angle));                  %验证推算
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算步长%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 静态步长模型
L=0.25;
  
%% 动态步长模型 航位推算时应该改为：L（k-1）
% %构造最大加速度值矩阵
% %输出amax,amax_point
% %count代表非零元素的个数
% q=1;
% for m=1:length(value)
%     if value(m)~=0
%       amax(q)=value(m);   %最大加速度值
%       amax_point(q)=index(m);   %对应采样点数
%       q=q+1;
%     end
% end
% 
% 
% %构造最小加速度值矩阵
% %输出amin
% for i=1:length(amax_point)
%     phase_range=ZACC(1,1:amax_point(i));
%     amin(i)=min(phase_range);
% end 
% 
% 
% %SCARLET算法,返回步长矩阵，1*count
% L=0.81*((mean(ZACC)-amin)./(amax-amin));
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%航位推算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x(1)=0;   %设定初始值 可以根据GPS丢失位置进行设定
y(1)=0;
index=round((index'./length(ZACC))*length(north_angle));  %加速度采集到峰值点时间转换成陀螺仪峰值点数值

for k=2:count+1
  x(k)=x(k-1)+L*sin(north_angle(index(k-1))+(north_angle(index(k))-north_angle(index(k-1)))./2);
  %式8.3
  y(k)=y(k-1)+L*cos(north_angle(index(k-1))+(north_angle(index(k))-north_angle(index(k-1)))./2);
  %式8.4
end
plot(0,0,'ks');                                            %实验的坐标原点
hold on;
figure(1);
x=-x;
y=-y;
plot(x,y);
xlabel('正东方向')
ylabel('正北方向')
hold on

%% REAL_TRACE_PLOT
X=[0 3.3 -0.2 -3.6];            % 四个顶点 7m*5.5m
Y=[0 6.4 8.8 2.4];             % 四个顶点
X=[X X(1)];                               % 首尾相接
Y=[Y Y(1)];
axis([-5 5 -2 10])
plot(X,Y,'color','r');
legend('起始点坐标','PDR解算轨迹','真实轨迹')
%% Calculate Error
IPS_ERROR=Calculate_error(x,y);
disp('IPS error is:');
disp(IPS_ERROR);

% %% 融合Barometer
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
% legend('行走起点','行人轨迹','行走终点')
% xlabel('X轴')
% ylabel('Y轴')
% zlabel('Z轴')