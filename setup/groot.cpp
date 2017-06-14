#include <cstdlib>
#include <cstdio>
#include <cstring>

using namespace std;

int hex_to_tet () {
  char c[16], f[33];
  unsigned long long t;
  char *fp;
  int len;
  while (scanf("%15s", c) != EOF) {
    len = strlen(c);
    t = strtoll(c, NULL, 16);
    fp = f + 32; *fp = '\0'; fp--;
    while (fp >= f) {
      *fp = t % 4 + '0';
      t >>= 2; fp--;
    }
    printf("%s", f + 32 - 2*len);
  }
  return 0;
}

int tet_to_hex () {
  char c[31], f[16], a[2];
  unsigned long long t;
  char *fp;
  int len;
  while (scanf("%30s", c) != EOF) {
    len = strlen(c);
    t = strtoll(c, NULL, 4);
    fp = f + 15; *fp = '\0'; fp--;
    while (fp >= f) {
      sprintf(a, "%1x", unsigned(t % 16));
      *fp = *a; t >>= 4; fp--;
    }
    printf("%s", f + 15 - len/2);
  }
  return 0;
}

int main (int argc, char *argv[]) {
  if (argc == 1) {
    return hex_to_tet();
  }
  if (argc == 2 && strncmp(argv[1], "-d", 2) == 0) {
    return tet_to_hex();
  }
  printf("usage: %s [-d]\n", argv[0]);
  return 1;
}
