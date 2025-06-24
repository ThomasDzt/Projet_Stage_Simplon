           IDENTIFICATION DIVISION.
           PROGRAM-ID. tstcreut.
           AUTHOR. ThomasD.


      ******************************************************************
      *                         DATA DIVISION                          * 
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

      * Déclaration des variables correspondant aux attributs de ma table SQL
       01 WS-ID-UTIL         PIC X(80).
       01 WS-MDP-UTIL        PIC X(255).
       01 WS-ROLE-UTIL       PIC X(10).

      * Déclaration des variables correspondant aux identifiants PSQL et à ma base de données
       01  WS-IDENTIFIANT       PIC X(30) VALUE "postgres".
       01  WS-MOT-PASSE         PIC X(30) VALUE "mdp".
       01  WS-NOM-BASE          PIC X(15) VALUE "projet_test_db". 
       EXEC SQL END DECLARE SECTION END-EXEC.
       

       EXEC SQL INCLUDE SQLCA END-EXEC.



      ******************************************************************
      *                      PROCEDURE DIVISION                        * 
      ****************************************************************** 
       
       PROCEDURE DIVISION.

       DISPLAY "Connexion à la base de données...".
       EXEC SQL 
           CONNECT :WS-IDENTIFIANT 
           IDENTIFIED BY :WS-MOT-PASSE 
           USING :WS-NOM-BASE
       END-EXEC.

       IF SQLCODE NOT = 0
           DISPLAY "Erreur de connexion SQLCODE: " SQLCODE
       
       ELSE 
           DISPLAY "Connexion réussie"
       END-IF.

       

       EXEC SQL COMMIT END-EXEC. 
       
       DISPLAY "Entrez un ID utilisateur :".
       ACCEPT WS-ID-UTIL.

       DISPLAY "Entrez un mdp utilisateur :".
       ACCEPT WS-MDP-UTIL.
       
       DISPLAY "Entrez un role utilisateur :".
       ACCEPT WS-ROLE-UTIL.


       PERFORM 0100-INSERTION-DEBUT
          THRU 0100-INSERTION-FIN.

       STOP RUN.

      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************

       0100-INSERTION-DEBUT.
       CALL "creautil" USING WS-ID-UTIL,
                             WS-MDP-UTIL,
                             WS-ROLE-UTIL
       
       END-CALL.


       0100-INSERTION-FIN.
       EXIT.
