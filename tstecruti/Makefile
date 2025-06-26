# À noter que le Makefile est en anglais pour la seule et unique raison que la règle principale est forcément "all", donc on reste cohérent.

# Dossiers
SRC_FOLDER = srcs/
PRECOMPILED_FOLDER = precompiled/
LIBS_FOLDER = libs/
COPYBOOKS_FOLDER = $(SRC_FOLDER)Copybooks

# Binaire final.
BIN = tstcreut

# Spécifier le point d'entrée.
MAIN_SRC = $(SRC_FOLDER)$(BIN).cbl
# Récupérer tousl les .cbl du dossier SRC.
ALL_SRC = $(shell find $(SRC_FOLDER) -type f -name '*.cbl')
# Enlève le point d'entrée de la liste des sources, étant donné qu'il est compilé à part.
SRC = $(filter-out $(MAIN_SRC), $(ALL_SRC))

# Génère le nom du point d'entrée précompilé.
MAIN_PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(PRECOMPILED_FOLDER)%.cob, $(MAIN_SRC))
# Génère les nom des fichiers précompilés dans le dossiers objet (srcs/foo.cbl -> objects/foo.cob).
PRECOMPILED = $(patsubst $(SRC_FOLDER)%.cbl, $(PRECOMPILED_FOLDER)%.cob, $(SRC))

# Librairies partagées (exemple : objects/foo.so).
LIBS = $(patsubst $(PRECOMPILED_FOLDER)%.cob, $(LIBS_FOLDER)%.so, $(PRECOMPILED))

# Exporte le chemin vers les librairies locales, pour permettre le linkage au runtime.
export COB_LIBRARY_PATH := libs
# Exporte le chemin vers sqlca, il ne peut pas simplement être mis dans les Copybooks, étant donné qu'il s'appelle .cbl et non .cpy, il serait récupéré et compilé par le Makefile.
export COBCPY := sqlca

# Règle principale, par défaut.
all: $(BIN) $(LIBS)
	./$(BIN)

# Empêche le makefile de considérer les .cob comme des fichiers intermédiaires, comme ils sont parfois utiles pour débug.
.SECONDARY: $(PRECOMPILED) $(MAIN_PRECOMPILED)

# Règle pour compiler le point d'entrée.
$(BIN): $(MAIN_PRECOMPILED)
	cobc -x -locesql $(MAIN_PRECOMPILED) -o $(BIN) -I srcs/Copybooks

# Règle pour précompiler les .cob à partir des .cbl avec ocesql.
$(PRECOMPILED_FOLDER)%.cob: $(SRC_FOLDER)%.cbl
	@mkdir -p $(dir $@)
	ocesql $< $@

# Règle pour compiler les librairies dynamiques à partir des précompilés.
$(LIBS_FOLDER)%.so: $(PRECOMPILED_FOLDER)%.cob
	@mkdir -p $(dir $@)
	cobc -m -locesql $< -o $@ -I srcs/Copybooks

# Règle pour installer la structure de base du projet.
install:
	@mkdir -p $(SRC_FOLDER) $(COPYBOOKS_FOLDER) $(PRECOMPILED_FOLDER) $(LIBS_FOLDER) input output
	cp hooks/commit-msg .git/hooks/commit-msg

# Nettoie tous les fichiers générés.
clean:
	rm -rf $(OBJECT_FOLDER) $(PRECOMPILED_FOLDER) $(LIBS_FOLDER) $(BIN)
