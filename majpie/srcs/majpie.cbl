      ******************************************************************
      *                             ENTÊTE                             *
      *                                                                *
      * majpie : Programme qui gère les entrées/sorties des pièces.    *
      * Le programme reçoit donc en argument l’ID de la pièce, la      *
      * quantité, et le mode de changement (Ajout/Retrait).            *
      * Suite à l’opération, le sous programme doit générer un log     *
      * dans la base de donnée, qui indique le contenu de l’opération. *
      *                                                                *
      *----------------------------------------------------------------*
      *                           TRIGRAMMES                           *
      *                                                                *
      * MAJ=MISE À JOUR; PIE=PIÈCE; IDF=IDENTIFIANT; QTE=QUANTITE;     *
      * TYP=TYPE; CHG=CHANGEMENT; AJT=AJOUT; RTI=RETRAIT; RSU=RESULTAT;*
      * AFC=AFFECTATION; VAR=VARIABLE; SLC=SELECTION; VRT=VARIANTE;    *
      * CHX=CHOIX; NVL=NOUVELLE; GEN=GENERATION; MSG=MESSAGE;          *
      * EDT=EDITION; UTI=UTILISATEUR.                                  *
      ******************************************************************
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. majpie.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 27-06-2025 (fr).

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * Déclaration des variables correspondant aux attributs  
      * id_pie et qt_pie et nom_pie de la table piece.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 PG-IDF-PIE           PIC 9(10).
       01 PG-QTE-PIE           PIC 9(10).
       01 PG-NOM-PIE           PIC X(30).

      * Déclaration du booléen correspondant au choix de l'opération
      * sur le stock de pièces. 
       01 PG-TYP-CHG           PIC X(01).
           88 PG-AJT                       VALUE '+'.
           88 PG-RTI                       VALUE '-'.
           

      * Déclaration de la variable, correspondant à la quantité à 
      * ajouter ou à soustraire au stock, que doit saisir l'utilisateur.   

       01 PG-QTE-VRT           PIC 9(10).

      * Création de la variable d'édition pour un meilleur affichage 
      * de la variable PG-QTE-VRT dans les logs. 
       01 PG-QTE-VRT-EDT       PIC Z(10).

      * Déclaration de la variable stockant le message à inclure dans 
      * les logs à chaque opération.  
       01 PG-MSG-LOG           PIC X(100).

      * Déclaration de la variable correspondant à l'identifiant de 
      * l'utilisateur.
       01 PG-IDF-UTI           PIC 9(10).
       
       EXEC SQL END DECLARE SECTION END-EXEC.
       
       EXEC SQL INCLUDE SQLCA END-EXEC.

       
      * Déclaration de la variable correspondant au résultat de 
      * l'opération sur la quantité de pièces dans le stock.

       01 WS-QTE-RSU           PIC 9(10).

       LINKAGE SECTION.
      * Arguments d'entrée correspondant aux variables utilisées dans 
      * le programme appelant.
       01 LK-IDF-PIE           PIC 9(10).
       01 LK-QTE-PIE           PIC 9(10).
       01 LK-NOM-PIE           PIC X(30).

       01 LK-TYP-CHG           PIC X(01).
           88 LK-AJT                       VALUE '+'.
           88 LK-SUP                       VALUE '-'.

       01 LK-QTE-VRT           PIC 9(10).
       
       01 LK-IDF-UTI           PIC 9(10).


       PROCEDURE DIVISION USING LK-IDF-PIE,
                                LK-QTE-PIE,
                                LK-TYP-CHG,
                                LK-QTE-VRT
                                LK-NOM-PIE
                                LK-IDF-UTI.


           PERFORM 0100-AFC-VAR-DEB
              THRU 0100-AFC-VAR-FIN.
           
           PERFORM 0200-SLC-PIE-DEB
              THRU 0200-SLC-PIE-FIN.

           PERFORM 0300-CHX-TYP-CHG-DEB
              THRU 0300-CHX-TYP-CHG-FIN.
           
           PERFORM 0400-MAJ-NVL-QTE-DEB
              THRU 0400-MAJ-NVL-QTE-FIN.
           
           PERFORM 0500-CHX-LOG-DEB
              THRU 0500-CHX-LOG-FIN.

           EXIT PROGRAM.


      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************
       
      * Alimentation des variables à utiliser dans SQL (id de la pièce,
      * quantité pour la pièce, type d'opération, quantité à ajouter ou
      * à retirer dans le stock, nom de la pièce et l'id de  
      * l'utilisateur) avec les valeurs saisies par l'utilisateur.

       0100-AFC-VAR-DEB.

           MOVE LK-IDF-PIE 
           TO   PG-IDF-PIE.

           MOVE LK-QTE-PIE 
           TO   PG-QTE-PIE.

           MOVE LK-TYP-CHG 
           TO   PG-TYP-CHG.
           
           MOVE LK-QTE-VRT 
           TO   PG-QTE-VRT.

           MOVE LK-NOM-PIE 
           TO   PG-NOM-PIE.

           MOVE LK-IDF-UTI 
           TO   PG-IDF-UTI.

           EXIT.
       0100-AFC-VAR-FIN.

      *-----------------------------------------------------------------

      * Récupération de l'information correspondant à l'id de la pièce
      * saisi par l'utilisateur.

       0200-SLC-PIE-DEB.

           EXEC SQL 
               SELECT id_pie
               INTO   :PG-IDF-PIE
               FROM   piece
               WHERE  id_pie = :PG-IDF-PIE
           END-EXEC.

           EXIT.
       0200-SLC-PIE-FIN.

      *-----------------------------------------------------------------
       

      * Choix de l'opération à effectuer sur le stock de la pièce 
      * correspondante.

       0300-CHX-TYP-CHG-DEB.

      * Si l'utilisateur choisit d'ajouter des pièces dans le stock,
      * additionne la quantité à rajouter saisie à la quantité des  
      * pièces dans le stock.

           IF PG-AJT
               COMPUTE WS-QTE-RSU = PG-QTE-PIE + PG-QTE-VRT  
               
               PERFORM 0350-NVL-QTE-PIE-DEB
                  THRU 0350-NVL-QTE-PIE-FIN

      * Si l'utilisateur choisit de retirer des pièces dans le stock,
      * soustrait la quantité à retirer saisie à la quantité des pièces 
      * dans le stock.

           ELSE
               COMPUTE WS-QTE-RSU = PG-QTE-PIE - PG-QTE-VRT    

               PERFORM 0350-NVL-QTE-PIE-DEB
                  THRU 0350-NVL-QTE-PIE-FIN

           END-IF.
       
           EXIT.
       0300-CHX-TYP-CHG-FIN.

      *-----------------------------------------------------------------
       
      * Alimentation de la variable correspondant à la quantité des 
      * pièces dans le stock avec la nouvelle valeur. 
       0350-NVL-QTE-PIE-DEB.
           
           MOVE WS-QTE-RSU 
           TO   PG-QTE-PIE.

           EXIT.
       0350-NVL-QTE-PIE-FIN.

      *-----------------------------------------------------------------
       
      * Mise à jour de l'information sur la quantité de pièces du stock
      * dans la base de données SQL.

       0400-MAJ-NVL-QTE-DEB.

           EXEC SQL
               UPDATE piece
               SET qt_pie = :PG-QTE-PIE
               WHERE id_pie = :PG-IDF-PIE
           END-EXEC.    

           IF SQLCODE = 0
              EXEC SQL COMMIT END-EXEC 
       
           ELSE
              EXEC SQL ROLLBACK END-EXEC 
           END-IF.
           
           EXIT.
       0400-MAJ-NVL-QTE-FIN.

      *-----------------------------------------------------------------

      * Choix du message à afficher dans les logs selon l'opération sur
      * la quantité des pièces.

       0500-CHX-LOG-DEB.
           
      * Alimentation de la variable d'édition avec la valeur de la 
      * quantité à ajouter ou à retirer saisie par l'utilisateur.

           MOVE PG-QTE-VRT
           TO   PG-QTE-VRT-EDT.

      * Génération du log si un ajout de pièce dans le stock est 
      * effectué.

           IF PG-AJT
               PERFORM 0550-GEN-LOG-AJT-DEB
                  THRU 0550-GEN-LOG-AJT-FIN 

      * Génération du log si un retrait de pièce dans le stock est 
      * effectué.  

           ELSE 
               PERFORM 0550-GEN-LOG-RTI-DEB
                  THRU 0550-GEN-LOG-RTI-FIN 
           END-IF. 
           
           EXIT.
       0500-CHX-LOG-FIN.
      *-----------------------------------------------------------------
       
       0550-GEN-LOG-AJT-DEB.

      * Concaténation de chaîne de caractères avec les variables 
      * correspondant au nom de la pièce concernée et la quantité à 
      * ajouter au stock pour générer le message dans les logs.

           STRING 'Mise a jour du stock de ' DELIMITED BY SIZE 
                  PG-NOM-PIE DELIMITED BY SPACE 
                  ' de + ' DELIMITED BY SIZE
                  FUNCTION TRIM (PG-QTE-VRT-EDT) DELIMITED BY SIZE
                  ' unites.' DELIMITED BY SIZE
                  INTO PG-MSG-LOG
           END-STRING.

      * Insertion de l'heure et la date auxquelles ont été réalisées les 
      * requêtes SQL, du message de log indiquant les opérations 
      * effectuées, le type du log et l'id de l'utilisateur dans la 
      * table logs de la base de données.

           EXEC SQL
               INSERT INTO logs (heure_log, date_log, detail_log, 
                               type_log, id_uti)
               VALUES (CURRENT_TIME, CURRENT_DATE, :PG-MSG-LOG,
                      'piece', :PG-IDF-UTI)
           END-EXEC.

           IF SQLCODE = 0
              EXEC SQL COMMIT END-EXEC 
       
           ELSE
              EXEC SQL ROLLBACK END-EXEC 
           END-IF.

           EXIT.
       0550-GEN-LOG-AJT-FIN.
       
      *-----------------------------------------------------------------
       
       0550-GEN-LOG-RTI-DEB.
           
      * Concaténation de chaîne de caractères avec les variables 
      * correspondant au nom de la pièce concernée et la quantité à 
      * retirer au stock pour générer le message dans les logs.

           STRING 'Mise a jour du stock de ' DELIMITED BY SIZE 
                  PG-NOM-PIE DELIMITED BY SPACE 
                  ' de - ' DELIMITED BY SIZE
                  FUNCTION TRIM (PG-QTE-VRT-EDT) DELIMITED BY SIZE
                  ' unites.' DELIMITED BY SIZE
                  INTO PG-MSG-LOG
           END-STRING.


      * Insertion de l'heure et la date auxquelles ont été réalisées les 
      * requêtes SQL, du message de log indiquant les opérations 
      * effectuées, le type du log et l'id de l'utilisateur dans la 
      * table logs de la base de données.

           EXEC SQL
               INSERT INTO logs (heure_log, date_log, detail_log, 
                               type_log, id_uti)
               VALUES (CURRENT_TIME, CURRENT_DATE, :PG-MSG-LOG,
                      'piece', :PG-IDF-UTI)
           END-EXEC.


           IF SQLCODE = 0
              EXEC SQL COMMIT END-EXEC 
       
           ELSE
              EXEC SQL ROLLBACK END-EXEC 
           END-IF.
       
           EXIT.
       0550-GEN-LOG-RTI-FIN.



