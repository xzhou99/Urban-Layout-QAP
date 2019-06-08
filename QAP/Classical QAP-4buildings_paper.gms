$title Quadratic Assignment Problem
*by Jialu Fu, Lu (Carol) Tong, Xuesong Zhou
*OPTIONS mip = CPLEX;
*option optcr=0,optca=0.99;

sets
i home buildings  /101,102/
j office buildings /401,402/
k home locations  /201,202/
l office locations /301,302/
;

parameter f(i,j)  the folw between home building i and office building j /
101. 401  1,
101. 402  2,
102. 401  3,
102. 402  4
/;

parameter d(k,l)  the distance between location k and location l  /
201. 301  2,
201. 302  3,
202. 301  4,
202. 302  5
/;

variables
x(i,k)  whether or not home building i is assigned home locaiton k
y(j,l)  whether or not office building j is assigned office location l
z       total transportation costs ;

binary variable  x(i,k);
binary variable  y(j,l);

equations
cost     define objective function
assign1(i) building i occupy only one location
assign2(k) location k house only one building
assign3(j) building j occupy only one location
assign4(l) location l house only one building
;

cost..        z =e= sum((i,j,k,l),f(i,j)*d(k,l)*x(i,k)*y(j,l));
assign1(i)..  sum(k,x(i,k)) =e= 1 ;
assign2(k)..  sum(i,x(i,k)) =e= 1 ;
assign3(j)..  sum(l,y(j,l)) =e= 1 ;
assign4(l)..  sum(j,y(j,l)) =e= 1 ;

model quadratic_assignment_Problem /all/ ;
solve quadratic_assignment_Problem using MIQCP minizing z ;
display x.l,y.l,z.l;

File QAP_P/QAP_P.dat/;
put QAP_P;
loop((i,k)$(x.l(i,k)),put @1, i.tl, @10, k.tl, x.l(i,k)/);
loop((j,l)$(y.l(j,l)),put @1, j.tl, @10, l.tl, y.l(j,l)/);
