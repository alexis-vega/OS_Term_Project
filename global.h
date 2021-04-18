#include "stdbool.h"
#include <stdio.h>
#include <limits.h>

struct evTable {
   char var[128][100];
   char word[128][100];
};

struct aTable {
	char name[128][100];
	char word[128][100];
};

char cwd[PATH_MAX];

struct evTable varTable;

struct aTable aliasTable;

int aliasIndex, varIndex;

char* subAliases(char* name);

struct Command{
    int argSize;
	char* command;
	char* input;
	char* output;
   char* args[];
};

struct Pipeline{
   bool isBackgrounded;
   int listSize;
	struct Command  list[];
};

//Can't instantiate statically
struct Pipeline * commandTable;
int commandIndex;
size_t commandTableSize;