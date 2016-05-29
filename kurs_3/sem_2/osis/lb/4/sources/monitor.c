#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include "monitor.h"


#define READ_CONFIG_SIGNAL SIGUSR1


char *config_filename = DEFAULT_CONFIG_FILENAME;
char *log_filename = DEFAULT_LOG_FILENAME;

FILE* log_file = NULL;
FILE* config_file = NULL;

const int signals_count = 33;
const char *signals[] = {
    NULL, "SIGHUP", "SIGINT", "SIGQUIT", "SIGILL", "SIGTRAP", "SIGABRT", "SIGBUS", "SIGFPE",
    "SIGKILL", "SIGUSR1", "SIGSEGV", "SIGUSR2", "SIGPIPE", "SIGALRM", "SIGTERM", "SIGSTKFLT",
    "SIGCHLD", "SIGCONT", "SIGSTOP", "SIGTSTP", "SIGTTIN", "SIGTTOU", "SIGURG", "SIGXCPU",
    "SIGXFSZ", "SIGVTALRM", "SIGPROF", "SIGWINCH", "SIGIO", "SIGPWR", "SIGSYS", "SIGRTMIN"
};


void read_signal_name(char *signal_name, int max_length) {
    memset(signal_name, 0, max_length);
    fgets(signal_name, max_length, config_file);
    int length = strlen(signal_name) - 1;

    for (length; isspace(signal_name[length]) && length > 0; length--) {
        signal_name[length] = '\0';
    }
}


int get_signal_no(const char *signal_name) {
    for (int i = 1; i < signals_count; i++) {
        if (!strcmp(signal_name, signals[i]))
            return i;
    }
    return 0;
}


void init_signals(sigset_t *signal_set) {
    char signal_name[20];
    sigemptyset(signal_set);
    sigaddset(signal_set, READ_CONFIG_SIGNAL);

    fprintf(log_file, "%s Reading signals from \"%s\"\n", "[Info]", config_filename);

    rewind(config_file);
    while (!feof(config_file)) {
        read_signal_name(signal_name, 20);
        int signal_no = get_signal_no(signal_name);

        if (signal_no) {
            sigaddset(signal_set, signal_no);
            fprintf(log_file, "%s Added singal: %s(%d)\n", "[Success]", signal_name, signal_no);
        }
        else {
            fprintf(log_file, "%s Unknown signal name: %s\n", "[Warning]", signal_name);
        }
    }

    fprintf(log_file, "%s Reading signals is completed\n\n", "[Success]");
    fflush(log_file);

    sigprocmask(SIG_BLOCK, signal_set, NULL);
}


void monitor_proc(sigset_t *signal_set) {
    fprintf(log_file, "%s Monitoring started\n", "[Info]");
    fflush(log_file);

    siginfo_t signal_info;
    for (;;) {
        int signal_code = sigwaitinfo(signal_set, &signal_info);
        fprintf(log_file, "%s Received signal: %s(%d)\n", "[Info]", signals[signal_code], signal_code);
        fflush(log_file);

        if (signal_code == READ_CONFIG_SIGNAL) {
            fprintf(log_file, "\n");
            init_signals(signal_set);
        }
    }
}


void run_monitor() {
    setsid();

    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    log_file = fopen(log_filename, "wb");
    config_file = fopen(config_filename, "rb");
    if (log_file && config_file) {
        fprintf(log_file, "%s Daemon started\n\n", "[Success]");

        sigset_t signal_set;
        init_signals(&signal_set);
        monitor_proc(&signal_set);

        fclose(config_file);
        fclose(log_file);
    }
}
