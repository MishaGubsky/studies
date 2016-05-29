#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/stat.h>
#include <fcntl.h>


#define FIFO_PATH "/tmp/now.fifo"
#define TIME_REFRESH_DELAY (1000 * 1000)
#define PIPE_REFRESH_DELAY (TIME_REFRESH_DELAY / 10)


void update_time(char* buffer, int buffer_length) {
    time_t rawtime;
    rawtime = time(NULL);
    struct tm *info = localtime(&rawtime);
    memset(buffer, 0, buffer_length);
    strftime(buffer, buffer_length,"%x %X\n", info);
}


void server_terminate_handler() {
    unlink(FIFO_PATH);
    printf("Server stopped\n");
    exit(0);
}

void server_entry() {
    printf("Server is started. Pid: %d\n", getpid());
    setsid();

    struct sigaction signal_action;
    signal_action.sa_handler = server_terminate_handler;
    sigaction(SIGINT, &signal_action, 0);

    char time_buffer[100];
    char temp_buffer[100];

    while (1) {
        update_time(time_buffer, 100);
        for (int i = 0; i < TIME_REFRESH_DELAY / PIPE_REFRESH_DELAY; i++) {
            int fifo;

            if ((fifo = open(FIFO_PATH, O_RDONLY | O_NONBLOCK)) > 0) {
                read(fifo, temp_buffer, 100);
                close(fifo);
            }

            if ((fifo =  open(FIFO_PATH, O_WRONLY | O_NONBLOCK)) > 0) {
                write(fifo, time_buffer, strlen(time_buffer));
                close(fifo);
            }

            usleep(PIPE_REFRESH_DELAY);
        }
    }
}

void client_entry() {
    int fifo;
    char time_buffer[100];
    if ((fifo = open(FIFO_PATH, O_RDONLY)) > 0) {
        memset(time_buffer, 0, 100);
        read(fifo, time_buffer, 100);
        printf("%s", time_buffer);
        close(fifo);
    }
}


int main(int argc, char const *argv[]) {
    pid_t child_pid = fork();
    int fifo_exists = mkfifo(FIFO_PATH, 0666);

    switch(child_pid) {
        case -1:
            printf("Error while forking a process");
            break;

        case 0:
            server_entry();
            break;

        default:
            if (fifo_exists == -1) {
                kill(child_pid, SIGTERM);
                client_entry();
            }
            break;
    }

    return 0;
}
