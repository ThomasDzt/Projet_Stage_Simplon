              IDENTIFICATION DIVISION.
       PROGRAM-ID. tstmajpie.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 30-06-2025 (fr).
           

      ******************************************************************
      *                         DATA DIVISION                          * 
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

      * Déclaration des variables correspondant aux attributs de ma table SQL
       01 PG-IDF-PIE         PIC 9(10).
       01 PG-NOM-PIE         PIC X(30).

       01 PG-QTE-PIE         PIC 9(10).
       01 PG-SUL-PIE         PIC 9(10).

       01 PG-QTE-VRT           PIC 9(10).
              
       01 PG-TYP-CHG           PIC 9(01).
           88 PG-AJT                       VALUE 0.
           88 PG-RTI                       VALUE 1.

           
      * Déclaration des variables correspondant aux identifiants PSQL et à ma base de données
       01  PG-IDF-SQL          PIC X(30) VALUE "postgres".
       01  PG-MDP-SQL          PIC X(30) VALUE "mdp".
       01  PG-NOM-BDD-SQL      PIC X(15) VALUE "projet_test_db". 
       EXEC SQL END DECLARE SECTION END-EXEC.
       

       EXEC SQL INCLUDE SQLCA END-EXEC.



      ******************************************************************
      *                      PROCEDURE DIVISION                        * 
      ****************************************************************** 
       
       PROCEDURE DIVISION.

           DISPLAY "Connexion à la base de données...".
           EXEC SQL 
               CONNECT :PG-IDF-SQL 
               IDENTIFIED BY :PG-MDP-SQL 
               USING :PG-NOM-BDD-SQL
           END-EXEC.
       
           IF SQLCODE NOT = 0
               DISPLAY "Erreur de connexion SQLCODE: " SQLCODE
           
           ELSE 
               DISPLAY "Connexion réussie"
           END-IF.
       
           
       
           EXEC SQL COMMIT END-EXEC. 
           
           
           PERFORM 0100-SAISIE-INFOS-PIE-DEB
              THRU 0100-SAISIE-INFOS-PIE-FIN.
       
           PERFORM 0200-INS-DEB
              THRU 0200-INS-FIN.
       
           STOP RUN.

      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************
       
       0100-SAISIE-INFOS-PIE-DEB.
           DISPLAY "Entrez l'ID de la pièce :".
           ACCEPT PG-IDF-PIE.
           
      *    DISPLAY "Entrez le nom de la pièce :".
      *    ACCEPT PG-NOM-PIE.
       
           DISPLAY "Entrez la quantité de stock de la pièce :".
           ACCEPT PG-QTE-PIE.
           
      *    DISPLAY "Entrez le seuil de quantité de la pièce :".
      *    ACCEPT PG-SUL-PIE.

           DISPLAY "Choisir l'opération à réaliser sur le stock :".
           ACCEPT PG-TYP-CHG.
           
           DISPLAY "Saisir la quantité à ajouter ou à retirer :".  
           ACCEPT PG-QTE-VRT.

           EXIT.
       0100-SAISIE-INFOS-PIE-FIN.


      *----------------------------------------------------------------- 
       0200-INS-DEB.
           CALL "majpie" USING   PG-IDF-PIE,
                                 PG-QTE-PIE,
                                 PG-TYP-CHG,
                                 PG-QTE-VRT           
           END-CALL.
       
           EXIT.
           
       0200-INS-FIN.
