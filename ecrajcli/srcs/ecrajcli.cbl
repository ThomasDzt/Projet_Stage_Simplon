      ******************************************************************
      *                             ENTÊTE                             *
      *                                                                *
      * ecrajcli : écran permettant à l’utilisateur de rentrer les     *
      * paramètres nécessaires à la création d’un client.              *
      * Il appelle le sous programme verema et ajucli. Le programme    *
      * verema retourne une valeur d’erreur,il est impératif de la     *
      * traiter et d’afficher les informations sur l'écran.            *
      *                                                                *
      *----------------------------------------------------------------*
      *                           TRIGRAMMES                           *
      *                                                                *
      * ECR=ECRAN; AJ=AJOUT; CLI=CLIENT; EMA=EMAIL, IND=INDICATIF      *
      * TEL=TELEPHONE; COP=CODE POSTAL; VIL=VILLE; ADR= ADRESSE;       *
      * VLR=VALEUR; RTR=RETOUR; TRO=TROP; ARO=AROBASE; PNT=POINT;      *
      * CRG=CROCHET GAUCHE; CRD=CROCHET DROIT; AFF=AFFICHAGE;          *
      * BCL=BOUCLE; PRN=PRINCIPAL(E); SSI=SAISIE; APL=APPEL;           *
      * VER=VERIFICATION; MSG=MESSAGE; ERR=ERREUR; BDD=BASE DE DONNEE; *
      * APP=APPUI; ENT=ENTREE; NTG=NETTOYAGE; ZON=ZONE;                *
      ******************************************************************
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ecrajcli.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 01-07-2025 (fr).

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-ID-CLI                    PIC Z(15).
       01 WS-NOM-CLI                   PIC X(50).
       01 WS-EMA-CLI                   PIC X(50).
       01 WS-IND-CLI                   PIC Z(03).
       01 WS-TEL-CLI                   PIC Z(10).
       01 WS-ADR-CLI                   PIC X(50).
       01 WS-VIL-CLI                   PIC X(50).
       01 WS-COP-CLI                   PIC Z(05).


       01 WS-NTG-ID        PIC X(15) VALUE ALL " ".
       01 WS-NTG-NOM       PIC X(50) VALUE ALL " ".
       01 WS-NTG-EMA       PIC X(50) VALUE ALL " ".
       01 WS-NTG-IND       PIC X(03) VALUE ALL " ".
       01 WS-NTG-TEL       PIC X(10) VALUE ALL " ".
       01 WS-NTG-ADR       PIC X(50) VALUE ALL " ".
       01 WS-NTG-VIL       PIC X(50) VALUE ALL " ".
       01 WS-NTG-COP       PIC X(05) VALUE ALL " ".
       

      * Booléen de contrôle de fin de boucle. 
       01 WS-FIN-BCL           PIC X(01)   VALUE SPACE.
           88 WS-FIN-BCL-OUI               VALUE "O".
           88 WS-FIN-BCL-NON               VALUE "N".

       01 WS-VLR-RTR           PIC 9(01).
           88 WS-RTR-OK                   VALUE 0.
           88 WS-RTR-TRO-DE-ARO           VALUE 1.
           88 WS-RTR-PAS-DE-ARO           VALUE 2.
           88 WS-RTR-PAS-DE-PNT           VALUE 3.
       
       01 WS-CRG               PIC X(01)   VALUE "[".
       01 WS-CRD               PIC X(01)   VALUE "]".
       01 WS-LRR               PIC X(01).
       01 WS-CLR-TXT           PIC 9(01)       VALUE 7. *> Blanc
       01 WS-CLR-FND           PIC 9(01)       VALUE 0. *> Noir
       
       

       SCREEN SECTION.
       
       COPY ecrprn.

       01 S-ECR-AJ-CLI
           FOREGROUND-COLOR WS-CLR-TXT    
           BACKGROUND-COLOR WS-CLR-FND.

           05 LINE 04 COL 03 VALUE "Connecte en tant que :".
           05 LINE 06 COL 25 VALUE "ID du client :".
           05 LINE 06 COL 40 PIC X(01) FROM WS-CRG.
           05 LINE 06 COL 41 PIC Z(15) TO WS-ID-CLI.

           05 LINE 06 COL 56 PIC X(01) FROM WS-CRD.


           05 LINE 08 COL 03 VALUE "Nom :".
           05 LINE 09 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 09 COL 04 PIC X(50) TO WS-NOM-CLI.

           05 LINE 09 COL 54 PIC X(01) FROM WS-CRD.


           05 LINE 10 COL 03 VALUE "Email :".
           05 LINE 11 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 11 COL 04 PIC X(50) TO WS-EMA-CLI.

           05 LINE 11 COL 54 PIC X(01) FROM WS-CRD.


           05 LINE 12 COL 03 VALUE "Indicatif / Telephone :".
           05 LINE 13 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 13 COL 04 VALUE "+".
           05 LINE 13 COL 05 PIC Z(03) TO WS-IND-CLI.
           05 LINE 13 COL 09 PIC Z(10) TO WS-TEL-CLI.
           
           05 LINE 13 COL 19 PIC X(01) FROM WS-CRD.


           05 LINE 14 COL 03 VALUE "Adresse :".
           05 LINE 15 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 15 COL 04 PIC X(50) TO WS-ADR-CLI.

           05 LINE 15 COL 54 PIC X(01) FROM WS-CRD.

           05 LINE 16 COL 03 VALUE "Ville :".
           05 LINE 17 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 17 COL 04 PIC X(50) TO WS-VIL-CLI.

           05 LINE 17 COL 54 PIC X(01) FROM WS-CRD.

           
           05 LINE 18 COL 03 VALUE "Code postal :".
           05 LINE 19 COL 03 PIC X(01) FROM WS-CRG.
           05 LINE 19 COL 04 PIC Z(05) TO WS-COP-CLI.

           05 LINE 19 COL 09 PIC X(01) FROM WS-CRD.

       
           01 S-NTG-ZON-SSI
               FOREGROUND-COLOR WS-CLR-TXT    
               BACKGROUND-COLOR WS-CLR-FND.
               
               05 BLANK SCREEN.
               05 LINE 06 COL 41 PIC X(15) FROM WS-NTG-ID.  *> Efface ID
               05 LINE 09 COL 04 PIC X(50) FROM WS-NTG-NOM.  *> Efface Nom  
               05 LINE 11 COL 04 PIC X(50) FROM WS-NTG-EMA.  *> Efface Email
               05 LINE 13 COL 05 PIC X(03) FROM WS-NTG-IND.  *> Efface Indicatif
               05 LINE 13 COL 09 PIC X(10) FROM WS-NTG-TEL.  *> Efface Téléphone
               05 LINE 15 COL 04 PIC X(50) FROM WS-NTG-ADR.  *> Efface Adresse
               05 LINE 17 COL 04 PIC X(50) FROM WS-NTG-VIL.  *> Efface Ville
               05 LINE 19 COL 04 PIC X(05) FROM WS-NTG-COP.  *> Efface Code postal


       PROCEDURE DIVISION.
           
           PERFORM 0100-BCL-PRN-DEB
              THRU 0100-BCL-PRN-FIN.

           
           EXIT PROGRAM.




      ******************************************************************
      *                         PARAGRAPHES                            * 
      ****************************************************************** 
       0100-BCL-PRN-DEB.

           SET WS-FIN-BCL-NON TO TRUE.

           PERFORM UNTIL WS-FIN-BCL-OUI
               
               

               

               PERFORM 0200-AFF-SSI-ECR-DEB
                  THRU 0200-AFF-SSI-ECR-FIN

           END-PERFORM.
           EXIT.

       0100-BCL-PRN-FIN.

      *----------------------------------------------------------------- 

       0200-AFF-SSI-ECR-DEB.

           DISPLAY S-FND-ECR.
           DISPLAY S-ECR-AJ-CLI.
           ACCEPT S-ECR-AJ-CLI.
           
           PERFORM 0300-APL-VER-EMA-DEB
              THRU 0300-APL-VER-EMA-FIN.
           
           PERFORM 0400-APL-AJ-CLI-BDD-DEB
              THRU 0400-APL-AJ-CLI-BDD-FIN.

      *    DISPLAY S-NTG-ZON-SSI.
           
           
           EXIT.
       
       0200-AFF-SSI-ECR-FIN.

      *----------------------------------------------------------------- 

       0300-APL-VER-EMA-DEB.

           CALL "verema" USING WS-EMA-CLI 
                               WS-VLR-RTR
           END-CALL.
           
           PERFORM 0350-MSG-ERR-DEB
              THRU 0350-MSG-ERR-FIN.

           EXIT.
           
       0300-APL-VER-EMA-FIN.

      *----------------------------------------------------------------- 
       
       0350-MSG-ERR-DEB.
           
           EVALUATE TRUE 
               
               WHEN WS-RTR-TRO-DE-ARO 
                   DISPLAY "Cet email comporte trop d'@"
                   AT LINE 22 COL 03
                   
                   PERFORM 0355-APP-ENT-DEB
                      THRU 0355-APP-ENT-FIN

               WHEN WS-RTR-PAS-DE-ARO
                   DISPLAY "Cet email ne comporte pas d'@"
                   AT LINE 22 COL 03
                   
                   PERFORM 0355-APP-ENT-DEB
                      THRU 0355-APP-ENT-FIN

               WHEN WS-RTR-PAS-DE-PNT
                   DISPLAY "Cet email ne comporte pas de point"
                   AT LINE 22 COL 03
                   
                   PERFORM 0355-APP-ENT-DEB
                      THRU 0355-APP-ENT-FIN

               WHEN WS-RTR-OK 
                   DISPLAY "Email valide"
                   AT LINE 22 COL 03
                   
                   PERFORM 0355-APP-ENT-DEB
                      THRU 0355-APP-ENT-FIN

           END-EVALUATE. 


           EXIT.

       0350-MSG-ERR-FIN.

      *----------------------------------------------------------------- 
       0355-APP-ENT-DEB.
           
           DISPLAY "Appuyez sur entree"
           AT LINE 23 COL 03. 

           ACCEPT WS-LRR 
           AT LINE 23 COL 21.

           EXIT.
       0355-APP-ENT-FIN.
      *----------------------------------------------------------------- 
       
       0400-APL-AJ-CLI-BDD-DEB.

           CALL "ajucli" USING WS-NOM-CLI
                               WS-EMA-CLI
                               WS-IND-CLI
                               WS-TEL-CLI
                               WS-COP-CLI
                               WS-VIL-CLI
                               WS-ADR-CLI

           END-CALL.


           EXIT.

       0400-APL-AJ-CLI-BDD-FIN.
