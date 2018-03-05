# Distributed execution simulator

Era o zi friguroasa de iarna. Zapada ajungea pana la genunchii copiilor care, desi inghetasera, continuau sa se bata cu bulgari. In acea lupta incrancenata, unul dintre bulgari a lovit turturii de pe casa ta, care s-au desprins si au cazut, facand un zgomot puternic. Pisica ta, Bit, ce statea pe pervaz si admira zapada, s-a speriat si, printr-o saritura ampla, a ajuns sa darame statueta de pe masa, mostenita de la bunicul tau. Printre cioburile statuetei, gasesti cateva foi ce par sa contina cod, intr-un limbaj necunoscut tie. Una dintre pagini iti da, totusi, explicatiile de care ai nevoie legat de instructiunile limbajului. 

```
set X Y - seteaza valoarea Y in registrul X
add X Y - creste valoarea din X cu Y
mul X Y - seteaza valoarea registrului X ca fiind rezultatul multiplicarii lui X cu Y
mod X Y - valoarea din X devine valoarea precedenta modulo Y (X <- X modulo Y)
jgz X Y - in cazul in care valoarea lui X este mai mare decat 0, se va sari in cadrul programului
  cu Y instructiuni(spre exemplu, daca Y este 2, se va sari peste urmatoarea instructiune; 
  daca Y este -1, se va sari la instructiunea precedenta)
snd X - trimite valoarea lui X celuilalt procesor
rcv X - primeste o valoare de la alt procesor, pe care o salveaza in registrul X
```
**Nota**: Y poate sa fie atat valoare numerica (cu sau fara semn), cat si registru.

### Exemplu:
```
set R3 1
set R4 2
mul R3 R4
jgz R3 -1
```
In R3 se salveaza valoarea 1 si in R4 se salveaza valoarea 2. Programul salveaza in R3 valoarea multiplicarii lui R3 cu R4, adica 2. Intrucat R3 este mai mare decat 0, programul sare cu o instructiune inapoi si executa multiplicarea din nou. In R3 va fi salvata valoarea 4 (R3 * R4 = 2 * 2 = 4); R3 este din nou mai mare decat 0, programul sare la instructiunea precedenta si salveaza in R3 valoarea 8. Astfel, R3 va lua in continuare, pe rand, valorile 8, 16, 32, 64, 128, …, 2 ^ 30.  
2 ^ 30 este in continuare o valoare mai mare decat 0, deci programul va sari la instructiunea precedenta. Intrucat registrii sunt pe 32 de biti si memoreaza valori cu semn (in intervalul [- 2 ^ 31, 2 ^ 31 - 1]), in urma multiplicarii cu 2 a lui 2 ^ 30 se va face overflow si valoarea din R3 va fi -2147483648 (- 2 ^ 31). Aceasta nu mai este mai mare decat 0 asa ca jump-ul nu se va mai executa si programul isi va incheia executia, intrucat nu mai are alte instructiuni.

Continui sa citesti si descoperi ca fiecare program trebuie executat pe 2 procesoare care comunica intre ele prin instructiunile SND si RCV. In momentul in care un procesor executa RCV, acesta primeste valoarea trimisa printr-un SND anterior de catre celalalt procesor, sau asteapta pana cand i se trimite ceva.

### Exemplu:
```
snd 5
snd R0
rcv R13
rcv R14
rcv R2
```
Ambele procesoare ruleaza acelasi cod si incep prin a trimite valoarea 5, urmata de valoarea din registrul R0. Registrele pot fi privite ca niste variabile ce sunt setate initial pe 0, cu exceptia registrului R0, care este special. Valoarea din el este setata cu indicele procesorului pe care ruleaza (pentru primul procesor, va avea valoarea 0, in timp ce pentru al doilea, va avea valoarea 1). Astfel, procesoarele trimit valorile 0, respectiv 1. 
Ambele procesoare executa RCV, salvand in registrul R13 valoarea 5. Primul procesor va salva in registrul R14 valoarea 1, iar cel de-al doilea va salva in R14 valoarea 0. Intrucat procesoarele incearca sa execute amandoua RCV, dar nu isi mai pot trimite date, ele raman blocate in aceasta stare fara posibilitatea de a mai iesi. Fenomenul poarta denumirea de deadlock si, in cazul specific al procesoarelor noastre, face ca programele sa isi incheie executia.

Programele isi pot incheia executia in doua moduri:  
a. in momentul in care nu mai exista o instructiune urmatoare  
b. prin deadlock

In cazul in care un procesor isi incheie executia programului, dar celalalt procesor are, in continuare, instructiuni de executat, al doilea procesor va continua sa le execute pana cand ajunge sa fie blocat intr-un RCV din care nu mai poate sa primeasca date sau pana cand isi termina si el instructiunile.

Procesoarele folosesc 32 de registri pe 32 de biti in care stocheaza valori cu semn, denumiti R0, R1, …, R31. Conform instructiunilor bunicului tau, registrii R1, R2, …, R31 sunt initializati intotdeauna cu 0, in timp ce registrul R0 este initializat cu indicele procesorului pe care ruleaza.

Bunicul tau te roaga sa simulezi, scriind un program intr-un limbaj ales de tine, executia pe 2 procesoare a codului pe care il gasesti pe foi si sa recompui un cifru ce va fi format din valorile nenule ce se regasesc in registri la incheierea executiei programelor.

## Input
Fisierul code.in va contine pe prima linie un numar N ce reprezinta numarul de procesoare pe care se va executa codul (2 in versiunea fara bonus a problemei), urmand ca pe liniile urmatoare sa gasiti codul pe care trebuie sa il executati, cate o instructiune pe linie.

## Output
In fisierul code.out se va afisa un sir de numere ce reprezinta valorile nenule din registrii procesoarelor. Pe fiecare rand se vor gasi valorile din fiecare procesor. Valorile nenule vor fi in ordine, afisandu-se mai intai registrii primului procesor, apoi registrii celui de-al doilea, in ordine crescatoare (R0, R1, …, R31). **Se vor afisa doar valorile nenule**.  
**Exemplu**:
Daca procesorul 0 are R1 = 3 si R7 = 9, iar procesorul 1 are R0 = 1, R6 = 3 si R9 = 14, outputul va fi:
```
3 9
1 3 14
```

## Bonus
Codul poate fi executat pe oricate procesoare. Prima linie din input va contine numarul de procesoare pe care trebuie sa simulati executia codului.
Registrul R0 din fiecare procesor va fi initializat cu indicele procesorului (0 pentru primul procesor, 1 pentru al doilea etc.). Instructiunile de SND si RCV se vor realiza astfel:
fiecare procesor trimite la procesorul urmator, mai putin ultimul, care trimite catre procesorul 0 (**ex**. 0 -> 1, 1 -> 2, 2 -> 3, … , (N - 1) -> 0)  
**Nota**: rezultatele obtinute in urma implementarii bonusului nu trebuie sa difere de rezultatele obtinute pe cazul in care exista doar doua procesoare.

Intrucat codul vostru va fi rulat atat pe testele normale, cat si pe testele bonus, sunteti rugati ca, in cazul in care nu implementati bonusul, sa nu-i dati sansa codului vostru sa intre in bucla infinita/ sa ia seg fault/ bus error/ whatever si sa introduceti o conditie de genul:
```c
if (N != 2) {
  exit(0);
}
``` 

## Trimiterea solutiei
Solutia va fi trimisa sub forma unei arhive .zip. Aceasta trebuie sa contina:  
* fisierele sursa (organizate in functie de implementare)
* un fisier MAKEFILE, plasat in radacina arhivei, cu regulile: build, clean, run  
**Nota**: Fisierul code.in va fi citit din radacina arhivei. Executabilul si fisierul code.out vor fi generate tot in radacina arhivei.  In cazul testarii locale, rezultatul testelor se va gasi in directorul ```output```.

## Troubleshooting
Pentru intrebari sau explicatii suplimentare, se va deschide un nou ```issue``` in repository-ul de Github al problemei.
