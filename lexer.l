%{
  #include "y.tab.h"
  
  #include <stdlib.h>
  int lineNumber = 1;
  int ErrorCount1 = 0;
%}

DIGIT [0-9]
LETTER [A-Za-z]
NUM_OPERATOR ["+""-""*""/"]
COMMA ","
QUOTES \"
DOT "."
OPEN \(
CLOSE \)

EQUAL "="
NUMBER ("-"*)({DIGIT}+)({DIGIT}*)(".")*({DIGIT}*)
IDEN ({LETTER}+)("_")*({LETTER}*)({DIGIT}*)
STRING {QUOTES}({IDEN}*){QUOTES}

%%
(?i:insert)   return INSERT; 
(?i:into)      return INTO; 
(?i:values)      { printf("<VALUES>\n");return VALUES;}
(?i:table)      return TABLE;
(?i:default)     { printf("<DEFAULT>\n");return DEFAULT;}
(?i:intersect)   { printf("<INTERSECT>\n");return INTERSECT;}
(?i:corresponding) { printf("<CORRESPONDING>\n") ;return CORRESPONDING;}
(?i:by)        { printf("<BY>\n") ;return BY; }
(?i:null)        return NULLL; 
(?i:union)      {printf("<UNION>\n") ;return UNION; }
(?i:except)     { printf("<EXCEPT>\n") ;return EXCEPT; } 
{NUMBER}     return NUMBER;
{IDEN}         return IDEN;
{COMMA}        return COMMA; 
{QUOTES}       return QUOTES; 
{DOT}          return DOT; 
{CLOSE}        return CLOSE; 
{OPEN}         return OPEN; 
{EQUAL}        return EQUAL; 
{STRING}       return STRING;
{NUM_OPERATOR} return NUM_OPERATOR;

[\r\t ]            { ;} 
"\n"             { lineNumber ++;}
.               {printf("\nERROR ! Unknown character %s in line %i\n", yytext, lineNumber); ErrorCount1++;} 
%%
int yywrap(void) {
 return 1;
}