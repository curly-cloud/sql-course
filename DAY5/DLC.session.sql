
/*==================================================================================
            Fonctions de fenêtrage
==================================================================================*/
-- Syntaxe de Base pour les Fonctions de Fenêtrage en SQL
/*
SELECT colonnes,
       FONCTION_DE_FENETRAGE() OVER (
           PARTITION BY colonne_de_partitionnement
           ORDER BY colonne_de_tri
           RANGE | ROWS BETWEEN debut AND fin
       ) AS nom_colonne_resultat
FROM table;

Explication:
- SELECT colonnes: Spécifie les colonnes à récupérer dans le résultat final, incluant la colonne résultante de la fonction de fenêtrage.
- FONCTION_DE_FENETRAGE() OVER (...): Applique une fonction de fenêtrage à un ensemble de lignes.
- PARTITION BY colonne_de_partitionnement: Divise les données en partitions pour le traitement par la fonction de fenêtrage.
- ORDER BY colonne_de_tri: Détermine l'ordre des lignes dans chaque partition.
- RANGE | ROWS BETWEEN debut AND fin: Définit le cadre de lignes pour l'application de la fonction.

*/

/* La somme des quantités vendues par produit*/
SELECT 
	ProduitID,
    NomProduit,
    SUM(QuantiteVendue)as Qventes
FROM Produits
JOIN Ventes
USING(ProduitId)
GROUP BY 
	ProduitID,
    NomProduit
ORDER BY Qventes DESC; 


/* Donner le classement des produits en fonction de la quantité vendue QuantiteVendue(vente) RANK()*/

SELECT 
	ProduitID,
    NomProduit,
    SUM(QuantiteVendue)as Qventes,
    RANK()
    OVER(ORDER BY SUM(QuantiteVendue)DESC) as classement
FROM Produits
JOIN Ventes
USING(ProduitId)
GROUP BY 
	ProduitID,
    NomProduit;
    
-- avec DENSE_RANK (pour que le classement continu malgrè les égalités)
SELECT 
	ProduitID,
    NomProduit,
    SUM(QuantiteVendue)as Qventes,
    DENSE_RANK()
    OVER(ORDER BY SUM(QuantiteVendue)DESC) as classement -- critère de classment
FROM Produits
JOIN Ventes
USING(ProduitId)
GROUP BY 
	ProduitID,
    NomProduit;
/* Donner pour chaque employé son chiffre d'affaire réalisé ainsi que son classment   */
SELECT 
	EmployeID,
    Nom,
    Prenom,
    SUM(MontantTotal) as CAparEmp,
    DENSE_RANK()
    OVER(ORDER BY SUM(MontantTotal)DESC) as Classement
FROM Employes 
JOIN Ventes
USING(EmployeID)
GROUP BY
	EmployeID,
    Nom,
    Prenom ;


/* Donner le Top 3 des meilleurs vendeur en terme de chiffre d'affaire par année (DENSE_RANK) POur les exaequo sans saut: Sous requête */

SELECT 
	EmployeID,
    Nom,
    Prenom,
    YEAR(DateVente) as Annee,
    SUM(MontantTotal) as CAparEmp,
    DENSE_RANK()
    OVER(PARTITION BY  YEAR(DateVente) ORDER BY SUM(MontantTotal)DESC) as Classement
FROM Employes 
JOIN Ventes
USING(EmployeID)
GROUP BY
	EmployeID,
    Nom,
    Prenom,
    Annee;



/* CA par année et par employé*/


SELECT EmployeID, YEAR(dateVente) AS Annee, SUM(MontantTotal) AS CA, 
	   DENSE_RANK()
	  OVER (PARTITION BY YEAR(dateVente) 
      ORDER BY SUM(MontantTotal) DESC) As Classement
FROM Ventes
GROUP BY EmployeID, Annee;


SELECT temp.EmployeID, temp.Annee, temp.CA, temp.Classement
FROM
		(SELECT EmployeID, YEAR(dateVente) AS Annee, SUM(MontantTotal) AS CA, 
			   DENSE_RANK()
			  OVER (PARTITION BY YEAR(dateVente) 
			  ORDER BY SUM(MontantTotal) DESC) As Classement
		FROM Ventes
		GROUP BY EmployeID, Annee) AS temp
        
WHERE Classement BETWEEN 1 AND 3;


SELECT Nom, Prenom, temp.EmployeID, temp.Annee, temp.CA, temp.Classement
FROM
		(SELECT EmployeID, YEAR(dateVente) AS Annee, SUM(MontantTotal) AS CA, 
			   DENSE_RANK()
			  OVER (PARTITION BY YEAR(dateVente) 
			  ORDER BY SUM(MontantTotal) DESC) As Classement
		FROM Ventes
		GROUP BY EmployeID, Annee) AS temp JOIN Employes USING(EmployeID)
        
WHERE Classement BETWEEN 1 AND 3;






CREATE VIEW classement AS
SELECT EmployeID, YEAR(dateVente) AS Annee, SUM(MontantTotal) AS CA, 
			   DENSE_RANK()
			  OVER (PARTITION BY YEAR(dateVente) 
			  ORDER BY SUM(MontantTotal) DESC) As Classement
		FROM Ventes
		GROUP BY EmployeID, Annee;

SELECT EmployeID, Annee, CA, Classement
FROM classement
WHERE Classement BETWEEN 1 AND 3;


/* Donner le top 3 des meilleurs clients en terme de chiffre d'affaire par trimestre (Quater) pour chaque année*/

/*CA par client et par trimestre*/
SELECT ClientID, YEAR(DateVente) AS Annee, QUARTER(DateVente) as Trimestre, AVG(MontantTotal) AS CA
FROM Ventes
GROUP BY ClientID, YEAR(DateVente), QUARTER(DateVente);

/*CA par client et par trimestre*/
SELECT ClientID, 
	   YEAR(DateVente) AS Annee, 
	   QUARTER(DateVente) as Trimestre, 
	   AVG(MontantTotal) AS CA,
	   RANK()
       OVER(PARTITION BY YEAR(DateVente), QUARTER(DateVente) ORDER BY AVG(MontantTotal)) AS Classement
FROM Ventes
GROUP BY ClientID, YEAR(DateVente), QUARTER(DateVente);

/*top 3 par client et par trimestre*/
SELECT ClientID, Annee, Trimestre, CA, Classement
FROM 
		(SELECT ClientID, 
			   YEAR(DateVente) AS Annee, 
			   QUARTER(DateVente) as Trimestre, 
			   AVG(MontantTotal) AS CA,
			   RANK() -- classement
			   OVER(PARTITION BY YEAR(DateVente), QUARTER(DateVente) ORDER BY AVG(MontantTotal)) AS Classement
		FROM Ventes
		GROUP BY ClientID, YEAR(DateVente), QUARTER(DateVente)) AS temp
        
WHERE Classement BETWEEN 1 AND 3; 




/* Utilisation de LAG: LAG(value_expression [, offset [, default]]) OVER ([partition_by_clause] order_by_clause)*/

/* on veut calculer l'évolition du chiffre d'affaire*/

/* Donner la différence du chiffre d'affaire entre t et t-1*/
/*CA par année*/
SELECT YEAR(DateVente) as Annee, SUM(MontantTotal) as CA
FROM Ventes
GROUP BY Annee;

/* LAG(SUM(MontantTotal),1,0) 1 = entre la valeur actuel et la valeur passée, 2 n-2, 3 n-3 ... 0 =  valeur par défaut */
SELECT YEAR(DateVente) AS Annee, 
		SUM(MontantTotal) AS CA,
        SUM(MontantTotal) - LAG(SUM(MontantTotal),1,0)
        OVER(ORDER BY YEAR(DateVente)) AS Diff
FROM Ventes
GROUP BY Annee;

/* Determiner le taux de croissance*/

SELECT YEAR(DateVente) AS Annee, 
		SUM(MontantTotal) AS CA,
        (SUM(MontantTotal) - LAG(SUM(MontantTotal),1,0)
        OVER(ORDER BY YEAR(DateVente)) ) 
        / 
        LAG(SUM(MontantTotal),1, 0) 
        OVER(ORDER BY YEAR(DateVente)) AS Txcroissance
FROM Ventes
GROUP BY Annee;

/* Ajouter le montant total de l'année n-1*/
SELECT YEAR(DateVente) as Annee, 
		SUM(MontantTotal) AS CA,
		LAG(SUM(MontantTotal),1,0) 
        OVER(ORDER BY YEAR(DateVente)) as CAprecedent
FROM Ventes
GROUP BY Annee;



SELECT YEAR(DateVente) AS ANNEE, 
	   MAX(MontantTotal)
       OVER(PARTITION BY YEAR(DateVente) ORDER BY SUM(MontantTotal) ) AS Maximum
FROM Ventes
;


/* Quelle est le montant total des ventes par trimestres pour chaque année 
-- et comment les ventes évoluent d'un trimestre à l'autre*/

SELECT YEAR(DateVente) AS Annee, 
	   QUARTER(DateVente) AS Trimestre, 
	   SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY YEAR(DateVente), QUARTER(DateVente);



SELECT YEAR(DateVente) AS Annee, 
	   QUARTER(DateVente) AS Trimestre, 
	   SUM(MontantTotal) AS CA,
       SUM(MontantTotal) - LAG(SUM(MontantTotal), 1, 0)
       OVER(ORDER BY YEAR(DateVente), QUARTER(DateVente)) as Evolution
FROM Ventes
GROUP BY YEAR(DateVente), QUARTER(DateVente);

/*==================================================================================
           Fonctions ensemblistes
==================================================================================*/
-- UNION: Combine les résultats de deux requêtes en éliminant les doublons.
/*
SELECT colonne FROM table1
UNION
SELECT colonne FROM table2;

Explication:
- L'opérateur UNION est utilisé pour combiner les résultats de deux requêtes distinctes.
- Il élimine les lignes en double pour ne retourner que des lignes distinctes.
- Les deux requêtes doivent avoir le même nombre de colonnes dans le résultat, avec des types de données compatibles.
*/

-- Quelle est la liste combinée des noms de tous les employés et de tous les clients ?


-- UNION ALL: Combine les résultats de deux requêtes en conservant les doublons.
/*
SELECT colonne FROM table1
UNION ALL
SELECT colonne FROM table2;

Explication:
- L'opérateur UNION ALL combine les résultats de deux requêtes sans éliminer les doublons.
- Cela peut être utile si vous souhaitez conserver toutes les lignes, y compris les répétitions.
- Comme pour UNION, les requêtes combinées doivent avoir des résultats avec le même nombre et type de colonnes.
*/

-- Quels sont tous les noms des employés et des clients, en incluant les noms répétés ?

-- INTERSECT: Retourne les lignes communes à deux requêtes.
/*
SELECT colonne FROM table1
INTERSECT
SELECT colonne FROM table2;

Explication:
- L'opérateur INTERSECT trouve les lignes qui sont communes aux deux requêtes.
- Il est moins fréquemment supporté que UNION et UNION ALL dans certains systèmes de gestion de bases de données.
- Les deux requêtes doivent avoir des structures de résultat compatibles.
*/

-- Quelles sont les employés ayant réalisé plus de 1000 euros de chiffres d'affaire et qui on réalisé plus de 10 ventes


-- EXCEPT ou MINUS: Retourne les lignes de la première requête qui ne sont pas présentes dans la seconde.
/*
SELECT colonne FROM table1
EXCEPT
SELECT colonne FROM table2;

Explication:
- L'opérateur EXCEPT (ou MINUS, selon le système de gestion de base de données) soustrait les résultats de la seconde requête de la première.
- Le résultat contient uniquement les lignes uniques de la première requête qui ne sont pas trouvées dans la seconde.
- Les deux requêtes doivent retourner le même nombre de colonnes avec des types de données compatibles.
*/


-- Quels employés n'ont jamais réalisé de vente ?
-- Quels employés n'ont pas géré de clients VIP ? (clients achete plus de 5000 euros)

