$title Improved QAP
*OPTIONS mip= BDMLP,ITERLIM=100000, RESLIM = 1000000;
*option optcr=0,optca=100;

sets
u vertex index in network reformulation / 101, 102, 201, 202, 301, 302, 401, 402, 500 /
*i residential buildings  /101, 102/
*j commercial buildings  /401, 402/
*k residentail locations  /201, 202/
*l commercial locations /301, 302/
*r virtual center /500/
a agent  /1*9/
*s agent types / 1, 2, 3 /
*type_1(a) transportation /1, 2, 3, 4/
*type_2(a) home builder /5, 6/
*type_3(a) office builder /7, 8/
*building_type(s,a)/
*1.1
*1.2
*1.3
*1.4
*2.5
*2.6
*3.7
*3.8
*/
;
alias (u,v);

*parameter d(k,l)  the distance between location k and location l  /
*201. 301  2,    201. 302  3,
*202. 301  4,    202. 302  5
*/;

*parameter f(i,j) the flow between building i and building j  /
*101. 401  100,   101. 402  200,
*102. 401  300,   102. 402  400
*/;

parameter w(u,v,a) /
101.201.1  1,
101.201.2  1,
101.201.6  1,
101.202.1  1,
101.202.2  1,
101.202.6  1,
102.201.3  1,
102.201.4  1,
102.201.5  1,
102.201.7  1,
102.202.3  1,
102.202.4  1,
102.202.5  1,
102.202.7  1,
201.301.1  1,
201.301.2  1,
201.301.3  1,
201.301.4  1,
201.301.5  1,
201.302.1  1,
201.302.2  1,
201.302.3  1,
201.302.4  1,
201.302.5  1,
202.301.1  1,
202.301.2  1,
202.301.3  1,
202.301.4  1,
202.301.5  1,
202.302.1  1,
202.302.2  1,
202.302.3  1,
202.302.4  1,
202.302.5  1,
201.500.6  1,
201.500.7  1,
202.500.6  1,
202.500.7  1,
301.401.8  1,
301.402.9  1,
302.401.8  1,
302.402.9  1,
301.401.1  1,
301.401.3  1,
301.401.4  1,
301.402.2  1,
301.402.5  1,
302.401.1  1,
302.401.3  1,
302.401.4  1,
302.402.2  1,
302.402.5  1,
500.301.8  1,
500.301.9  1,
500.302.8  1,
500.302.9  1
/;

parameter alpha(u,v,a) capcacity consumption supply indicator on arcuv by agent a  /
101.201.1  1,
101.201.2  1,
101.201.6  -2,
101.202.1  1,
101.202.2  1,
101.202.6  -2,
102.201.3  1,
102.201.4  1,
102.201.5  1,
102.201.7  -3,
102.202.3  1,
102.202.4  1,
102.202.5  1,
102.202.7  -3,
201.301.1  1,
201.301.2  1,
201.301.3  1,
201.301.4  1,
201.301.5  1,
201.302.1  1,
201.302.2  1,
201.302.3  1,
201.302.4  1,
201.302.5  1,
202.301.1  1,
202.301.2  1,
202.301.3  1,
202.301.4  1,
202.301.5  1,
202.302.1  1,
202.302.2  1,
202.302.3  1,
202.302.4  1,
202.302.5  1,
201.500.6  1,
201.500.7  1,
202.500.6  1,
202.500.7  1,
301.401.8  -3,
301.402.9  -2,
302.401.8  -3,
302.402.9  -2,
301.401.1  1,
301.401.3  1,
301.401.4  1,
301.402.2  1,
301.402.5  1,
302.401.1  1,
302.401.3  1,
302.401.4  1,
302.402.2  1,
302.402.5  1,
500.301.8  1,
500.301.9  1,
500.302.8  1,
500.302.9  1
/;


parameter h(u,v) /
101.201  1,
101.202  1,
102.201  1,
102.202  1,
201.301  1,
201.302  1,
202.301  1,
202.302  1,
201.500  1,
202.500  1,
301.401  1,
301.402  1,
302.401  1,
302.402  1,
500.301  1,
500.302  1
/;


parameter gamma(u,v)  /
201.301 2,
201.302 2,
202.301 2,
202.302 2,
201.500 1,
202.500 1,
500.301 1,
500.302 1
/;



parameter c(u,v,a)  generalized cost per unit traffic flow between vertex u and v for agent a  /
201.301.1 6,
201.301.2 6,
201.301.3 6,
201.301.4 6,
201.301.5 6,
201.302.1 7,
201.302.2 7,
201.302.3 7,
201.302.4 7,
201.302.5 7,
202.301.1 7,
202.301.2 7,
202.301.3 7,
202.301.4 7,
202.301.5 7,
202.302.1 5,
202.302.2 5,
202.302.3 5,
202.302.4 5
202.302.5 5
/;


parameter b(v,a) Network flow at node v of agent a  /
101.1 1,
101.2 1,
101.6 1,
102.3 1,
102.4 1,
102.5 1,
102.7 1,
500.6 -1,
500.7 -1,
500.8 1,
500.9 1,
401.1 -1,
401.3 -1,
401.4 -1,
401.8 -1,
402.2 -1,
402.5 -1,
402.9 -1
/;

parameter value_u(u)/
101    1
102    2
201    3
202    4
301    5
302    6
401    7
402    8
500    9
/;

parameter pie(u,v);
pie(u,v) = 0.0;

variables
z  total transportation costs
z_spp total cost after relaxing capacity constraints;

binary variable
y(u,v,a)  whether or not agent a delect arc uv ;

equations
obj     define objective function
obj_spp  define objective function after relaxing
flow(v,a) flow balance constraints
capacity(u,v) capacity demand-supply balance constrints
;

obj..    z =e= sum((a,u,v), c(u,v,a)*y(u,v,a));
obj_spp..   z_spp =e= sum((a,u,v), c(u,v,a)*y(u,v,a))+ sum((u,v)$(h(u,v)=1),pie(u,v)*sum(a$(w(u,v,a)=1),alpha(u,v,a)*y(u,v,a))- gamma(u,v));
flow(v,a)..  sum(u$(w(v,u,a)=1),y(v,u,a))-sum(u$(w(u,v,a)=1),y(u,v,a))=e= b(v,a);
capacity(u,v)..   sum(a$(w(u,v,a)=1),alpha(u,v,a)*y(u,v,a)) =l= gamma(u,v);

model  Improved_QAP /all/ ;
model  Reformulation_QAP /obj_spp, flow/ ;


*------------------------------------------------------------------------------------
$ontext
solve Improved_QAP using minlp minizing y;
display y.l, z.l;

File Linear_QAP/Linear_QAP.dat/;
put Linear_QAP;
loop((u,v,a)$(z.l(u,v,a)),put @1, u.tl, @10, v.tl, @20, a.tl, @30, z.l(u,v,a)/);
$offtext
*------------------------------------------------------------------------------------


parameter z_y;
parameter subgradient_pie(u,v);
parameter z_lb;
parameter step;
step = 1;
parameter u_value;
u_value = 1;
parameter zlbest;
zlbest=0;
parameter n;
n=0;

File output_y; put output_y;

sets iter  subgradient iteration index / iter1 * iter30 /;

File output_obj_lb/result_LRC.txt/;
put output_obj_lb;

Loop (iter,

         solve Reformulation_QAP using MIP minimizing z_spp;

         subgradient_pie(u,v)=sum(a$(w(u,v,a)=1),alpha(u,v,a)*y.l(u,v,a))-gamma(u,v);

         pie(u,v)=max(0,pie(u,v)+step*subgradient_pie(u,v));

         u_value = u_value +1;
         step = 1/u_value;

         z_lb = z_spp.l;
         zlbest = max(zlbest,z_lb);
         n = u_value-1;

         z_y = sum((a,u,v), c(u,v,a)*y.l(u,v,a));


         display z_y;
         display y.l;

         display subgradient_pie;
         display y.l;
         display pie;

       put @3,n,@5,z_y,@30,z_spp.l,@45,z_lb,@60,zlbest /
);


         put /@1, 'n', @5, 'u', @10, 'v', @20, 'a'/
         loop((u,v,a)$((y.l(u,v,a) gt 0)),put @1, n, @5, u.tl, @10, v.tl, @20, a.tl/);

display y.l;
display y.l;


