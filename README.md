# Hayden Menge Alexis Vega Term Project
This project involved writing a shell to operate in C using Lex and Yacc capable of handling both built-in and external commands.

Although the functionality of the shell is not complete, we both worked on the built-in commands as the foundation. Our designs initially differed but we decided to consolidate the efforts with a single implementation. Hayden was also able to configure the environmental variable expansion, as we;; as the Tilde expansion. Alexis was responsible for the writing of the README file.  

## Included
- Built in commands
- Aliasing and infinite alias expansion check
- Error handling with stderr, uses yylineno
- Env expansion
- Tilde expansion

## Missing
- IO redirection 
- wildcard matching
- unlimited pipes
- & backgrounding
- Filename completion

## Functionality
- Built-In Commands
  - cd word : changes directory to word
  - alias name word : adds an alias to the shell
  - unalias name : removes an alias
  - alias : lists the aliases
  - setenv var word : creates a variable of type var named word
  - printenv : prints all environment variables and their values 
  - unsetenv variable : removes binding of variable
  - bye : exits the shell
  
 - Environment Variable Expansion
 Allows the usage of environment variables iside of command lines. 
