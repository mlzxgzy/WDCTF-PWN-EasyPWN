#include <stdio.h>

int main()
{
  char s[20];

  puts("please input!");


  gets(&s);
  puts(&s);
  puts("OK!,ByeBye!!HAHA");
  return 0;
}
void shell(){
  system("/bin/sh");
}
