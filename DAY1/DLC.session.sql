
-- Lire des informations dans la base

/*======================================================*/
/*                 Maîtriser la clause SELECT           */
/*======================================================*/

/*======================================================*/
/* Fonctionnalité 1: Sélectionner toutes les informations d'une table 
Syntaxe générale:
SELECT *
FROM nom_table;
*/
/*======================================================*/

-- QUESTION 1: Donner la table complète des produits vendus par l'entreprise 

SELECT *
FROM Produits;

-- QUESTION 2: Donner la table complète des clients de l'entreprise
SELECT *
FROM Clients;

/*======================================================*/
/* Fonctionnalité 2: Sélectionner une seule colonne
Syntaxe générale:
SELECT nom_colonne
FROM nom_table;
*/
/*======================================================*/

-- QUESTION 3: Donner le nom de tous les produits de la base de données

SELECT NomProduit
FROM Produits;


-- QUESTION 4: Donner le nom de tous les fournisseurs de la base de données
SELECT NomFournisseur
FROM Fournisseurs;
 
/*======================================================*/
/* Fonctionnalité 3: Sélectionner deux ou plusieurs colonnes
Syntaxe générale:
SELECT nom_colonne1, nom_colonne2,..., nom_colonne3
FROM nom_table;
======================================================*/

-- QUESTION 5: Donner le nom et le prénom des employés de l'entreprise

SELECT Nom, Prenom
FROM Employes;

-- QUESTION 6: Donner le nom, le prix et la description de tous les produits

SELECT NomProduit, Description, PrixUnitaire
FROM Produits;
/*======================================================*/
/* Fonctionnalité 4: Sélectionner des valeurs distinctes
Syntaxe générale:
SELECT DISTINCT nom_colonne
FROM nom_table;
======================================================*/

-- QUESTION 7: Donner les différentes dates auxquelles des ventes ont été réalisées
SELECT DISTINCT Datevente
FROM Ventes;

-- QUESTION 8: Donner les noms et prénoms distincts des employés de l'entreprise

SELECT DISTINCT Nom, Prenom
FROM Employes;
/*==========================================================================================*/
/*                 Maîtriser la clause WHERE POUR FILTRER suivant des conditions           */
/*==========================================================================================*/

/*======================================================*/
/* Fonctionnalité 6: Filtrer suivant une condition
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition;
======================================================*/
-- Liste produit vendu 
SELECT ProduitID, NomProduit
FROM Produits;

-- Liste produit vendu est à > 200

SELECT ProduitID, NomProduit,PrixUnitaire
FROM Produits
WHERE PrixUnitaire > 200 ;

-- Liste produit vendu est à <= 200
SELECT ProduitID, NomProduit,PrixUnitaire
FROM Produits
WHERE PrixUnitaire <= 200 ;

-- Liste produit vendu compris et 50 et 100
SELECT ProduitID, NomProduit,PrixUnitaire
FROM Produits
WHERE PrixUnitaire BETWEEN 50 AND 100 ;

-- QUESTION 9: Information sur le produit "Nike Air Max" 

SELECT ProduitID, NomProduit,PrixUnitaire
FROM Produits
WHERE NomProduit = "Nike Air Max"  ;

-- QUESTION 10: Donner la liste des produits du fournisseur numéro 13

SELECT ProduitID, NomProduit,PrixUnitaire
FROM Produits
WHERE FournisseurID = 13  ;
-- Description des produits du fournisseur numéro 13

SELECT ProduitID, NomProduit,PrixUnitaire,Description
FROM Produits
WHERE FournisseurID = 13  ;


/*======================================================*/
/* Fonctionnalité 7: Utilisation de plusieurs conditions avec AND et OR
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition1 AND/OR condition2;
======================================================*/
-- Liste des produits vendu par le fournisseur 13 ou par le fournisseur 11
SELECT *
FROM Produits
WHERE FournisseurID = 13 OR FournisseurID = 11 ;

/*======================================================*/
/* Fonctionnalité 8: Utilisation de IN dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne IN (valeur1, valeur2, ...)
pour créer une liste de choix;
======================================================*/

SELECT *
FROM Produits
WHERE FournisseurID IN (13, 15, 55, 45, 89, 88);


/*======================================================*/
/* Fonctionnalité 9: Utilisation de BETWEEN dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne BETWEEN valeur1 AND valeur2;
======================================================*/

-- Sélectionner les ventes réalisées entre le 1er janvier 2021 et le 31 décembre 2023

SELECT *
FROM Ventes
WHERE  DateVente BETWEEN  "2021-01-01" AND  "2023-12-31" ;

/*======================================================*/
/* Fonctionnalité 10: Utilisation de LIKE dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne 
FROM nom_table 
WHERE nom_colonne LIKE 'motif';
======================================================*/
-- Nom des clients qui commencent par la lettre c
SELECT *
FROM Clients
WHERE Nom LIKE 'c%';

-- Nom des clients qui commencent par la lettre c et qui se termine par a

SELECT *
FROM Clients
WHERE Nom LIKE 'c%a';


-- Le nom contient la lettre n
SELECT *
FROM Clients
WHERE Nom LIKE '%n%';

-- Le nom contient  "on"
SELECT *
FROM Clients
WHERE Nom LIKE '%on%';

-- Donner la liste des produits qui commencent par 'a'
SELECT *
FROM Produits
WHERE NomProduit LIKE 'a%';
-- Donner la liste des produits qui contiennent la lettre 'a'
SELECT *
FROM Produits
WHERE NomProduit LIKE '%a%';
-- Donner la liste des produits commençant par 'N' et finissant par 'x'

SELECT *
FROM Produits
WHERE NomProduit LIKE 'n%x';
/*==========================================================================================
                 Maîtriser la clause ORDER BY POUR CLASSER
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition
ORDER BY nom_colonne [ASC | DESC], autre_nom_colonne [ASC | DESC], ...;
==========================================================================================*/

-- Donner la liste des produits du moins coûteux au plus coûteux
SELECT *
FROM Produits
ORDER BY PrixUnitaire;

-- Donner la liste des produits du prix le plus élevé au prix le moins élevé

SELECT *
FROM Produits
ORDER BY PrixUnitaire DESC;

-- Liste des employés ordre alphabétique le nom t décroissant prénom

SELECT *
FROM Employes
ORDER BY Nom DESC;
-- La liste des produits dont le prix est supérieur à 200, résultat par alphabétqiue suivant le nom du produit
SELECT *
FROM Produits
WHERE PrixUnitaire > 200
ORDER BY NomProduit ;