XPTemplate priority=personal

XPTinclude
      \ _common/common


XPT main	" Expands default main
#include <stdio.h>
/* `comment^ */
int main(void) {
    `content^ 
    return 0;
}
"printf(`$SParg^`:_printfElts:^`$SParg^)

