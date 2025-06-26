       IDENTIFICATION DIVISION.
       PROGRAM-ID. tstcreut.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 24-06-2025 (fr).
           

      ******************************************************************
      *                         DATA DIVISION                          * 
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

      * Déclaration des variables correspondant aux attributs de ma table SQL
       01 WS-IDF-UTI         PIC X(30).
       01 WS-MDP-UTI         PIC X(30).
       01 WS-ROL-UTI         PIC X(14).

      * Déclaration des variables correspondant aux identifiants PSQL et à ma base de données
       01  WS-IDF-SQL          PIC X(30) VALUE "postgres".
       01  WS-MDP-SQL          PIC X(30) VALUE "mdp".
       01  WS-NOM-BDD-SQL      PIC X(15) VALUE "projet_test_db". 
       EXEC SQL END DECLARE SECTION END-EXEC.
       

       EXEC SQL INCLUDE SQLCA END-EXEC.



      ******************************************************************
      *                      PROCEDURE DIVISION                        * 
      ****************************************************************** 
       
       PROCEDURE DIVISION.

       DISPLAY "Connexion à la base de données...".
       EXEC SQL 
           CONNECT :WS-IDF-SQL 
           IDENTIFIED BY :WS-MDP-SQL 
           USING :WS-NOM-BDD-SQL
       END-EXEC.

       IF SQLCODE NOT = 0
           DISPLAY "Erreur de connexion SQLCODE: " SQLCODE
       
       ELSE 
           DISPLAY "Connexion réussie"
       END-IF.

       

       EXEC SQL COMMIT END-EXEC. 
       

       PERFORM 0100-INS-DEB
          THRU 0100-INS-FIN.

       STOP RUN.

      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************

       0100-INS-DEB.
       CALL "ecruti" USING   WS-IDF-UTI,
                             WS-MDP-UTI,
                             WS-ROL-UTI
       
       END-CALL.


       0100-INS-FIN.
       EXIT.
