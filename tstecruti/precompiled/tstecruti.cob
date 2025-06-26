      ****************************************************************** 
      *                                                                *
      *                 DESCRIPTION DU SOUS-PROGRAMME                  *
      *                                                                *
      * Sous-programme permettant de créer un utilisateur en entrant   *
      * toutes les informations nécessaires à l'aide de la SCREEN      *
      * SECTION. Le programme appellera le sous-programme creuti afin  *
      * d'insérer les informations dans la base de données             *
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
      *                           TRIGRAMMES                           *
      *                                                                *
      * ecruti=Ecran utilisateur;                                      *
      * UTI=UTILISATEUR; MDP=MOT DE PASSE; ROL=ROLE; ECR=ECRAN;        *
      * CRE=CREATION; VLD=VALIDE; ENT=ENTREE; LRR=LEURRE; CLR=COULEUR; *
      * TXT=TEXTE; FND=FOND; PLS=PLUS; TRT=TIRET; BAR=BARRE;           *
      * CRG= CROCHET GAUCHE; CRD=CROCHET DROIT; CHX=CHOIX;             *
      * CFM=CONFIRMATION; AFF=AFFICHAGE; DEB=DEBUT;                    *
      ******************************************************************
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ecruti.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 25-06-2025 (fr).
       
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-ENT               PIC X(01).
       01 WS-LRR               PIC X(01).
       01 WS-PLS               PIC X(01)   VALUE "+".
       01 WS-TRT               PIC X(78)   VALUE ALL "-".
       01 WS-BAR               PIC X(01)   VALUE "|".
       01 WS-CRG               PIC X(01)   VALUE "[".
       01 WS-CRD               PIC X(01)   VALUE "]".
       
       
       01 WS-IDF-UTI           PIC X(30).
       01 WS-MDP-UTI           PIC X(30).
       01 WS-MDP-UTI-CFM       PIC X(30).

       01 WS-ROL-UTI           PIC X(14).
       01 WS-CHX               PIC X(01).
       
       01 WS-CLR-TXT           PIC 9(01)       VALUE 7. *> Blanc
       01 WS-CLR-FND           PIC 9(01)       VALUE 0. *> Noir



OCESQL*
       SCREEN SECTION.

       01 S-ECR-CRE-UTI 
           FOREGROUND-COLOR WS-CLR-TXT    
           BACKGROUND-COLOR WS-CLR-FND.

           05 BLANK SCREEN.
           
           05 LINE 01 COL 01 PIC X(01) FROM WS-PLS.
           05 LINE 01 COL 02 PIC X(78) FROM WS-TRT.
           05 LINE 01 COL 80 PIC X(01) FROM WS-PLS.

           05 LINE 02 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 02 COL 33 VALUE "LogiParts Solutions".
           05 LINE 02 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 03 COL 01 PIC X(01) FROM WS-PLS.
           05 LINE 03 COL 02 PIC X(78) FROM WS-TRT.
           05 LINE 03 COL 80 PIC X(01) FROM WS-PLS.

           05 LINE 04 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 04 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 05 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 05 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 06 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 06 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 07 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 07 COL 03 VALUE "Nom :".
           05 LINE 07 COL 30 PIC X(01) FROM WS-CRG.
           05 LINE 07 COL 31 PIC X(30) TO   WS-IDF-UTI.
           05 LINE 07 COL 61 PIC X(01) FROM WS-CRD.
           05 LINE 07 COL 80 PIC X(01) FROM WS-BAR.
           
           05 LINE 08 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 08 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 09 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 09 COL 03 VALUE "Mot de passe :".
           05 LINE 09 COL 30 PIC X(01) FROM WS-CRG.
           05 LINE 19 COL 34 PIC X(01) TO   WS-CHX.
           05 LINE 19 COL 35 PIC X(01) FROM WS-CRD.
           05 LINE 19 COL 80 PIC X(01) FROM WS-BAR.
           
           05 LINE 20 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 09 COL 31 PIC X(30) TO   WS-MDP-UTI.
           05 LINE 09 COL 61 PIC X(01) FROM WS-CRD.
           05 LINE 09 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 10 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 10 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 11 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 11 COL 03 VALUE "Confirmer mot de passe :".
           05 LINE 11 COL 30 PIC X(01) FROM WS-CRG.
           05 LINE 11 COL 31 PIC X(30) TO   WS-MDP-UTI-CFM.
           05 LINE 11 COL 61 PIC X(01) FROM WS-CRD.
           05 LINE 11 COL 80 PIC X(01) FROM WS-BAR.
           
           05 LINE 12 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 12 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 13 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 13 COL 03 VALUE "Role :".
           05 LINE 13 COL 30 PIC X(01) FROM WS-CRG.
           05 LINE 13 COL 31 PIC X(14) TO   WS-ROL-UTI.
           05 LINE 13 COL 45 PIC X(01) FROM WS-CRD.
           05 LINE 13 COL 80 PIC X(01) FROM WS-BAR.


           05 LINE 14 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 14 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 15 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 15 COL 80 PIC X(01) FROM WS-BAR.
           
           05 LINE 16 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 16 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 17 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 17 COL 20 VALUE "1 - Creer un utilisateur".
           05 LINE 17 COL 47 VALUE "2 - Annuler".
           05 LINE 17 COL 80 PIC X(01) FROM WS-BAR.
       
           05 LINE 18 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 18 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 19 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 19 COL 33 PIC X(01) FROM WS-CRG.
           05 LINE 19 COL 34 PIC X(01) TO   WS-CHX.
           05 LINE 19 COL 35 PIC X(01) FROM WS-CRD.
           05 LINE 19 COL 80 PIC X(01) FROM WS-BAR.
           
           05 LINE 20 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 20 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 21 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 21 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 22 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 22 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 23 COL 01 PIC X(01) FROM WS-BAR.
           05 LINE 23 COL 80 PIC X(01) FROM WS-BAR.

           05 LINE 24 COL 01 PIC X(01) FROM WS-PLS.
           05 LINE 24 COL 02 PIC X(78) FROM WS-TRT.
           05 LINE 24 COL 80 PIC X(01) FROM WS-PLS.




       PROCEDURE DIVISION.
           DISPLAY S-ECR-CRE-UTI.
           ACCEPT  S-ECR-CRE-UTI.
           
           EVALUATE TRUE 
               WHEN WS-CHX = 1
                  IF WS-MDP-UTI-CFM = WS-MDP-UTI
                   DISPLAY "Utilisateur cree avec succes !"
                   AT LINE 22 COL 03 
                  ELSE 
                   DISPLAY "Echec lors de la creation de l'utilisateur"
                   AT LINE 22 COL 03  
                  END-IF

                   DISPLAY "Appuyez sur entree"
                   AT LINE 23 COL 03 

                   ACCEPT WS-LRR 
                   AT LINE 23 COL 21 
                   
               WHEN WS-CHX = 2
                   EXIT PROGRAM

               WHEN OTHER 
                   DISPLAY "Erreur de saisie, veuillez choisir 1 ou 2"
                   AT LINE 22 COL 03 

           END-EVALUATE.

           EXIT PROGRAM.

     