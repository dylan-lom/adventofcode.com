#include <stdio.h>
#include <stdlib.h>

char *
nextline(void)
{
    static char *line;
    static size_t n;

    free(line);
    line = NULL;
    n = 0;
    if (getline(&line, &n, stdin) < 0) {
        return NULL;
    }

    return line;
}

int
main(void)
{
    int windows[3] = {-1, -1, -1};
    char *line;
    int lineno = 0;
    while ((line = nextline()) != NULL) {
        if (windows[lineno % 3] != -1) {
            printf("%d\n", windows[lineno % 3]);
         }

        // Reset whatever window needs to be reset
        windows[lineno % 3] = 0;
        int x = atoi(line);

        if (windows[0] != -1) windows[0] += x;
        if (windows[1] != -1) windows[1] += x;
        if (windows[2] != -1) windows[2] += x;

        lineno++;
    }

    printf("%d\n", windows[lineno % 3]);
}
