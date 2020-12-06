#include <stdio.h>
#include <stdlib.h>

#define BUF_SZ 100

int solvep(int a, int b) {
    if (a + b == 2020) return 1;
    return 0;
}

void rewindto(FILE *fp, int ln) {
    rewind(fp);
    char c[BUF_SZ];
    for (int i=0; i<ln; i++)
        fgets(c, BUF_SZ, fp);
}

/* this sucks lol */
int main(int argc, char *argv[]) {
    FILE *fp = fopen("input", "r");
    if (fp == NULL) exit(1);

    char buf[BUF_SZ];
    int ln = 1;
    int linea = 0;
    int lineb;
    int solution;

    // Get linecount
    int lines = 0;
    while (fgets(buf, BUF_SZ, fp) != NULL) lines++;
    
    /* For each line, try to solve for all lines after */
    for (int i = 0; i < lines; i++) {
        // Read from ln i
        rewindto(fp, i);

        fgets(buf, BUF_SZ, fp);
        linea = atoi(buf);
        for (int j = i + 1; j < lines; j++) {
            fgets(buf, BUF_SZ, fp);
            lineb = atoi(buf);
            if (solvep(linea, lineb)) break;
        }
        if (solvep(linea, lineb)) break;
    }

    printf("%d\n", linea * lineb);

    fclose(fp);

}
