###############################################################################
##                                                                           ##
##  This is a generalized makefiles made to be used on different kind        ##
##  of projects, such as making libraries , source files etc.                ##
##  Please note that to use this make files you need to posses the `.misc`   ##
##  directory that is included in the repo by default. This path is needed   ##
##  as some files used by make files are included there. Do change anything  ##
##  dependeing on your need.                                                 ##
##                                                                           ##
##  In the file `color` located in `.misc/make` you can find terminal escape ##
##  codes for colors arr or remove or eddid to get result as you want.       ##
##                                                                           ##
##                                                                           ##
##  In the file `path` located in `.misc/make` information about varius paths##
##  are included for to make this Makefile easier and to manage the make file##
##  More easily.                                                             ##
##                                                                           ##
###############################################################################


## Please do not remove the includes
## as they contain impoirtent information
## variables and rules

include .misc/make/color
include .misc/make/paths
include .misc/make/misc_var

## Te `.SILENT` launche evrything specified in
## silent mode so you dont have to put the `@`
.SILENT	: __START NAME clean fclean all re object library os_dep
.PHONY	: __START NAME clean fclean all re object library os_dep


## This is launched if no param given
.DEFAULT_GOAL = __START

## Project name (will be used)
PROJECT =

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
## Start making here
__START:
	 printf "$(OK)[+] Done$(C_DEF)"

$(NAME):	library

## Clean objects and others
clean:		$(OBJ_P)
	rm		-f	$(OBJ_P)
	echo	-e	"$(WARN)[!] Removed all objects from ./$(P_OBJ)$(C_DEF)"
	echo	-e	"$(OK)[+] Cleaned$(C_DEF)"

## Cleans everything
fclean:		clean
	rm		-f	$(OBJ_W)
	echo	-e	"$(WARN)[!] Removed all binary ./$(P_BIN)$(C_DEF)"
	echo	-e	"$(OK)[+] Fully cleaned$(C_DEF)"

re:			fclean all

## This function creat object files from sources.
## It treates the string of large source names as
## individual names, when it creat objects it do
## not gives al the names in the same time to gcc
## but one by one.
object:		$(SRC) $(P_SRC) $(P_OBJ)
	$(foreach SOURCE ,$(SRC), \
		$(CC) $(CC_FLAG) -c $(SOURCE) -o $(P_OBJ)/$(notdir $(SOURCE:.c=.o))	&& \
		printf "$(OK)[+] $(SOURCE)$(C_DEF)" && sleep $(SLEEP)	&& \
		printf "\r" \
	;)
	echo 	-e "$(OK)[+] Objects are made in ./$(P_OBJ)$(C_DEF)"

## Make the actual library (archive)
library:	object $(P_OBJ) $(OBJ_P)
	echo 	-e "$(WARN)[!] Creating archive $(LIB_A)$(OS_CHK)"
	@ar rc $(LIB_A) $(OBJ_P)
	echo 	-e "$(WARN)[!] Generating index in $(LIB_A)$(OS_CHK)"
	@ranlib $(LIB_A)
	echo 	-e "$(OK)[+] The $(LIB_A) library was made$(C_DEF)"



## This rule is called when a difference in operating sistem has been
## detected. You can put your prerequisite to be changed if a different
## os has been detected
os_dep: #put your prerequisite for os dependent stufs
	## put your os dependent comands here
	## this will be launched if the os name is 
	## different then what read from the os file.
	## ex: make re
	echo "Os dependent stufs"

## Useful Makefile tricks
##
## ?= 			// let you put a default variable then later change it
## j<number>	// let you launche the number of job at the same time
## ifdef		// let you verify if used defined something or not
## .SILENT		// This parameter let you launch rules in silent mod
## .IGNORE		// Ignore parameter used as .SILENT
#
## --stop-on-faliur			// stop the program if error occures
## -k or --keep-going		// To keep ignoring all errors
## -i or --ignore-errors	// To Ignor error
## --no-print-directory		// This do not show the 'entered ... directory' warning
