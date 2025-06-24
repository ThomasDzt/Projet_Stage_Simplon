      ****************************************************************** 
      *                                                                *
      *                 DESCRIPTION DU SOUS-PROGRAMME                  *
      *----------------------------------------------------------------*
      *                                                                *
      *Sous-programme prenant en entrée les informations fournies pour *
      *la création d'un utilisateur et les insère dans la table        *
      *"Utilisateur" de la BDD SQL.                                    *
      *                                                                *
      ****************************************************************** 
       
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. creautil.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 24-06-2025 (fr).
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *Déclaration des variables correspondant aux attributs (identifiant, mot de passe et role) de la table Utilisateur
OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 WS-ID-UTIL         PIC X(80).
       01 WS-MDP-UTIL        PIC X(255).
       01 WS-ROLE-UTIL       PIC X(10).
       
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.
       
      *Inclusion des codes d'erreur SQLCA
OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

      *Déclaration des variables du sous-programme 
OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(075) VALUE "INSERT INTO utilisateur(login_"
OCESQL  &  "uti, mdp_uti, role_uti) VALUES ( $1, $2, $3 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       LINKAGE SECTION. 
       01 LK-ID-UTIL         PIC X(80).
       01 LK-MDP-UTIL        PIC X(255).
       01 LK-ROLE-UTIL       PIC X(10).

       

       PROCEDURE DIVISION USING LK-ID-UTIL,
                                LK-MDP-UTIL,
                                LK-ROLE-UTIL.


      *Affectation des valeurs des variables du programme appelant dans les variables correspondant aux attributs SQL

           PERFORM 0100-AFFECT-VAR-DEBUT
              THRU 0100-AFFECT-VAR-FIN.
       
      *Insertion des variables dans la table Utilisateur la base de donnée SQL
           PERFORM 0150-INSERT-SQL-DEBUT
              THRU 0150-INSERT-SQL-FIN.
       
           EXIT PROGRAM.
       
      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************

           0100-AFFECT-VAR-DEBUT.

           MOVE LK-ID-UTIL     
           TO   WS-ID-UTIL.

           MOVE LK-MDP-UTIL    
           TO   WS-MDP-UTIL.

           MOVE LK-ROLE-UTIL   
           TO   WS-ROLE-UTIL.
       
           0100-AFFECT-VAR-FIN.
           EXIT.

      *-----------------------------------------------------------------

           0150-INSERT-SQL-DEBUT.
                   
OCESQL*    EXEC SQL 
OCESQL*        INSERT INTO utilisateur(login_uti, mdp_uti, role_uti)
OCESQL*        VALUES (:WS-ID-UTIL, :WS-MDP-UTIL, :WS-ROLE-UTIL)
OCESQL*    END-EXEC 
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 80
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE WS-ID-UTIL
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 255
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE WS-MDP-UTIL
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE WS-ROLE-UTIL
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL          BY VALUE 3
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
               
           IF SQLCODE = 0
              DISPLAY "Insertion de l'utilisateur réussie." 
OCESQL*       EXEC SQL COMMIT END-EXEC 
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
       
           ELSE
              DISPLAY "Erreur d'insertion SQLCODE: " SQLCODE
OCESQL*       EXEC SQL ROLLBACK END-EXEC 
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "ROLLBACK" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
           END-IF.

           0150-INSERT-SQL-FIN.
           EXIT.
           

