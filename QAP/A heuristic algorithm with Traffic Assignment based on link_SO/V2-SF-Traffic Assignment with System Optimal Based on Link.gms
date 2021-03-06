$title Traffic Assignment with System Optimal Based on Link
*by Jialu Fu, Lu (Carol) Tong, Xuesong Zhou
*OPTIONS  ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, NLP = MINOS5, LIMROW = 0, LIMCOL = 0 ;
*option optcr=0,optca=0.99;

set i node /101, 102, 103, 104, 105, 1*24, 401, 402, 403, 404, 405/;

alias (i,j);
alias (i,k);

parameter current(i);
current(i)=0;

parameter flag(k)/
101  101
102  102
103  103
104  104
105  105
401  401
402  402
403  403
404  404
405  405
/;

parameter demand(i) /
101  3000
102  2000
103  1000
104  750
105  500
401  2500
402  2500
403  1500
404  500
405  250
/;

parameter origin_node(i) /
101  1
102  1
103  1
104  1
105  1
/;

parameter destination_node(i) /
401  1
402  1
403  1
404  1
405  1
/;

parameter fft(i,j);
parameter capacity(i,j);

$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\GAMS-Traffic Assignment with System Optimal\SF\V2-parameter-fft.txt"
$include "G:\FJL Paper\FJL-Urban Layout\Urban layout--QAP\GAMS-Traffic Assignment with System Optimal\SF\V2-parameter-capacity.txt"

parameter intermediate_node(i);
intermediate_node(i)=(1-origin_node(i))*(1-destination_node(i));

positive variable x(i,j) traffic flow between node i and node j;
positive variable t(i,j) travel time between node i and node j;
variable z  total cost;

equations
cost
flow_on_node_origin(i)
flow_on_node_intermediate(i)
flow_on_node_destination(i)
calculate_travel_time(i,j)
;

cost..  z=e=sum((i,j),x(i,j)*t(i,j));
flow_on_node_origin(i)$(origin_node(i)).. sum((j)$(capacity(i,j)>0.1), x(i,j)) =e= demand(i);
flow_on_node_destination(i)$(destination_node(i))..  sum((j)$(capacity(j,i)>0.1), x(j,i))=e= demand(i);
flow_on_node_intermediate(i)$(intermediate_node(i)).. sum((j)$(capacity(i,j)>0.1), x(i,j))-sum((j)$(capacity(j,i)>0.1),x(j,i))=e= 0;
calculate_travel_time(i,j)$(capacity(i,j)>0)..   fft(i,j)*(1+0.15*(x(i,j)/capacity(i,j))**4)=e=t(i,j);

model traffic_assignment_with_system_optimal_based_on_link /all/;
solve traffic_assignment_with_system_optimal_based_on_link using NLP minimizing z;
display x.l, t.l, z.l;

File TA_SO_SF_V2/TA_SO_SF_V2.dat/;
Put TA_SO_SF_V2;

loop((i,j)$(x.l(i,j)), put @1, i.tl, @6, j.tl, @11, x.l(i,j)/);
loop((i,j)$(t.l(i,j)), put @1, i.tl, @6, j.tl, @11, t.l(i,j)/);
put @1, z.l;

File TA_SO_SF_2/TA_SO_SF_2.dat/;
Put TA_SO_SF_2;
loop(k$(origin_node(k)),
    if (flag(k)=101,
        solve traffic_assignment_with_system_optimal_based_on_link using NLP minimizing z;
        current(k)= max(x.l(k,'1'),x.l(k,'3'),x.l(k,'12'),x.l(k,'13'),x.l(k,'24'));
        loop(j,
           if (x.l(k,j)<current(k),
               fft(k,j)=10000);
             ) ;
          loop((i)$(current(i)), put @1, i.tl,@11, current(i)/);
          loop((i,j)$(x.l(i,j)), put @1, i.tl, @6, j.tl, @11, x.l(i,j)/);
          loop((i,j)$(t.l(i,j)), put @1, i.tl, @6, j.tl, @11, t.l(i,j)/);
          put @1, z.l;

     else
         loop(j,
              if (x.l(k-1,j)=current(k-1),
                  loop(i$(origin_node(k) and flag(i)>=flag(k)),
                       fft(i,j)=10000);)
              );
         solve traffic_assignment_with_system_optimal_based_on_link using NLP minimizing z;
         current(k)= max(x.l(k,'1'),x.l(k,'3'),x.l(k,'12'),x.l(k,'13'),x.l(k,'24'));
         loop(j,
           if (x.l(k,j)<current(k),
               fft(k,j)=10000);
             ) ;
         loop((i)$(current(i)), put @1, i.tl,@11, current(i)/);
         loop((i,j)$(x.l(i,j)), put @1, i.tl, @6, j.tl, @11, x.l(i,j)/);
         loop((i,j)$(t.l(i,j)), put @1, i.tl, @6, j.tl, @11, t.l(i,j)/);
         put @1, z.l;
);

)

loop(k$(destination_node(k)),
    if (flag(k)=401,
        solve traffic_assignment_with_system_optimal_based_on_link using NLP minimizing z;
        current(k)= max(x.l('6',k),x.l('7',k),x.l('18',k),x.l('19',k),x.l('20',k));
        loop(i,
           if (x.l(i,k)<current(k),
               fft(i,k)=10000);
             ) ;
          loop((i)$(current(i)), put @1, i.tl,@11, current(i)/);
          loop((i,j)$(x.l(i,j)), put @1, i.tl, @6, j.tl, @11, x.l(i,j)/);
          loop((i,j)$(t.l(i,j)), put @1, i.tl, @6, j.tl, @11, t.l(i,j)/);
          put @1, z.l;

     else
         loop(j,
              if (x.l(j,k-1)=current(k-1),
                  loop(i$(destination_node(k) and flag(i)>=flag(k)),
                      fft(j,i)=10000);)
              );
     solve traffic_assignment_with_system_optimal_based_on_link using NLP minimizing z;
          current(k)= max(x.l('6',k),x.l('7',k),x.l('18',k),x.l('19',k),x.l('20',k));
         loop(j,
           if (x.l(j,k)<current(k),
               fft(j,k)=10000);
             ) ;
         loop((i)$(current(i)), put @1, i.tl,@11, current(i)/);
         loop((i,j)$(x.l(i,j)), put @1, i.tl, @6, j.tl, @11, x.l(i,j)/);
         loop((i,j)$(t.l(i,j)), put @1, i.tl, @6, j.tl, @11, t.l(i,j)/);
          put @1, z.l;
);

)

