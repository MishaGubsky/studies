#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "monitor.h"


extern char *log_filename;
extern char *config_filename;


int main(int argc, char *argv[]) {
    if (argc > 1 && (strcmp(argv[1], "-h") || strcmp(argv[1], "--help"))) {
        printf("Usage: monitor [config_filename] [log_filename]\n");
    }
    else {
        config_filename = (argc > 1) ? argv[1] : DEFAULT_CONFIG_FILENAME;
        log_filename = (argc > 2) ? argv[2] : DEFAULT_LOG_FILENAME;

        pid_t child_pid = fork();
        switch(child_pid) {
            case -1:
            printf("Error while forking a new process");
            return 1;

            case 0:
            run_monitor();
            break;

            default:
            break;
        }
    }
    return 0;
}
