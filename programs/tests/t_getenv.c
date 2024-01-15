/// @file t_getenv.c
/// @brief
/// @copyright (c) 2014-2023 This file is distributed under the MIT License.
/// See LICENSE.md for details.

#include <stdio.h>
#include <stdlib.h>
#include <sys/unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    char *ENV_VAR = getenv("ENV_VAR");
    if (ENV_VAR == NULL) {
        printf("Failed to get env: `ENV_VAR`\n");
        return EXIT_FAILURE;
    }
    printf("ENV_VAR = %s\n", ENV_VAR);
    return EXIT_SUCCESS;
}
