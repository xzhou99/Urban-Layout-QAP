$title Improved QAP
OPTIONS mip= BDMLP,ITERLIM=100000, RESLIM = 1000000;
option optcr=0,optca=100;

sets
u vertex index in network reformulation / 101, 102, 201, 202, 301, 302, 401, 402, 500 /
*i residential buildings  /101, 102/
*j commercial buildings  /401, 402/
*k residentail locations  /201, 202/
*l commercial locations /301, 302/
*r virtual center /500/
a agent  /1*8/
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
alias (a,a_iter)
alias (u,u_iter,v,v_iter);

*parameter d(k,l)  the distance between location k and location l  /
*201. 301  2,    201. 302  3,
*202. 301  4,    202. 302  5
*/;

*parameter f(i,j) the flow between building i and building j  /
*101. 401  100,   101. 402  200,
*102. 401  300,   102. 402  400
*/;

parameter w(u,v,a) link exist for agent a  /
101.201.1  1,
101.201.2  1,
101.201.5  1,
101.202.1  1,
101.202.2  1,
101.202.5  1,
102.201.3  1,
102.201.4  1,
102.201.6  1,
102.202.3  1,
102.202.4  1,
102.202.6  1,
201.301.1  1,
201.301.2  1,
201.301.3  1,
201.301.4  1,
201.302.1  1,
201.302.2  1,
201.302.3  1,
201.302.4  1,
202.301.1  1,
202.301.2  1,
202.301.3  1,
202.301.4  1,
202.302.1  1,
202.302.2  1,
202.302.3  1,
202.302.4  1,
201.500.5  1,
201.500.6  1,
202.500.5  1,
202.500.6  1,
301.401.7  1,
301.402.8  1,
302.401.7  1,
302.402.8  1,
301.401.1  1,
301.401.3  1,
301.402.2  1,
301.402.4  1,
302.401.1  1,
302.401.3  1,
302.402.2  1,
302.402.4  1,
500.301.7  1,
500.301.8  1,
500.302.7  1,
500.302.8  1
/;

parameter alpha(u,v,a) capcacity consumption supply indicator on arcu v by agent a /
101.201.1  1,
101.201.2  1,
101.201.5  -2,
101.202.1  1,
101.202.2  1,
101.202.5  -2,
102.201.3  1,
102.201.4  1,
102.201.6  -2,
102.202.3  1,
102.202.4  1,
102.202.6  -2,
201.301.1  1,
201.301.2  1,
201.301.3  1,
201.301.4  1,
201.302.1  1,
201.302.2  1,
201.302.3  1,
201.302.4  1,
202.301.1  1,
202.301.2  1,
202.301.3  1,
202.301.4  1,
202.302.1  1,
202.302.2  1,
202.302.3  1,
202.302.4  1,
201.500.5  1,
201.500.6  1,
202.500.5  1,
202.500.6  1,
301.401.7  -2,
301.402.8  -2,
302.401.7  -2,
302.402.8  -2,
301.401.1  1,
301.401.3  1,
301.402.2  1,
301.402.4  1,
302.401.1  1,
302.401.3  1,
302.402.2  1,
302.402.4  1,
500.301.7  1,
500.301.8  1,
500.302.7  1,
500.302.8  1
/;

parameter gamma(u,v) capacity limit /
101.201 0,
101.202 0,
102.201 0,
102.202 0,
301.401 0,
301.402 0,
302.401 0,
302.402 0,
201.301 1,
201.302 1,
202.301 1,
202.302 1,
201.500 1,
202.500 1,
500.301 1,
500.302 1
/;

parameter h(u,v) link exsit  /
101.201 1,
101.202 1,
102.201 1,
102.202 1,
301.401 1,
301.402 1,
302.401 1,
302.402 1,
201.301 1,
201.302 1,
202.301 1,
202.302 1,
201.500 1,
202.500 1,
500.301 1,
500.302 1
/;


parameter c(u,v,a)  generalized cost per unit traffic flow between vertex u and v for agent a  /
101.201.1 0,
101.201.2 0,
101.201.5 0,
101.202.1 0,
101.202.2 0,
101.202.5 0,
102.201.3 0,
102.201.4 0,
102.201.6 0,
102.202.3 0,
102.202.4 0,
102.202.6 0,
201.500.5 0,
201.500.6 0,
202.500.5 0,
202.500.6 0,
500.301.7 0,
500.301.8 0,
500.302.7 0,
500.302.8 0,
301.401.1 0,
301.401.3 0,
301.401.7 0,
301.402.2 0,
301.402.4 0,
301.402.8 0,
201.301.1 200,
201.301.2 400,
201.301.3 600,
201.301.4 800,
201.302.1 300,
201.302.2 600,
201.302.3 900,
201.302.4 1200,
202.301.1 400,
202.301.2 800,
202.301.3 1200,
202.301.4 1600,
202.302.1 500,
202.302.2 1000,
202.302.3 1500,
202.302.4 2000
/;

parameter e(v,a) node for agent a /
101.1 1,
101.2 1,
101.5 1,
102.3 1,
102.4 1,
102.6 1,
500.5 1,
500.6 1,
500.7 1,
500.8 1,
401.1 1,
401.3 1,
401.7 1,
402.2 1,
402.4 1,
402.8 1,
201.1 1,
201.2 1,
201.3 1,
201.4 1,
201.5 1,
201.6 1,
202.1 1,
202.2 1,
202.3 1,
202.4 1,
202.5 1,
202.6 1,
301.1 1,
301.2 1,
301.3 1,
301.4 1,
301.7 1,
301.8 1,
302.1 1,
302.2 1,
302.3 1,
302.4 1,
302.7 1,
302.8 1
/;

parameter b(v,a) constraint 1 (flow balance):Network flow at node v of agent a /
101.1 1,
101.2 1,
101.5 1,
102.3 1,
102.4 1,
102.6 1,
500.5 -1,
500.6 -1,
500.7 1,
500.8 1,
401.1 -1,
401.3 -1
401.7 -1,
402.2 -1,
402.4 -1,
402.8 -1,
201.1 0,
201.2 0,
201.3 0,
201.4 0,
201.5 0,
201.6 0,
202.1 0,
202.2 0,
202.3 0,
202.4 0,
202.5 0,
202.6 0,
301.1 0,
301.2 0,
301.3 0,
301.4 0,
301.7 0,
301.8 0,
302.1 0,
302.2 0,
302.3 0,
302.4 0,
302.7 0,
302.8 0
/;

parameter current(a);
current(a)=0;
parameter Upper_bound;
Upper_bound=10000000;
parameter Lower_bound;
Lower_bound=-10000000;
parameter subgradient(u,v);
subgradient(u,v)=0;
*parameter stepsize;
*stepsize=0.5;
parameter rho;
rho=2000;
*parameter ylbest;
*ylbest=0;
parameter lamda(u,v);
*LR multiplier;
lamda(u,v)=0.1;
set k  subgradient iteration index / 1 *6 /;
parameter value(k)
/
1 1
/;
parameter gap;
gap=0;
parameter gapvalue(k)
/
1 0
/;


variables
y  obj total transportation costs
y_sub get each a's cost used when k=1
y_lb  lower bound
y_ub  upper bound
y_ub_sub each a's cost
;

binary variable
z(u,v,a)  whether or not agent a select arc uv
;



binary variable
z_sub(u,v,a)
;
binary variable
z_lb(u,v,a)
;
binary variable
z_up(u,v,a)
;

equations
cost     define objective function
flow(v,a) flow balance constraints
capacity(u,v) capacity demand-supply balance constrints

cost_sub subproblem of agent a  for k=1
sub_flow(v,a)

LB lower bound of the problem
LB_flow(v,a)

UB_sub_z(a)
UB_flow(v,a)
;

*standered model of improved QAP
*cost..    y =e= sum((a,u,v)$(w(u,v,a)=1), c(u,v,a)*z(u,v,a));
*cost only calculate the cost per unit flow c(u,v,a)
*flow(v,a)$(e(v,a)=1)..  sum(u$(w(v,u,a)=1),z(v,u,a))-sum(u$(w(u,v,a)=1),z(u,v,a))=e= b(v,a);
*capacity(u,v)$(h(u,v)=1)..   sum(a$(w(u,v,a)=1),alpha(u,v,a)*z(u,v,a)) =l= gamma(u,v);
*model  Improved_QAP/cost,flow,capacity/;
*solve Improved_QAP using MIP minizing y;
*display y.l, z.l;
*File Linear_QAP/Linear_QAP.dat/;
*put Linear_QAP;
*loop((u,v,a)$(w(u,v,a)),put @1, u.tl, @10, v.tl, @20, a.tl, @30, z.l(u,v,a)/);
*loop((u,v,a)$(z.l(u,v,a)),put @1, u.tl, @10, v.tl, @20, a.tl, @30, z.l(u,v,a)/);

*sub model (QAP) without considering the Capacity demand-supply balance constraints
cost_sub.. y_sub=e=sum((a,u,v)$(w(u,v,a)=1),z_sub(u,v,a)*c(u,v,a));
sub_flow(v,a)$(e(v,a)=1).. sum(u$(w(v,u,a)=1),z_sub(v,u,a))-sum(u$(w(u,v,a)=1),z_sub(u,v,a))=e=b(v,a)
model sub_Improved_QAP/cost_sub,sub_flow/;
solve sub_Improved_QAP using MIP minizing y_sub;
display z_sub.l;

*ADMM model of improved QAP
UB_sub_z(a)$(current(a)=1)..    y_ub_sub=e=sum((u,v)$(w(u,v,a)=1),z_up(u,v,a)*(c(u,v,a)+lamda(u,v)+rho*subgradient(u,v)-rho/2));
UB_flow(v,a)$(e(v,a)=1)..    sum(u$(w(v,u,a)=1),z_up(v,u,a))-sum(u$(w(u,v,a)=1),z_up(u,v,a))=e=b(v,a);
model ADMM_Improved_QAP/UB_sub_z,UB_flow/;

*Lower bound model of imporved QAP
LB.. y_lb=e=sum((a,u,v)$(w(u,v,a)=1),z_lb(u,v,a)*c(u,v,a))+sum((u,v)$(h(u,v)=1),lamda(u,v)*subgradient(u,v));
LB_flow(v,a)$(e(v,a)=1).. sum(u$(w(v,u,a)=1),z_lb(v,u,a))-sum(u$(w(u,v,a)=1),z_lb(u,v,a))=e=b(v,a);
model LowerBound_Improved_QAP/LB,LB_flow/;

Loop (k,
*if k=1, use z_sub.l to define subgradient(u,v)
         if(value(k)=1,
                 loop(a_iter,
                         loop(u_iter,
                         loop(v_iter,
                                 if(h(u_iter,v_iter)=1,
                                         subgradient(u,v)$(w(u_iter,v_iter,a_iter)=1)=max(0,(sum(a,alpha(u,v,a)*z_sub.l(u,v,a))-gamma(u,v)));
                                 );
                         );
                         );
                         current(a_iter)=1;
                         solve ADMM_Improved_QAP using MIP minimizing y_ub_sub;
                 );
                 current(a_iter)=0;
                 y_ub.l = sum((a,u,v)$(w(u,v,a)=1),c(u,v,a)*z_sub.l(u,v,a));
                 Upper_bound=min(Upper_bound,y_ub.l);
                 solve LowerBound_Improved_QAP using MIP minimizing y_lb;
                 Lower_bound=max(Lower_bound,y_lb.l);
                 lamda(u,v)$(h(u,v)=1) = max(0,lamda(u,v)+rho*subgradient(u,v));
                 gap=(Upper_bound-Lower_bound)/Upper_bound;
                 display Lower_bound;
                 display Upper_bound;
                 display gap;
         else
*if k£¡=1, use z_up.l to define subgradient(u,v)
                 loop(a_iter,
                         loop(u_iter,
                         loop(v_iter,
                                 if(h(u_iter,v_iter)=1,
                                         subgradient(u,v)$(w(u_iter,v_iter,a_iter)=1)=max(0,(sum(a,alpha(u,v,a)*z_up.l(u,v,a))-gamma(u,v)));
                                 );
                         );
                         );
                 current(a_iter)=1;
                 solve ADMM_Improved_QAP using MIP minimizing y_ub_sub;
                 current(a_iter)=0;
                 );
                 y_ub.l = sum((a,u,v)$(w(u,v,a)=1),c(u,v,a)*z_sub.l(u,v,a));
                 Upper_bound=min(Upper_bound,y_ub.l);
                 solve LowerBound_Improved_QAP using MIP minimizing y_lb;
                 Lower_bound=max(Lower_bound,y_lb.l);
                 lamda(u,v)$(h(u,v)=1) = max(0,lamda(u,v)+rho*subgradient(u,v));
                 gap=(Upper_bound-Lower_bound)/Upper_bound;
                 display lamda;
                 display Lower_bound;
                 display Upper_bound;
                 display gap;
                 display z_lb.l;
                 display z_up.l;
         );
);

File QAP_ADMM/QAP_ADMM.dat/;
put QAP_ADMM;
loop((u,v,a)$(z_up.l(u,v,a)=1),put @1, u.tl, @10, v.tl, @20, a.tl, @30, z_up.l(u,v,a)/);

