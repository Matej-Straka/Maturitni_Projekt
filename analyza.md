# Název práce
##### Mobilní aplikace pro prezentaci produktů pomocí QR kódů  

## Autor
Matěj Straka  

## Cíl práce
Cílem maturitní práce je navrhnout, naprogramovat a otestovat mobilní aplikaci, která bude sloužit k prezentaci směsí kávy prostřednictvím QR kódů. Po načtení QR kódu pomocí kamery mobilního zařízení se přehraje příslušné video, které bude propojeno s konkrétní směsí kávy. Po skončení videa se v aplikaci zobrazí dvě tlačítka: **Složení**, které uživateli ukáže detailní složení směsi, a **Více informací**, kde se objeví rozšířený textový popis produktu.  

Součástí práce je také vytvoření administračního rozhraní pro správu obsahu. V administraci bude možné přiřazovat k jednotlivým QR kódům videa, texty se složením a popisy produktů. Dále zde bude správa uživatelských účtů s možností přidávání, mazání a úprav přístupových práv.  

Aplikace bude vyvíjena v jazyce **Dart** pomocí multiplatformního frameworku **Flutter**, aby bylo možné ji spustit jak na systému Android, tak na iOS. Pro správu obsahu a uživatelů bude vytvořen backend, navržen databázový model a použit vhodný databázový systém (například **MySQL**). Jako volitelné rozšíření se počítá s možností rozpoznávání obalu kávy místo QR kódu, případně s implementací prvků rozšířené reality, kdy se video promítne přímo na obal produktu.  

## Cílová skupina
Primárními uživateli aplikace budou zákazníci nakupující kávu. Těm aplikace nabídne nejen přehrání videa, ale také rozšířené informace o produktu, jeho složení a původu. Aplikace je určena běžným spotřebitelům, proto musí být jednoduchá na ovládání a dostupná pro všechny věkové kategorie.  

Druhou cílovou skupinou jsou výrobci a distributoři kávy. Pro ně aplikace představuje marketingový nástroj, díky kterému mohou prostřednictvím multimediálního obsahu přiblížit zákazníkům svůj produkt a jeho příběh. Samostatnou roli budou mít také pracovníci, kteří budou spravovat administrační rozhraní a vkládat potřebná data.  

## Přínos práce
Přínos práce spočívá jednak v praktickém využití – aplikace poskytne výrobcům a distributorům nový způsob prezentace produktů a zákazníkům zajímavější zážitek z nákupu. Zároveň má projekt přínos studijní: během jeho realizace si osvojím moderní technologie, jako je multiplatformní vývoj ve Flutteru, návrh databází, tvorba backendu a správa uživatelských účtů. Součástí práce bude také zkušenost s implementací multimediálního obsahu a případným rozšířením o prvky rozšířené reality.  

## Ověřitelné body
- Úspěšné načtení QR kódu kamerou mobilního zařízení.  
- Automatické spuštění příslušného videa propojeného s QR kódem.  
- Zobrazení tlačítek **Složení** a **Více informací** po přehrání videa.  
- Zobrazení složení směsi a podrobného textového popisu produktu.  
- Funkční administrační rozhraní umožňující přiřazování videí, složení a popisů k QR kódům.  
- Správa uživatelských účtů (přidávání, mazání, úprava práv).  
- Návrh a implementace databázového modelu pro ukládání potřebných dat.  
- Otestování aplikace z pohledu uživatele i administrátora.  

## Konkurenční řešení
Existuje několik aplikací a platforem, které nabízejí podobné funkce propojení fyzických produktů s digitálním obsahem. Příkladem je **Zappar**, aplikace umožňující využít rozšířenou realitu v marketingu a reklamě. Dalším produktem byl **HP Reveal (dříve Aurasma)**, který umožňoval přiřazovat digitální obsah k obrázkům, i když již byl ukončen. Třetí inspirací je **Blippar**, platforma, která využívá rozpoznávání obrazu pro propojení s interaktivními médii.  

Oproti těmto řešením bude má aplikace jednodušší, přizpůsobená konkrétnímu účelu – prezentaci směsí kávy – a doplněná vlastním administračním prostředím, díky němuž nebude nutné využívat externí služby.  

## Závěr
Smyslem práce je vytvořit mobilní aplikaci, která propojí obal kávy s multimediálním obsahem a zákazníkovi nabídne rozšířený zážitek. Zároveň bude vybudováno administrační rozhraní, které umožní snadnou správu obsahu a uživatelských účtů. Tím vznikne praktický produkt, který kombinuje marketingový přínos pro firmy a moderní technologie přístupné koncovým zákazníkům.  

