      ****************************************************************** 
      *                                                                *
      *                 DESCRIPTION DU SOUS-PROGRAMME                  *
      *                                                                *
      * Sous-programme prenant en entrée les informations fournies pour*
      * la création d'un utilisateur et les insère dans la table       *
      * "utilisateur" de la BDD SQL.                                   *
      *                                                                *
      *----------------------------------------------------------------*
      *                           TRIGRAMMES                           *
      *                                                                *
      * creuti=Création utilisateur                                    *
      * IDF=IDENTIFIANT; UTI=UTILISATEUR; MDP=MOT DE PASSE; ROL=ROLE;  *
      * AFC=AFFECTATION; VAR=VARIABLE; DEB=DEBUT; INS=INSERTION        *
      ****************************************************************** 
       
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. creuti.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 24-06-2025 (fr).
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * Déclaration des variables correspondant aux attributs
      * (identifiant, mot de passe et role) de la table utilisateur
OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 PG-IDF-UTI         PIC X(80).
       01 PG-MDP-UTI         PIC X(64).
       01 PG-ROL-UTI         PIC X(14).
       
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.
       
      * Inclusion des codes d'erreur SQLCA
OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

      * Déclaration des variables du sous-programme 
OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(107) VALUE "INSERT INTO utilisateur(nom_ut"
OCESQL  &  "i, mdp_uti, role_uti) VALUES ( $1, encode(digest( $2, 'sha"
OCESQL  &  "256'),'hex' ), $3 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       LINKAGE SECTION. 
       01 LK-IDF-UTI         PIC X(30).
       01 LK-MDP-UTI         PIC X(30).
       01 LK-ROL-UTI         PIC X(14).

       

       PROCEDURE DIVISION USING LK-IDF-UTI,
                                LK-MDP-UTI,
                                LK-ROL-UTI.


      * Affectation des valeurs des variables du programme appelant 
      * dans les variables correspondant aux attributs SQL

           PERFORM 0100-AFC-VAR-DEB
              THRU 0100-AFC-VAR-FIN.
       
      * Insertion des variables dans la table Utilisateur 
      * la base de donnée SQL
           PERFORM 0150-INS-SQL-DEB
              THRU 0150-INS-SQL-FIN.
       
           EXIT PROGRAM.
       
      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************

           0100-AFC-VAR-DEB.

           MOVE LK-IDF-UTI     
           TO   PG-IDF-UTI.

           MOVE LK-MDP-UTI    
           TO   PG-MDP-UTI.

           MOVE LK-ROL-UTI   
           TO   PG-ROL-UTI.
       
           0100-AFC-VAR-FIN.
           EXIT.

      *-----------------------------------------------------------------

           0150-INS-SQL-DEB.
                   
OCESQL*    EXEC SQL 
OCESQL*        INSERT INTO utilisateur(nom_uti, mdp_uti, role_uti)
OCESQL*        VALUES (
OCESQL*         :PG-IDF-UTI, 
OCESQL*         encode(digest(:PG-MDP-UTI,'sha256'),'hex'),
OCESQL*         :PG-ROL-UTI)
OCESQL*    END-EXEC 
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 80
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-IDF-UTI
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 64
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-MDP-UTI
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 14
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-ROL-UTI
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

           0150-INS-SQL-FIN.
           EXIT.
           

