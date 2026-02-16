#include <stdlib.h>
#include <string.h>
#include <unistd.h>
int main(int argc, char *argv[]) { 
   char buffer[5]; 
   strcpy(buffer, argv[1]); 
   return 0; 
} 
