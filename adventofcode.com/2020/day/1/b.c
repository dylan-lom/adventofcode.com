#include <stdio.h>
#include <stdlib.h>

#define BUF_SZ 100

int solvep(int a, int b, int c) {
    if (a + b + c== 2020) return 1;
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
    int a, b, c;
    int solution;

    // Get linecount
    int lines = 0;
    while (fgets(buf, BUF_SZ, fp) != NULL) lines++;

    /* For each line, try to solve for all lines after */
    for (int i = 0; i < lines; i++) {
        // Read from ln i
        rewindto(fp, i);

        fgets(buf, BUF_SZ, fp);
        a = atoi(buf);
        for (int j = i + 1; j < lines; j++) {
            rewindto(fp, j);

            fgets(buf, BUF_SZ, fp);
            b = atoi(buf);
            for (int k = j + 1; k < lines; k++) {
                fgets(buf, BUF_SZ, fp);
                c = atoi(buf);
                if (solvep(a, b, c)) break;
            }
            if (solvep(a, b, c)) break;
        }
        if (solvep(a, b, c)) break;
    }

    printf("%d * %d * %d = %d\n", a, b, c, a * b * c);

    fclose(fp);

}
