include .misc/makefile_color

## Te `.SILENT` launche evrything specified in
## silent mode so you dont have to put the `@`
.SILENT : clean all fclean re object library

## This is launched if no param given
.DEFAULT_GOAL = all


## compiler related
CC		?=	clang 		## default compiler is clang
CC_FLAG ?=	-Werror \
			-Wall	\
			-Wextra

## some useful `flags` for memory verifications
##
## -O1 -g -fsanitize=address	\
## -fno-omit-frame-pointer		\
## -fsanitize-address-use-after-scope \


## binary, library etc...
MAIN	?=	main.c
NAME	?=	one 		## The name of your binary

#The name of the library you want to make
LIB_A	?=	one.a

## Path related
P_BIN	?=	bin
P_LIB	?=	lib
P_OBJ	?=	obj
P_SRC	?=	src
P_RES	?=	res
P_TEST	?=	test
P_MISC	?=	.misc


## sources and objects where path names are removed.
## Add all your source files to this variable
SRC		=	src/a.c \
			src/b.c \
			src/c.c \
			src/d.c \
			src/e.c \
			src/f.c

## Objects without path names
OBJ		:=	$(notdir $(SRC:.c=.o))

## Objects with their path name
OBJ_P	=	$(addprefix $(P_OBJ)/,$(OBJ))	## addprefix add the 
											## path name to the files...

## other information and functionality
SLEEP	?=	0.25	## This value is used to sleep
					## the shell for a certain second.
					## For decoration purpose

OS		=	$(shell uname -s)
OS_CHK	=	$(shell cat $(P_MISC)/os)


all:
	echo	-e	"$(WARN)[!] This is a default make file, pls modify it$(C_DEF)"

## This function creat object files from sources.
## It treates the string of large source names as
## individual names, when it creat objects it do
## not gives al the names in the same time to gcc
## but one by one.

object:		$(SRC)
	$(foreach SOURCE ,$(SRC), \
		$(CC) $(CC_FLAG) -c $(SOURCE) -o $(P_OBJ)/$(notdir $(SOURCE:.c=.o))	&& \
		printf "$(OK)[+] $(SOURCE)$(C_DEF)" && sleep $(SLEEP)	&& \
		printf "\r" \
	;)
	echo 	-e "$(OK)[+] Objects are made in ./$(P_OBJ)$(C_DEF)"

## Make the actual library (archive)
library:	object $(OBJ_P)
	echo 	-e "$(WARN)[!] Creating archive $(LIB_A)$(OS_CHK)"
	@ar rc $(LIB_A) $(OBJ_P)
	echo 	-e "$(WARN)[!] Generating index in $(LIB_A)$(OS_CHK)"
	@ranlib $(LIB_A)
	echo 	-e "$(OK)[+] The $(LIB_A) library was made$(C_DEF)"
## Clean objects and others
clean:		$(OBJ_P)
	rm		-f	$(OBJ_P)
	echo	-e	"$(WARN)[!] Removed all objects from ./$(P_OBJ)$(C_DEF)"
	echo	-e	"$(OK)[+] Cleaned$(C_DEF)"

## Cleans everything
fclean:		clean
	rm		-f	$(P_BIN)/$(NAME)
	echo	-e	"$(WARN)[!] Removed all binary ./$(P_BIN)$(C_DEF)"
	echo	-e	"$(OK)[+] Fully cleaned$(C_DEF)"


## 
## re:

.PHONY: clean fclean all re object library

## Useful Makefile tricks
# ?= 		// let you put a default variable then later change it
# j<number>	// let you launche the number of job at the same time
# ifdef		// let you verify if used defined something or not
# .SILENT	// This parameter let you launch rules in silent mod
# .IGNORE	// Ignore parameter used as .SILENT

# --stop-on-faliur		// stop the program if error occures
# -k or --keep-going	// To keep ignoring all errors
# -i or --ignore-errors	// To Ignor error
