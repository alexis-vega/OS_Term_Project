%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "global.h"

extern char** environ;
extern int yylineno;

//Command Array Functions
int addToArray(char* op, char** argv, int argc, char* in, char* out);
void execute(void);

int yylex(void);
int yyerror(char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
int runSetENV(char * variable, char * word);
int runPrintENV();
int runUnsetENV(char * variable);
int runUnalias(char * name);
void runLS(void);
int runEcho(char * str);
void getPWD(void);

%}

%union {
	char *string;
}

%start cmds
%token <string> BYE CD STRING ALIAS UNALIAS END SETENV PRINTENV UNSETENV LS ECHOO PWD PIPE
%%

cmds :
	cmd_line END						{return 1;}
	| cmd_line PIPE cmd_line END		{return 1;}
	;

cmd_line :
	BYE   		                {exit(1);}
	| CD STRING         		{
								runCD($2);
								}
	| LS 						{runLS();}
	| ALIAS STRING STRING 		{runSetAlias($2, $3);}
	| UNALIAS STRING 			{runUnalias($2);}
	| SETENV STRING STRING 		{runSetENV($2, $3);}
	| PRINTENV 					{runPrintENV();}
	| UNSETENV STRING 			{runUnsetENV($2);}
	| ECHOO STRING 				{runEcho($2);}
	| PWD 						{getPWD();}
	;

%%

void execute(void){
	//If theres only one command
	if(commandIndex == 1){
		//Get opcode
		char * opcode = commandTable->list[0].command;
		//Check built ins
		if(strcmp(opcode, "cd") == 0){
			runCD(commandTable->list[0].args[0]);
		}
		else {
			printf("Opcode: %s\terror\n", opcode);
		}
	}
}

int addToArray(char* op, char** argv, int argc, char* in, char* out){
	//Create new command struct
	struct Command * c = malloc(sizeof(struct Command));
	c->command = op;
	
	c->input = in;
	c->output = out;
	//c.args = argv;

	//Size of the entire command struct and the flexable array member (list)
	size_t size = sizeof(*c);
	
	for(int i=0; i<argc; i++){
		c->args[i] = malloc(sizeof(argv[i]));
		memcpy(c->args[i], argv[i], sizeof(argv[i]));

		size += sizeof(char) * strlen(c->args[i]);

		//printf("argnum %d: %s\n",i , c->args[i]);
	}
	
	
	//commandTable->list = realloc(commandTable->list), sizeof(commandTable->list) + sizeof(*c));
	//memcpy(&(commandTable->list[commandIndex++]), c, sizeof(*c));

	

	// Add a new command pointer to the list
	//commandTable->list[commandIndex] = malloc(sizeof(commandTable->list[commandIndex]) + sizeof(*c) + sizeof(char) * strlen(c->))

	//Make a new table
	

	//Add command size to command table size
	// commandTableSize += size;
	// commandTable->list = realloc(commandTable->list, commandTableSize+1);
	// commandTable->list[commandIndex] = *c;
	// commandIndex++;

	//Alocate command entry to empty and copy
	//commandTable->list = realloc(sizeof(commandTable->list) size);
	//memcpy(commandTable->list[commandIndex], c, size);
	//commandTable->list[commandIndex] = *c;
	

	//printf("%s is argument0\n", (commandTable->list[commandIndex - 1]->args[0]));
}

int yyerror(char *s) {
  printf("ERROR: %s\n",s);
  return 0;
  }

int runCD(char* arg) {
	if (arg[0] != '/') {
		// arg is relative path
		strcat(varTable.word[0], "/");
		strcat(varTable.word[0], arg);

		if(chdir(varTable.word[0]) == 0) {
			return 1;
		}
		else {
			getcwd(cwd, sizeof(cwd));
			strcpy(varTable.word[0], cwd);
			printf("Directory not found\n");
			return 1;
		}
	}
	else { // arg is absolute path
		if(chdir(arg) == 0){
			strcpy(varTable.word[0], arg);
			return 1;
		}
		else {
			printf("Directory not found\n");
                       	return 1;
		}
	}
}

int runSetAlias(char *name, char *word) {
	for (int i = 0; i < aliasIndex; i++) {
		if(strcmp(name, word) == 0){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if(strcmp(aliasTable.name[i], name) == 0) {
			strcpy(aliasTable.word[i], word);
			return 1;
		}
	}
	strcpy(aliasTable.name[aliasIndex], name);
	strcpy(aliasTable.word[aliasIndex], word);
	aliasIndex++;

	return 1;
}

int runSetENV(char * variable, char * word){
	setenv(variable, word, 1);
	return 1;
}

int runPrintENV(){
	char **var;
    for(var=environ; *var!=NULL;++var)
        printf("%s\n",*var);
	return 1;
}

int runUnsetENV(char * variable){
	unsetenv(variable);
	return 1;
}

//Not working (or does alias not work?)
int runUnalias(char * name){
	for(int i=0; i < 128; i++){
		if(strcmp(aliasTable.name[i], name) == 0){
			strcpy(aliasTable.name[i], "");
			strcpy(aliasTable.word[i], "");
			return 1;
		}
	}
	fprintf(stderr, "error at line %d: alias not found for %s\n", yylineno, name);
	return 0;
}

void runLS(void){
	system("ls");
}

//Need to fix so that spaces can be included in a string
int runEcho(char * str){
	printf("%s\n", str);
}

void getPWD(void){
	char cwd[PATH_MAX];
	if (getcwd(cwd, sizeof(cwd)) != NULL) {
		printf("Current working dir: %s\n", cwd);
	} else {
		perror("getcwd() error");
	}
}

