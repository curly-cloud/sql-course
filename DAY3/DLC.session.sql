-- Exercice: Donner la liste des 5 employés ayant la somme des ventes la plus élevée.

SELECT EmployeID, SUM(MontantTotal) SumVentes
FROM Ventes
GROUP BY EmployeID
ORDER BY SumVentes DESC
LIMIT 5; 

-- Question: Donner pour chaque vente le nom et le prénom de l'employé qui a réalisé la vente

-- Première approche produit cartésien

SELECT *
FROM Ventes, Employes
WHERE Ventes.EmployeID = Employes.EmployeID;

-- ou 

SELECT VenteID, Ventes.EmployeID, Nom, Prenom
FROM Ventes, Employes
WHERE Ventes.EmployeID = Employes.EmployeID;




/*==================================================================================
               Maîtriser les Jointures en SQL
==================================================================================*/

/*======================================================
Introduction aux Jointures en SQL
======================================================*/

-- Les jointures en SQL sont utilisées pour combiner des données de deux ou plusieurs tables en fonction d'une relation entre les colonnes de ces tables. Elles permettent de récupérer des informations provenant de plusieurs tables dans une seule requête.

/*======================================================================
Utilisation de INNER JOIN pour combiner des lignes de deux tables
SELECT colonnes
FROM table1
INNER JOIN table2
ON table1.colonne_commune = table2.colonne_commune;

Explication:
- SELECT colonnes: spécifie les colonnes à récupérer dans le résultat final.
- FROM table1: définit la première table à partir de laquelle récupérer les données.
- INNER JOIN table2: spécifie la seconde table à joindre avec la première.
- ON table1.colonne_commune = table2.colonne_commune; établit la condition de jointure, généralement l'égalité entre une colonne de la table1 et une colonne de la table2.

L'opération INNER JOIN retourne uniquement les lignes qui ont une correspondance dans les deux tables basées sur la condition spécifiée.
======================================================================*/
-- Donner pour chaque vente le nom et le prénom de l'employé qui a réalisé la vente
SELECT VenteID, Ventes.EmployeID, Nom, Prenom
FROM Ventes
INNER JOIN Employes
ON Ventes.EmployeID = Employes.EmployeID; 



-- Utilisation de USING
SELECT VenteID, Ventes.EmployeID, Nom, Prenom
FROM Ventes
INNER JOIN Employes
ON Ventes.EmployeID = Employes.EmployeID; 

-- Utilisation de JOIN
SELECT VenteID, Ventes.EmployeID, Nom, Prenom
FROM Ventes
JOIN Employes
USING (EmployeID); 








-- Exercice: Donner pour chaque produit de la base de données le nom et l'adresse de son fournisseur

SELECT  ProduitID, nomFournisseur, Adresse
FROM Produits
JOIN Fournisseurs
USING (FournisseurID);

SELECT  ProduitID, nomFournisseur, Adresse
FROM Produits pdt
JOIN Fournisseurs fns
ON pdt.FournisseurID = fns.FournisseurID;

-- Donner le nom et prénom des employés ayant réalisé la somme des ventes les plus élevées

SELECT  EmployeID, Nom, Prenom, SUM(MontantTotal) TotalVentes
FROM Ventes
JOIN Employes
USING (EmployeID)
GROUP BY EmployeID, Nom, Prenom 
ORDER BY TotalVentes DESC;

SELECT ve.EmployeID, Nom, Prenom, SUM(MontantTotal) TotalVentes
FROM Ventes ve
INNER JOIN Employes em
ON Ve.EmployeID = em.EmployeID
GROUP BY EmployeID, Nom, Prenom 
ORDER BY TotalVentes DESC;

-- Exercice donner pour chaque client le nom, l'adresse ainsi que le nombre d'achat réalisé
SELECT  Nom, Adresse, COUNT(ProduitID) NbAchat
FROM Clients
JOIN Ventes
USING (ClientID)
GROUP BY Nom, Adresse
ORDER BY NbAchat DESC;

SELECT  Nom, Adresse, COUNT(ProduitID) NbAchat
FROM Clients cl
JOIN Ventes ve
ON cl.ClientID = ve.ClientID
GROUP BY Nom, Adresse
ORDER BY NbAchat DESC;



/*======================================================================
Utilisation de LEFT JOIN et RIGHT JOIN pour combiner des lignes de deux tables
SELECT colonnes
FROM table1
LEFT JOIN table2 ON table1.colonne_commune = table2.colonne_commune;
RIGHT JOIN table2 ON table1.colonne_commune = table2.colonne_commune;

Explication:
- SELECT colonnes: spécifie les colonnes à récupérer dans le résultat final.
- FROM table1: définit la première table à partir de laquelle récupérer les données.
- LEFT JOIN table2: spécifie la seconde table à joindre avec la première, en incluant toutes les lignes de la première table (table1) même s'il n'y a pas de correspondance dans la seconde table (table2).
- RIGHT JOIN table2: similaire à LEFT JOIN mais inclut toutes les lignes de la seconde table (table2), même s'il n'y a pas de correspondance dans la première table (table1).
- ON table1.colonne_commune = table2.colonne_commune; établit la condition de jointure, généralement l'égalité entre une colonne de la table1 et une colonne de la table2.

L'opération LEFT JOIN retourne toutes les lignes de la table de gauche (table1) et les lignes correspondantes de la table de droite (table2). S'il n'y a pas de correspondance, le résultat inclura des valeurs NULL pour les colonnes de la table de droite.

L'opération RIGHT JOIN fonctionne de manière similaire mais retourne toutes les lignes de la table de droite (table2) et les lignes correspondantes de la table de gauche (table1). S'il n'y a pas de correspondance, le résultat inclura des valeurs NULL pour les colonnes de la table de gauche.
======================================================================*/

-- Question donner pour chaque employé, le nom, le prénom et le nombre de vente réalisé (il faut conserver dans la base les employés qui ont des ventes nulles)

--Avec RIGHT JOIN

SELECT Nom, Prenom, COUNT(QuantiteVendue) NbVenntes
FROM Ventes
RIGHT JOIN Employes
USING(EmployeID)
GROUP BY Nom, Prenom
ORDER BY NbVenntes DESC;

SELECT Nom, Prenom, COUNT(QuantiteVendue) NbVenntes
FROM Ventes ve
RIGHT JOIN Employes em
ON ve.EmployeID = em.EmployeID
GROUP BY Nom, Prenom
ORDER BY NbVenntes DESC;

--Avec LEFT JOIN
SELECT Nom, Prenom, COUNT(QuantiteVendue) NbVenntes
FROM Employes
LEFT JOIN Ventes
USING(EmployeID)
GROUP BY Nom, Prenom
ORDER BY NbVenntes DESC;

SELECT Nom, Prenom, COUNT(QuantiteVendue) NbVenntes
FROM Employes em
LEFT JOIN Ventes ve
ON ve.EmployeID = em.EmployeID
GROUP BY Nom, Prenom
ORDER BY NbVenntes DESC;

-- Donner pour chaque fournisseur son nom, son email et le nombre de produits fournis (laisser des fournisseurs qui n'ont aucun produit)

--Avec RIGHT JOIN

SELECT nomFournisseur, Email, COUNT(NomProduit) NbProduits
FROM Produits
RIGHT JOIN Fournisseurs
USING (FournisseurID)
GROUP BY nomFournisseur, Email
ORDER BY NbProduits DESC ; 

SELECT nomFournisseur, Email, COUNT(NomProduit) NbProduits
FROM Produits pdt
RIGHT JOIN Fournisseurs fo
ON pdt.FournisseurID = fo.FournisseurID
GROUP BY nomFournisseur, Email
ORDER BY NbProduits DESC ; 

--Avec LEFT JOIN
SELECT nomFournisseur, Email, COUNT(NomProduit) NbProduits
FROM Fournisseurs 
LEFT JOIN Produits
USING (FournisseurID)
GROUP BY nomFournisseur, Email
ORDER BY NbProduits DESC ; 

SELECT nomFournisseur, Email, COUNT(NomProduit) NbProduits
FROM Fournisseurs fo
RIGHT JOIN Produits pdt 
ON pdt.FournisseurID = fo.FournisseurID
GROUP BY nomFournisseur, Email
ORDER BY NbProduits DESC ; 

-- Donner le nom, le prénom et la moyenne des ventes par client (conservez la liste des clients qui n'ont acheté aucun produit)

--Avec LEFT JOIN

SELECT Nom, Prenom, AVG(MontantTotal) AvgVentes
FROM Clients
LEFT JOIN Ventes
USING(ClientID)
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

SELECT Nom, Prenom, AVG(MontantTotal) AvgVentes
FROM Clients cl
LEFT JOIN Ventes ve
ON cl.ClientID = ve.ClientID
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

--Avec RIGHT JOIN

SELECT Nom, Prenom, AVG(MontantTotal) AvgVentes
FROM Ventes
RIGHT JOIN Clients
USING(ClientID)
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

SELECT Nom, Prenom, AVG(MontantTotal) AvgVentes
FROM Ventes ve
RIGHT JOIN Clients cl
ON cl.ClientID = ve.ClientID
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

-- Remplacez dans la requête précédente les valeurs NULL par 0

-- COALESCE

--Avec RIGHT JOIN

SELECT Nom, Prenom,  
COALESCE(AVG(MontantTotal), '0') AS AvgVentes
FROM Ventes
RIGHT JOIN Clients
USING(ClientID)
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

SELECT Nom, Prenom,  
ROUND(COALESCE(AVG(MontantTotal), '0'),2) AS AvgVentes
FROM Ventes ve
RIGHT JOIN Clients cl
ON ve.ClientID = cl.ClientID
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

--Avec LEFT JOIN

SELECT Nom, Prenom,  
COALESCE(AVG(MontantTotal), '0') AS AvgVentes
FROM Clients
LEFT JOIN Ventes
USING(ClientID)
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;

SELECT Nom, Prenom,  
ROUND(COALESCE(AVG(MontantTotal), '0'),2) AS AvgVentes
FROM Clients cl
LEFT JOIN Ventes ve
ON cl.ClientID = ve.ClientID
GROUP BY Nom, Prenom
ORDER BY AvgVentes DESC;


-- Exercice: Donner le nom, le prénom et la somme des achats réalisés par chaque client, et affichez zéro si le montant des achats est nul

SELECT Nom, Prenom, COALESCE(SUM(MontantTotal),"0") SUMAchats
FROM Clients
LEFT JOIN Ventes
USING (ClientID)
GROUP BY  Nom, Prenom
ORDER BY SUMAchats DESC;





/*======================================================================
Création et utilisation de vues dans SQL
CREATE VIEW nom_vue AS
SELECT colonnes
FROM table1
JOIN table2 ON table1.colonne_commune = table2.colonne_commune;

Explication:
- CREATE VIEW nom_vue: commence la définition d'une nouvelle vue nommée 'nom_vue'. Les vues sont des tables virtuelles basées sur le résultat d'une requête SQL.
- SELECT colonnes: spécifie les colonnes à inclure dans la vue. Ces colonnes peuvent provenir d'une ou plusieurs tables.
- FROM table1: indique la ou les tables de base pour la vue. Les vues peuvent combiner des données de plusieurs tables via des jointures.
- JOIN table2 ON table1.colonne_commune = table2.colonne_commune; définit comment les tables sont reliées pour former la vue. Les jointures peuvent être INNER JOIN, LEFT JOIN, RIGHT JOIN, etc., selon les données à inclure.

Les vues permettent de:
1. Simplifier les requêtes complexes en masquant la complexité des jointures et des calculs.
2. Réutiliser des requêtes SQL fréquemment exécutées sans avoir à les réécrire.
3. Limiter l'accès aux données en présentant seulement une partie des données d'une table ou de plusieurs tables.
======================================================================*/

-- Créez une vue des ventes de l'année 2021`
CREATE VIEW Vente2021 AS
SELECT *
FROM Ventes 
WHERE Year(DateVente) = 2021;

SELECT *
FROM Vente2021;

-- Quelle est la liste des clients qui ont réalisé plus de 1 achats en 2021

SELECT ClientID, Nom, Prenom, COUNT(VenteID) nbVentes
FROM vente2021
JOIN Clients
USING (ClientID)
GROUP BY ClientID, Nom, Prenom
HAVING nbVentes > 1
ORDER BY nbVentes DESC; 



-- Quelle est la liste des employés qui ont les ventes moyennes supérieures à 500 en 2021?
SELECT EmployeID, Nom, Prenom, AVG(MontantTotal) MoyenneVentes
FROM vente2021
JOIN Employes
USING (EmployeID)
GROUP BY EmployeID, Nom, Prenom
HAVING MoyenneVentes >500
ORDER BY MoyenneVentes DESC; 

-- Créez une vue contenant les produits dont le prix est supérieur à 500 euros
 CREATE VIEW ProduitsSup500 AS
 SELECT *
 FROM Produits
 WHERE PrixUnitaire > 500;


-- Créez une vue contenant pour chaque client le nom, le prénom ainsi que la somme des achats par année
CREATE VIEW SommeAchatParAn AS
SELECT Nom, Prenom, SUM(MontantTotal) TotalAchats,YEAR(DateVente) Annee
FROM Clients
JOIN Ventes
USING (ClientID)
GROUP BY  Nom, Prenom,Annee;


-- Quelle est pour chaque client la moyenne des CA générés par année?
SELECT Nom,Prenom, Annee,TotalAchats
FROM sommeachatparan
ORDER BY Annee, Nom,TotalAchats DESC;

SELECT Nom, Prenom,YEAR(DateVente),AVG(MontantTotal) CAMoyen
FROM Clients
JOIN Ventes
USING (ClientID)
GROUP BY Nom, Prenom, YEAR(DateVente)
ORDER BY CAMoyen DESC; 

/*====================*/
/* Sous-requête en SQL*/
/*====================*/
-- Liste des clients qui n'ont réalisé aucun achat

SELECT *
FROM Clients
WHERE ClientID NOT IN (SELECT ClientID FROM Ventes
);

--Version count = 0 
SELECT ClientID, Nom, Prenom, COUNT(QuantiteVendue) NoPurchase
FROM Clients
LEFT JOIN Ventes
USING (ClientID)
GROUP BY ClientID, Nom, Prenom
HAVING NoPurchase = 0; 



-- Liste des employés au moins une vente
SELECT *
FROM Employes
WHERE EmployeID IN (SELECT EmployeID FROM Ventes);



-- Exercice: Écrire une requête qui permet de donner pour chaque client son nom, son prénom, la somme des achats ainsi que la moyenne annuelle des achats


SELECT
  ClientID,
  Nom,
  Prenom,
  SUM(TotalAnnuel) AS SommeAchats,
  AVG(TotalAnnuel) AS MoyenneAnnuelleAchats
FROM (
  SELECT
    c.ClientID,
    c.Nom,
    c.Prenom,
    YEAR(v.DateVente) AS Annee,
    COALESCE(SUM(v.MontantTotal), 0) AS TotalAnnuel
  FROM Clients c
  LEFT JOIN Ventes v
    ON c.ClientID = v.ClientID
  GROUP BY c.ClientID, c.Nom, c.Prenom, YEAR(v.DateVente)
) x
GROUP BY ClientID, Nom, Prenom
ORDER BY MoyenneAnnuelleAchats DESC, SommeAchats DESC;






