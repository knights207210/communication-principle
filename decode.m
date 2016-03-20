function B=decode(A)
L=length(A);
l=(L-4)/2;
B=zeros(1,1);
D=zeros(1,4);
DTemp=D;
RouteS0=zeros(1,L);
RouteS1=zeros(1,L);
RouteS2=zeros(1,L);
RouteS3=zeros(1,L);
for k=1:l+2
    if k==1
        D(1)=A(1)+A(2);
        D(2)=abs(A(1)-1)+abs(A(2)-1);
    elseif k==1
        DS0_S0=A(3)+A(4);
        DS0_S1=abs(A(3)-1)+abs(A(4)-1);
        DS1_S2=abs(A(3)-1)+A(4);
        DS1_S3=A(3)+abs(A(4)-1);
        D(1)=DTemp(1)+DS0_S0;
        D(2)=Dtemp(1)+DS0_S1;
        D(3)=Dtemp(2)+DS1_S2;
        D(4)=DTemp(2)+DS1_S3;
        RouteS0(1:4)=[0 0 0 0];
        RouteS1(1:4)=[0 0 1 0];
        RouteS2(1:4)=[1 0 0 1];
        RouteS3(1:4)=[1 0 1 1];
    else
        DS0_S0=A(2*k-1)+A(2*k);
        DS2_S0=abs(A(2*k-1)-1)+abs(A(2*k)-1);
        DS0_S1=DS2_S0;
        DS2_S1=DS0_S0;
        DS1_S2=abs(A(2*k-1)-1)+A(2*k);
        DS3_S2=A(2*k-1)+abs(A(2*k)-1);
        DS1_S3=DS3_S2;
        DS3_S3=DS1_S2;
        RS0Temp=RouteS0(1:2*k-2);
        RS1Temp=RouteS1(1:2*k-2);
        RS2Temp=RouteS2(1:2*k-2);
        RS3Temp=RouteS3(1:2*k-2);
        DTemp=D;
        if(DTemp(1)+DS0_S0<=DTemp(3)+DS2_S0)
            D(1)=DTemp(1)+DS0_S0;
            RouteS0(1:2*k)=[RS0Temp 0 0];
        else
            D(1)=DTemp(3)+DS2_S0;
            RouteS0(1:2*k)=[RS2Temp 0 0];
        end
        if (DTemp(1)+DS0_S1 <= DTemp(3)+DS2_S1)
            D(2)=DTemp(1)+DS0_S1;
            RouteS1(1:2*k)=[RS0Temp 1 0];
        else
            D(2)=DTemp(3)+DS2_S1;
            RouteS1(1:2*k)=[RS2Temp 1 0];
        end
        if (DTemp(2)+DS1_S2<=DTemp(4)+DS3_S2)
            D(3)=DTemp(2)+DS1_S2;
            RouteS2(1:2*k)=[RS1Temp 0 1];
        else
            D(3)=DTemp(4)+DS3_S2;
            RouteS2(1:2*k)=[RS3Temp 0 1];
        end
        if(DTemp(2)+DS1_S3<=DTemp(4)+DS3_S3)
            D(4)=DTemp(2)+DS1_S3;
            RouteS3(1:2*k)=[RS1Temp 1 1];
        else
            D(4)=DTemp(4)+DS3_S3;
            RouteS3(1:2*k)=[RS3Temp 1 1];
        end
    end
end
for m=1:l
    if(m==1)
        if(RouteS0(1)==0)
            B(1)=0;
        else
            B(1)=1;
        end
    elseif(m==2)
        if(RouteS0(3)==0)
            B(2)=0;
        else
            B(2)=1;
        end
    else
        L1=2*m-3;
        R1=2*m-2;
        L2=2*m-1;
        R2=2*m;
        if((RouteS0(L1:R1)==[0 0]|RouteS0(L1:R1)==[0 1])&RouteS0(L2:R2)==[0 0])
            B(m)=0;
        elseif ((RouteS0(L1:R1)==[1 0]|RouteS0(L1:R1)==[1 1])&RouteS0(L2:R2)==[0 1])
            B(m)=0;
        else
            B(m)=1;
        end
    end
end
