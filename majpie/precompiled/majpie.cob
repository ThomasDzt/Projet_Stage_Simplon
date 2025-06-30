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
      * TYP=TYPE; CHG=CHANGEMENT; AJT=AJOUT; RTI=RETRAIT; RSU=RESULTAT *
      * AFC=AFFECTATION; VAR=VARIABLE; SLC=SELECTION; VRT=VARIANTE     *
      * CHX=CHOIX; NVL=NOUVELLE; INS=INSERTION;                        *
      ******************************************************************
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. majpie.
       AUTHOR. ThomasD.
       DATE-WRITTEN. 27-06-2025 (fr).

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * Déclaration des variables correspondant aux attributs  
      * id_pie et qt_pie de la table piece.

OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 PG-IDF-PIE           PIC 9(10).
       01 PG-QTE-PIE           PIC 9(10).

      * Déclaration du booléen correspondant au choix de l'opération
      * sur le stock de pièces. 
       01 PG-TYP-CHG           PIC 9(01).
           88 PG-AJT                       VALUE 0.
           88 PG-RTI                       VALUE 1.
           

      * Déclaration de la variable, correspondant à la quantité à 
      * ajouter ou à soustraire au stock, que doit saisir l'utilisateur.   

       01 PG-QTE-VRT           PIC 9(10).

OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.
       
OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

      
       
      * Déclaration de la variable correspondant au résultat de 
      * l'opération sur la quantité de pièces dans le stock.

       01 WS-QTE-RSU           PIC 9(10).

OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(042) VALUE "SELECT id_pie FROM piece WHERE"
OCESQL  &  " id_pie = $1".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
OCESQL 01  SQ0002.
OCESQL     02  FILLER PIC X(046) VALUE "UPDATE piece SET qt_pie = $1 W"
OCESQL  &  "HERE id_pie = $2".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       LINKAGE SECTION.
      * Arguments d'entrée.
       01 LK-IDF-PIE           PIC 9(10).
       01 LK-QTE-PIE           PIC 9(10).
       01 LK-TYP-CHG           PIC 9(01).
           88 LK-AJT                       VALUE 0.
           88 LK-SUP                       VALUE 1.

       01 LK-QTE-VRT           PIC 9(10).
       

       PROCEDURE DIVISION USING LK-IDF-PIE,
                                LK-QTE-PIE,
                                LK-TYP-CHG
                                LK-QTE-VRT.

           
           PERFORM 0100-AFC-VAR-DEB
              THRU 0100-AFC-VAR-FIN.
           
           PERFORM 0200-SLC-PIE-DEB
              THRU 0200-SLC-PIE-FIN.

           PERFORM 0300-CHX-TYP-CHG-DEB
              THRU 0300-CHX-TYP-CHG-FIN.
           
           PERFORM 0400-INS-NVL-QTE-DEB
              THRU 0400-INS-NVL-QTE-FIN.

           EXIT PROGRAM.


      ******************************************************************
      *                         PARAGRAPHES                            * 
      ******************************************************************

       0100-AFC-VAR-DEB.

           MOVE LK-IDF-PIE 
           TO   PG-IDF-PIE.

           MOVE LK-QTE-PIE 
           TO   PG-QTE-PIE.

           MOVE LK-TYP-CHG 
           TO   PG-TYP-CHG.
           
           MOVE LK-QTE-VRT 
           TO   PG-QTE-VRT.

           EXIT.
       0100-AFC-VAR-FIN.

      *-----------------------------------------------------------------

       0200-SLC-PIE-DEB.

OCESQL*    EXEC SQL 
OCESQL*        SELECT id_pie
OCESQL*        INTO   :PG-IDF-PIE
OCESQL*        FROM   piece
OCESQL*        WHERE  id_pie = :PG-IDF-PIE
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetResultParams" USING
OCESQL          BY VALUE 1
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-IDF-PIE
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 1
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-IDF-PIE
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecSelectIntoOne" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL          BY VALUE 1
OCESQL          BY VALUE 1
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.

           EXIT.
       0200-SLC-PIE-FIN.

      *-----------------------------------------------------------------
       
       0300-CHX-TYP-CHG-DEB.

           IF PG-AJT
               COMPUTE WS-QTE-RSU = PG-QTE-PIE + PG-QTE-VRT  
               DISPLAY WS-QTE-RSU
               
               PERFORM 0350-NVL-QTE-PIE-DEB
                  THRU 0350-NVL-QTE-PIE-FIN

           ELSE
               COMPUTE WS-QTE-RSU = PG-QTE-PIE - PG-QTE-VRT    
               DISPLAY WS-QTE-RSU
               PERFORM 0350-NVL-QTE-PIE-DEB
                  THRU 0350-NVL-QTE-PIE-FIN

           END-IF.
       
           EXIT.
       0300-CHX-TYP-CHG-FIN.

      *-----------------------------------------------------------------
       
       0350-NVL-QTE-PIE-DEB.
           
           MOVE WS-QTE-RSU 
           TO   PG-QTE-PIE.
           DISPLAY PG-QTE-PIE.

           EXIT.
       0350-NVL-QTE-PIE-FIN.

      *-----------------------------------------------------------------
       
       0400-INS-NVL-QTE-DEB.

OCESQL*    EXEC SQL
OCESQL*        UPDATE piece
OCESQL*        SET qt_pie = :PG-QTE-PIE
OCESQL*        WHERE id_pie = :PG-IDF-PIE
OCESQL*    END-EXEC.    
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 1
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-QTE-PIE
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 1
OCESQL          BY VALUE 10
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE PG-IDF-PIE
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0002
OCESQL          BY VALUE 2
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.

           IF SQLCODE = 0
              DISPLAY SQLCODE 
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
              DISPLAY SQLCODE
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
           
           EXIT.
       0400-INS-NVL-QTE-FIN.



