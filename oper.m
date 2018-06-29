function countSSE=oper(xGet,yGet,totoal,pointGet)

xw=xGet;
yw=yGet;
cnt=totoal;
point=pointGet;
countSSE=0;
number=floor(cnt/point);
temp=cnt;
cnt=cnt-mod(temp,number);
for k=temp+1:1:cnt
    xw(k)=0;
    yw(k)=0;
end
for j=1:1:number
    fprintf(1,'计算第%d段函数\n',j);
    x=xw((j-1)*(cnt/number)+1):(j*(cnt/number)+1);
    y=yw((j-1)*(cnt/number)+1):(j*(cnt/number)+1);
    warning('off')
    nx=length(x);
    ny=length(y);
    n=length(x);
    if nx==ny
        x1=x(1);xn=x(n);
        for m=1:point
            [p,S]=polyfit(x,y,m);
            warning('off')
            [yh,delta]=polyconf(p,x,S);
            SSE(m)=sum((y-yh).^2);
        end
        [sd,m]=min(SSE);
        fprintf('输出最适m=%d',m);
        [p,S]=polyfit(x,y,m);
        fprintf('\n输出多项式');
        poly2sym(p);
        disp('输出多项式的有关信息S');
        disp(S);
        [yh,delta]=polyconf(p,x,S);
        SSE=sum((y-yh).^2);
        if SSE<1
            countSSE=countSSE+1;
        end
        RMSE=sqrt(SSE/(n-2));
        R_square=sum((yh-mean(y)).^2)/sum((y-mean(y)).^2);
        fprintf(1,'剩余平方和SSE=%d\n',SSE);
        fprintf('\n');
        fprintf(1,'标准误差RMSE=%d\n',RMSE);
        fprintf('\n');
        fprintf(1,'相关指数R_square=%d\n',R_square);
        fprintf('\n');
    else
        clear;
    end
end