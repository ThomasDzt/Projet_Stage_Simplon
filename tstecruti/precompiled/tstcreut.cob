       IDENTIFICATION DIVISION.
       PROGRAM-ID. tstcreut.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 24-06-2025 (fr).
           

      ******************************************************************
      *                         DATA DIVISION                          * 
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.

      * Déclaration des variables correspondant aux attributs de ma table SQL
       01 WS-IDF-UTI         PIC X(30).
       01 WS-MDP-UTI         PIC X(30).
       01 WS-ROL-UTI         PIC X(14).

      * Déclaration des variables correspondant aux identifiants PSQL et à ma base de données
       01  WS-IDF-SQL          PIC X(30) VALUE "postgres".
       01  WS-MDP-SQL          PIC X(30) VALUE "mdp".
       01  WS-NOM-BDD-SQL      PIC X(15) VALUE "projet_test_db". 
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.
       

OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".



      ******************************************************************
      *                      PROCEDURE DIVISION                        * 
      ****************************************************************** 
       
OCESQL*
       PROCEDURE DIVISION.

       DISPLAY "Connexion à la base de données...".
OCESQL*EXEC SQL 
OCESQL*    CONNECT :WS-IDF-SQL 
OCESQL*    IDENTIFIED BY :WS-MDP-SQL 
OCESQL*    USING :WS-NOM-BDD-SQL
OCESQL*END-EXEC.
OCESQL     CALL "OCESQLConnect" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE WS-IDF-SQL
OCESQL          BY VALUE 30
OCESQL          BY REFERENCE WS-MDP-SQL
OCESQL          BY VALUE 30
OCESQL          BY REFERENCE WS-NOM-BDD-SQL
OCESQL          BY VALUE 15
OCESQL     END-CALL.

       IF SQLCODE NOT = 0
           DISPLAY "Erreur de connexion SQLCODE: " SQLCODE
       
       ELSE 
           DISPLAY "Connexion réussie"
       END-IF.

       

OCESQL*EXEC SQL COMMIT END-EXEC. 
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.
       

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
