
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
int yylex(void);
   
void yyerror(char *);
int lineNumber;
int ErrorCount1;
int ErrorCount2 = 0;
%} 

%token NUMBER
%token IDEN 
%token STRING 
%token NULLL
%token DEFAULT    
%token NES_SPACE   
%token UNNES_SPACE 
%token DELIMITER   
%token DIGIT       
%token LETTER     
%token INSERT   
%token INTO        
%token VALUES   
%token TABLE   
%token INTERSECT   
%token CORRESPONDING 
%token BY          
%token UNION       
%token EXCEPT      
%token COMMA       
%token QUOTES 
%token DOT 
%token CLOSE       
%token OPEN        
%token EQUAL       
%token NUM_OPERATOR

%%


MAIN_QUERTY:
         CHECK_INSERT_INTO_TABLE CHECK_LIST_FIELD QUERY_EXPRESSION
         {printf(" <-- MAIN QUERTY -->\n");}
         |
         CHECK_INSERT_INTO_TABLE CHECK_DEFAULT_VALUES
         {printf(" <-- MAIN QUERTY -->\n");}
         ;


CHECK_DEFAULT_VALUES:
         DEFAULT VALUES
         |
         error VALUES
         {yyerror("Пропущено выражение 'DEFAULT'!");}
         |
         DEFAULT error
         {yyerror("Пропущено выражение 'VALUES'!");}
         ;


CHECK_INSERT_INTO_TABLE:
        CHECK_INSERT_INTO CHECK_TABLE_NAME
        |
        CHECK_INSERT_INTO error
        {yyerror("Пропущено название таблицы!");}
        ; 



CHECK_INSERT_INTO:
        INSERT INTO
        {printf("<INSERT INTO>\n");}
        |
        INSERT error
        {yyerror("Пропущено выражение 'INTO'!");}
        |
        error INTO
        {yyerror("Пропущено выражение 'INSERT'!");}
        ;


CHECK_TABLE_NAME:
        TABLE IDEN
        {printf("<TABLE>\n"); printf("<IDEN>\n");}
        |
        TABLE error
        {yyerror("Пропущено название таблицы!");}
        ;


QUERY_EXPRESSION:
        QUERY_TERM
        |
        QUERY_TERM UNION QUERY_TERM
        |
        QUERY_TERM UNION yCORRESPONDING QUERY_TERM
        |
        QUERY_TERM EXCEPT QUERY_TERM
        |
        QUERY_TERM EXCEPT yCORRESPONDING QUERY_TERM
        |
        QUERY_TERM error QUERY_TERM
        {yyerror("Пропущено действие с запросами!");}
        |
        error UNION QUERY_TERM
        {yyerror("Пропущено выражение запроса!");}
        |
        error EXCEPT QUERY_TERM
        {yyerror("Пропущено выражение запроса!");}
        ;


QUERY_TERM:
       yTABLE
       |
       yTABLE INTERSECT yTABLE
       |
       yTABLE INTERSECT yCORRESPONDING yTABLE
       ;


yCORRESPONDING:
      CORRESPONDING BY CHECK_LIST_FIELD
      |
      CORRESPONDING error CHECK_LIST_FIELD
      {yyerror("Пропущено выражение 'BY'!");}
      |
      CORRESPONDING BY error
      {yyerror("Пропущен список полей!");}
      ;
      

yTABLE:
      VALUES CHECK_LIST_VALUE
      | 
      TABLE IDEN
      {printf("<TABLE>\n"); printf("<IDEN>\n");}
      ; 


CHECK_LIST_VALUE:
       OPEN LIST_VALUE CLOSE
       {printf("<VALUES LIST>\n");}
       |
       OPEN LIST_VALUE error
       {yyerror("Пропущена закрывающая скобка в списке значений! Завершение анализа выражения!"); 
        exit(1);}
       |
       error LIST_VALUE CLOSE
       {yyerror("Пропущена открывающая скобка в списке значений!");}
       |
       error LIST_VALUE error
       {yyerror("Пропущены скобки в списке значений!");}



LIST_VALUE:
      VALUE
      |
      LIST_VALUE COMMA VALUE
      ;


VALUE:
      STRING
      |
      NUM_EXPRESSION
      |
      NULLL
      |
      DEFAULT
       ; 


NUM_EXPRESSION:
     NUMBER
     |
     NUMBER NUM_OPERATOR NUM_EXPRESSION
     ;


CHECK_LIST_FIELD:
       OPEN LIST_FIELD CLOSE
       {printf("<FIELD LIST>\n");}
       |
       OPEN LIST_FIELD error
       {yyerror("Пропущена закрывающая скобка в списке полей! Завершение анализа выражения!"); 
        exit(1);}
       |
       error LIST_FIELD CLOSE
       {yyerror("Пропущена открывающая скобка в списке полей!");}
       |
       OPEN error CLOSE
       {yyerror("Пропущен список полей!");}
       |
       error LIST_FIELD error
       {yyerror("Пропущены скобки в списке полей!");}
       ;


LIST_FIELD:
       IDEN
       |
       IDEN COMMA IDEN
       |
       IDEN COMMA IDEN COMMA IDEN
       ;


%%

void yyerror(char *s) 
{
 fprintf(stderr, "Ошибка в строке %i : %s\n", lineNumber, s);
 ErrorCount2++;
}


int main(void)
{
 yyparse();
printf("Количество ошибок, обнаруженных лексическим анализатором = %i ; \n", ErrorCount1);
printf("Количество ошибок, обнаруженных синтаксическим анализатором = %i ; \n", ErrorCount2);
if(ErrorCount1 == 0 && ErrorCount2 == 0)
{
    printf("Успешное завершение анализа!!!\n"); 
}
else
{
    printf("Неудачное завершение анализа!!!\n");
}
return 0;
}
