$title Improved QAP
*OPTIONS mip= BDMLP,ITERLIM=100000, RESLIM = 1000000;
*option optcr=0,optca=100;

sets
u vertex index in network reformulation / 101, 102, 103, 201, 202, 203, 601*715, 301, 302, 303, 401, 402, 403, 500 /
*i residential buildings  /101, 102, 103/
*j commercial buildings  /401, 402, 403/
*k residentail locations  /77, 89, 1006/
*l commercial locations /24, 34, 68/
*r virtual center /500/
a agent  /1*36/
*s agent types / 1, 2, 3 /
*type_1(a) transportation /1*30/
*type_2(a) home builder /31*33/
*type_3(a) office builder /34*36/
*agent_type(s,a)/
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

parameter w(u,v,a) ;
parameter alpha(u,v,a) capcacity consumption supply indicator on arcuv by agent a ;
parameter gamma(u,v) ;
parameter c(u,v)  generalized cost per unit traffic flow between vertex u and v for agent a ;
parameter b(v,a) Network flow at node v of agent a ;

$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\Branch and bound\West_Jordan\GAMS_Branch_and_Bound\parameter_w.txt"
$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\Branch and bound\West_Jordan\GAMS_Branch_and_Bound\parameter_alpha.txt"
$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\Branch and bound\West_Jordan\GAMS_Branch_and_Bound\parameter_gamma.txt"
$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\Branch and bound\West_Jordan\GAMS_Branch_and_Bound\parameter_c.txt"
$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\Branch and bound\West_Jordan\GAMS_Branch_and_Bound\parameter_b.txt"

variables
z  total transportation costs ;

binary variable
x(u,v,a)  whether or not agent a delect arc uv ;

equations
cost     define objective function
flow(v,a) flow balance constraints
capacity(u,v) capacity demand-supply balance constrints
;

cost..    z =e= sum((a,u,v)$(w(u,v,a)=1), c(u,v)*x(u,v,a));
flow(v,a)..  sum((u)$(w(v,u,a)=1),x(v,u,a))-sum((u)$(w(u,v,a)=1),x(u,v,a))=e= b(v,a);
capacity(u,v)..   sum(a$(w(u,v,a)=1),alpha(u,v,a)*x(u,v,a)) =l= gamma(u,v);

model  Improved_QAP /all/ ;

solve Improved_QAP using minlp minizing z;
display x.l, z.l;

File Linear_west_jordan/Linear_west_jordan.dat/;
put Linear_west_jordan;
loop((u,v,a)$(x.l(u,v,a)),put @1, u.tl, @10, v.tl, @20, a.tl, @30, x.l(u,v,a)/);


