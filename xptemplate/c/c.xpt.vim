XPTemplate priority=lang-1



XPTinclude
      \ _common/common


XPT main2	" Expands default main
#include <stdio.h>

int main()
{
    return 0;
}
"printf(`$SParg^`:_printfElts:^`$SParg^)

