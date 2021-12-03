#include <stdio.h>
#include <stdlib.h>

int
main(void)
{
    char *line = NULL;
    size_t n = 0;

    int prev = -1, curr, result = 0;
    while (getline(&line, &n, stdin) > 0) {
        curr = atoi(line);
        if (prev >= 0 && curr > prev) {
            result++;
        }

        prev = curr;
        free(line);
        line = NULL;
        n = 0;
    }

    printf("%d\n", result);
}
