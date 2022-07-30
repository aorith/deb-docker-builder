#include <stdio.h>

#define BUFFER_SIZE 128

int main(int argc, char *argv[]) {
    FILE *pipe;
    int status;
    char output[BUFFER_SIZE];

    pipe = popen("figlet 'Hello, World!'", "r");
    if (pipe == NULL) {
        perror(argv[0]);
        return 1;
    }

    while (fgets(output, BUFFER_SIZE, pipe) != NULL) {
        printf("%s", output);
    }

    status = pclose(pipe);
    if (status == -1) {
        printf("pclose error\n");
        return 1;
    }
    return status/256;
}
