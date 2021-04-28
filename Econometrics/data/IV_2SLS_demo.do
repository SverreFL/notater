***IV/2SLS-demo***
use "\\tjalve.uib.no\home\seceb\dok\Undervisning\econ340\h_15\CARD.DTA",clear

*OLS
reg lwage educ exper expersq black smsa,robust
est store ols

*2SLS - 1 instrument
ivregress 2sls lwage (educ=nearc4) exper expersq black smsa,first robust
est store twosls1

*2SLS - 2 instrumenter
ivregress 2sls lwage (educ=nearc4 libcrd14) exper expersq black smsa,first robust
est store twosls2

*Sammenligning
est table ols twosls1 twosls2, se b(%5.3f) stats(N)
est table ols twosls1 twosls2, se b(%5.3f) stats(N) keep(educ)

**Tester etter ivregress**

*Tester for steg 1
quietly ivregress 2sls lwage (educ=nearc4) exper expersq black smsa,robust
estat first

quietly ivregress 2sls lwage (educ=nearc4 libcrd14) exper expersq black smsa,robust
estat first

*Test for endogenitet (Hausman)
estat endogenous
*Tolking her: Testen forkaster H0: OLS er konsistent

*Test for overidentifiserende restriksjoner
estat overid
*Tolking her: Testen fokaster IKKE H0: en av eksklusjonsrestriksjonene holder

*Ekstra 1: sjekk at ILS gir IV (funker bare med ett instrument)
*Redusert form:
reg lwage nearc4 exper expersq black smsa
scalar b_red = _b[nearc4] //tar vare på koeffisienten på instrumentet 
*Steg 1
reg educ nearc4 exper expersq black smsa

*redusert form/steg 1 skal gi IV-estimat for educ:
display b_red/_b[nearc4] 
*Sjekk mot resultater over viser at det stemmer

*Ekstra 2: "Manuell" 2SLS
*Steg 1 (2 instrumenter)
quietly reg educ nearc4 libcrd14 exper expersq black smsa
quietly predict educhat

*Steg 2
reg lwage educhat exper expersq black smsa

*Koeffisienter stemmer med resultater over, men standardfeilene blir gale


