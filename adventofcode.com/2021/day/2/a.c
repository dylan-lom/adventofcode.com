#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int
main(void)
{
    // 0,0 is top left -- depth: 0
    int x = 0, y = 0;

    char *line = NULL;
    size_t n = 0;
    while (getline(&line, &n, stdin) > 0) {
        char type = *line; // we only need to check the first char
        
        char *a = line;
        while (*a++ != ' ') {}
        int n = atoi(a);

        switch (type) {
        case 'f': x += n; break;
        case 'd': y += n; break;
        case 'u': y -= n; break;
        default:
            printf("%c\n", type);
            assert(0 && "UNREACHABLE" && type);
        }

        free(line);
        line = NULL;
        n = 0;
    }

    printf("%d\n", x*y);
}
