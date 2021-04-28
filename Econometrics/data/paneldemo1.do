*************Paneldemo1*************
*************Oppsett*************

use  O:\dok\Undervisning\econ341\v_16\wagepan.dta,clear
*sett inn din sti til filen eller last den inn interktivt
xtset nr year
*For å kunne bruke panelkommandoer (nr identifiserer individ, year tidsperiode)

*******************
**Se på data**
*******************

*Få oversikt over data
xtdescribe

browse

*Se på variasjon (tot, within, between) for noen variabler
xtsum logwage educ exper union black hisp married


***Grafikk***
*xtline lager graf av en variabel mot tid.
xtline logwage,overlay legend(off) //opsjon overlay for å få alt i samme figur
xtline logwage if nr < 200,overlay legend(off) //plott for en del av utvalget

*Skal så lage plott av logwage mot exper
*Først for "rå" data, dvs vi bruker all variasjon
*Vi legger også inn en kvadratisk regresjonslinje 

twoway (scatter logwage exper) (qfit logwage exper),ti(Rådata - alle observasjoner)

*Nå skal vi dekomponere data med between- og withintransformasjoner
*Dette endrer data, og vi må bruke kommando preserve for å kunne å beholde det opprinnelige data settet

preserve
xtdata,be //data blir between-transformert til individgjennomsnitt (jfr forelesning)
describe,short
twoway (scatter logwage exper) (qfit logwage exper),ti(Between-transformerte data)

restore

preserve
xtdata,fe //data blir within-transformert (jfr forelesning)
describe,short
twoway (scatter logwage exper) (qfit logwage exper),ti(Within-transformerte data)

restore //laster inn data slik de var før transformasjonen


*Lag og differenser
*Vi kan bruke operatorer for lag og differenser direkte i en kommando eller vi kan lage nye variabler.
sort nr year

*Lag: x(t-1)
gen lag_logwage = l.logwage
*Differanse: x(t) - x(t-1)
gen d_logwage = d.logwage
*Lead: x(t+1)
gen lead_logwage = f.logwage

browse nr year logwage lag_logwage d_logwage lead_logwage
*Det går altså også an å bruke operatorene i direkte i en kommando uten å lage egne variabler som her.

