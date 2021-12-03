To solve the first problem:

    $ cc -Wall -Wextra -pedantic -o a a.c
    $ ./a < input

To solve the second problem:

    $ cc -Wall -Wextra -pedantic -o a a.c
    $ cc -Wall -Wextra -pedantic -o b b.c
    $ ./b < input | ./a

