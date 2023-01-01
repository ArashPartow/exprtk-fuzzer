#include <iostream>
#include <string>

#include "exprtk.hpp"

int main()
{
   std::string expression_string;

   if (!std::getline(std::cin,expression_string))
   {
      return 0;
   }

   typedef exprtk::symbol_table<double> symbol_table_t;
   typedef exprtk::expression<double>   expression_t;
   typedef exprtk::parser<double>       parser_t;

   expression_t expression;
   symbol_table_t symbol_table;
   parser_t parser;

   double a = 1.1;
   double b = 2.2;
   double c = 3.3;
   double x = 2.123456;
   double y = 3.123456;
   double z = 4.123456;
   double w = 5.123456;

   symbol_table.add_variable("a", a);
   symbol_table.add_variable("b", b);
   symbol_table.add_variable("c", c);

   symbol_table.add_variable("x", x);
   symbol_table.add_variable("y", y);
   symbol_table.add_variable("z", z);
   symbol_table.add_variable("w", w);

   expression.register_symbol_table(symbol_table);

   parser.compile(expression_string,expression);

   return 0;
}
