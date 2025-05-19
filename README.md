# LenkaStejskalova_Projekt_SQL_2025_02_17
---

## Úvod do projektu
Cílem je připravit datové podklady pro porovnání dostupnosti základních potravin na základě průměrných příjmů v ČR za určité časové období.
Podklady mají sloužit analytickému oddělení nezávislé společnosti, která se zabývá životní úrovní občanů.
Dodatečné podklady obsahují tabulku s údaji o HDP, GINI koeficientem a populací dalších evropských států za stejné období, 
jako primární přehled pro ČR.

Z dostupných údajů o cenách, mzdách a HDP jsou k dispozici kompletní data za roky 2006 - 2018. 
Toto časové období tedy bylo zvoleno pro účely tohoto výzkumu pro sledování vývoje cen, mezd, HDP a dalších statistických údajů 
v ČR a dalších evropských státech.

Výsledky výzukumu plynou z tabulek t_lenka_stejskalova_project_SQL_primary_final, t_lenka_stejskalova_project_SQL_secondary_final
a sady SQL dotazů, které jsou obsažené v přiloženém souboru.


## Výzkumné otázky a výsledná zjištění

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Data uvádějí, že na základě rozdílu mezi prvním (2006) a posledním (2018) rokem sledovaného období ve všech odvětvích mzdy rostou.


### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Data říkají, že za první srovnatelné období, tj. rok 2006 je možné si koupit 1173 kg chleba a 1309 l mléka.
Za poslední srovnatelné období, tj. rok 2018 je možné si koupit 1279 kg chleba a 1564 l mléka.


### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Data uvádějí, že za poslední srovnatelné období, tj. rok 2018 zdražuje meziročně nejpomaleji cukr krystalový (kód kategorie 118101).
U této kategorie dokonce průměrná cena oproti předchozímu roku klesla o 21 %.
Z datových podkladů byla vyloučena kategorie 212101 (jakostní víno bílé), protože data jsou k dispozici až od roku 2015, 
statistika by tedy mohla být zkreslená.


### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Podle dostupných dat ve sledovaném období 2006 - 2018 nebyl žádný rok, ve kterém by byl meziroční nárůst cen potravin o 10 % nebo vyšší
oproti meziročnímu růstu mezd.


### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách 
potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Podle dostupných dat ve sledovaném období 2006 - 2018 byl meziroční výraznější růst HDP, tj. 5 % a více v letech 2007, 2015 a 2017.
V roce 2007 rostly meziročně výrazněji mzdy i ceny v daném roce i následujícím.
V roce 2015 rostly meziročně mzdy, ale ceny klesly v daném roce i v roce následujícím.
V roce 2017 rostly meziročně výrazněji mzdy i ceny v daném roce, v následujícím roce mzdy rostly výrazněji (o 8 %), 
ale ceny rostly jen o 2 %.
Dostupná data tedy nepotvrzují, že by bylo pravidlem, že výrazný růst HDP v jednom roce bude mít vliv na růst mezd nebo cen v daném roce
nebo v roce následujícím.









