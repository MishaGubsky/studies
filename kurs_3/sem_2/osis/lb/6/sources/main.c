#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <time.h>
#include <errno.h>
#include<pthread.h>


#define PORT 8888


void update_datetime(char* buffer, int buffer_legnth) {
    time_t rawtime;
    struct tm *info;
    time(&rawtime);
    info = localtime(&rawtime);
    strftime(buffer, 80,"%A, %B %d, %Y. %X-%Z\n", info);
}


void *tcp_server_entry(void *arg) {
    int listener;
    if ((listener = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("TCP: Error while opening a socket\n");
        exit(1);
    }

    struct sockaddr_in address;
    address.sin_family = AF_INET;
    address.sin_port = htons(PORT);
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(listener, (struct sockaddr *)&address, sizeof(address)) < 0){
        printf("TCP: Error while binding to a socket\n");
        exit(2);
    }

    listen(listener, 1);

    int sock;
    char buffer[100];
    while(1) {
        if ((sock = accept(listener, NULL, NULL)) > 0) {
            update_datetime(buffer, 100);
            send(sock, buffer, strlen(buffer), 0);
            close(sock);
        }

    }
    return 0;
}


void *udp_server_entry(void *arg) {
    int listener;
    if ((listener = socket(AF_INET, SOCK_DGRAM, 0))  < 0) {
        printf("UDP: Error while opening a socket\n");
        exit(1);
    }

    struct sockaddr_in address;
    address.sin_family = AF_INET;
    address.sin_port = htons(PORT);
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(listener, (struct sockaddr *)&address, sizeof(address)) < 0) {
        printf("TCP: Error while binding to a socket\n");
        exit(2);
    }

    char temp_buffer[100];
    char time_buffer[100];

    struct sockaddr afrom;
    socklen_t alen = sizeof(afrom);
    while(1)
    {
        recvfrom(listener, temp_buffer, 100, 0, (struct sockaddr *)&afrom, &alen);
        update_datetime(time_buffer, 100);
        sendto(listener, time_buffer, strlen(time_buffer), 0, (struct sockaddr *)&afrom, alen);
    }
    return 0;
}


int main()
{
    pthread_t tcp_server, udp_server;
    pthread_create(&tcp_server, NULL, &tcp_server_entry, NULL);
    pthread_create(&udp_server, NULL, &udp_server_entry, NULL);
    pthread_join(udp_server, NULL);
}
