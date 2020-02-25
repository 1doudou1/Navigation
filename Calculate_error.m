function [IPS_ERROR] = Calculate_error( x,y )
%   分段计算误差
for i=1:length(x)
   % 矩形第一边
   if i<32
    x0=0;y0=0;
    x1=3.3;y1=6.4;
    a=y1-y0; b=x0-x1; c=(x1-x0)*y0-(y1-y0)*x0;
    d(i)=abs(a.*x(i)+b.*y(i)+c)./sqrt(a*a+b*b);
   end
   % 矩形第二边
    if  31<i<52
    x0=3.3;y0=6.4;
    x1=-0.2;y1=8.8;
    a=y1-y0; b=x0-x1; c=(x1-x0)*y0-(y1-y0)*x0;
    d(i)=abs(a*x(i)+b*y(i)+c)./sqrt(a*a+b*b);
    end
   % 矩形第三边
    if 51<i<84
        x0=-0.2;y0=8.8;
        x1=-3.6;y1=2.4;
        a=y1-y0; b=x0-x1; c=(x1-x0)*y0-(y1-y0)*x0;
        d(i)=abs(a*x(i)+b*y(i)+c)./sqrt(a*a+b*b);
    end
   % 矩形第四边 
    if  83<i
        x0=-5.6;y0=0.9;
        x1=0;y1=0;
        a=y1-y0; b=x0-x1; c=(x1-x0)*y0-(y1-y0)*x0;
        d(i)=abs(a*x(i)+b*y(i)+c)./sqrt(a*a+b*b);
    end
IPS_ERROR=sum(d)./length(d);
end

