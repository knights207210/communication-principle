%用for循环语句生成50x50的矩阵
for m=1:50
    for n=1:50
        A(m,n)=m+n-1;
    end
end
A
%将 A 矩阵进行水平和垂直翻转得到矩阵 B 和 C
B=rot90(A,2);
B
C=rot90(A);
C
%将 A 矩阵的前 10 行，10 列变成 0 并赋值给 D
A(1:10,1:10)=0;
D=A;
D
