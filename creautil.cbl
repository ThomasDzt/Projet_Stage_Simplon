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
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 WS-ID-UTIL         PIC X(80).
       01 WS-MDP-UTIL        PIC X(255).
       01 WS-ROLE-UTIL       PIC X(10).
       
       EXEC SQL END DECLARE SECTION END-EXEC.
       
      *Inclusion des codes d'erreur SQLCA
       EXEC SQL INCLUDE SQLCA END-EXEC.

      *Déclaration des variables du sous-programme 
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
                   
           EXEC SQL 
               INSERT INTO utilisateur(login_uti, mdp_uti, role_uti)
               VALUES (:WS-ID-UTIL, :WS-MDP-UTIL, :WS-ROLE-UTIL)
           END-EXEC 
               
           IF SQLCODE = 0
              DISPLAY "Insertion de l'utilisateur réussie." 
              EXEC SQL COMMIT END-EXEC 
       
           ELSE
              DISPLAY "Erreur d'insertion SQLCODE: " SQLCODE
              EXEC SQL ROLLBACK END-EXEC 
           END-IF.

           0150-INSERT-SQL-FIN.
           EXIT.
           

