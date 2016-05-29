#include "stdafx.h"
#include "crypto.h"
#include "kdc.h"

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>



int get_initial_ticket(client_info *info, ticket *tgt, char* session_key) {
    memset(info, 0, sizeof(client_info));
    memset(tgt, 0, sizeof(ticket));
    memset(session_key, 0, SESSION_KEY_LENGTH);

    char client_password[100];
    printf("Enter a client name: ");
    scanf("%s", info->client_name);
    printf("Enter a password: ");
    scanf("%s", client_password);

    crypt((char*)info, sizeof(client_info), CLIENT_PASSWORD);
    int result = get_tgt(info, session_key, tgt);
    switch (result) {
        case AUTH_OK:
            crypt(session_key, SESSION_KEY_LENGTH, client_password);
            return 0;

        case AUTH_CLIENT_NAME_ERROR:
            printf("Error: no client with this name\n");
            return -1;

        default:
            return -1;
    }
}


int get_server_ticket(client_info *info,
                      ticket *tgt,
                      char *session_key,
                      ticket *common_ticket,
                      char *common_skey)
{
    certificate cerf;
    memset(&cerf, 0, sizeof(certificate));
    memcpy(cerf.client_name, info->client_name, CLIENT_NAME_MAX_LENGTH);
    cerf.creation_time = time(NULL);

    memset(common_skey, 0, SESSION_KEY_LENGTH);
    memset(common_ticket, 0, sizeof(ticket));

    crypt((char*)&cerf, sizeof(certificate), session_key);
    int result = get_common_ticket(tgt, &cerf, common_skey, common_ticket);

    switch (result) {
        case AUTH_OK:
            crypt(common_skey, SESSION_KEY_LENGTH, session_key);
            return 0;

        case AUTH_CLIENT_NAME_ERROR:
            printf("Error: wrong password\n");
            return -1;

        case AUTH_SERVER_ADDERSS_ERROR:
            printf("Error: wrong server address\n");
            return -1;

        case AUTH_EXPIRATION_TIME_ERROR:
            printf("Error: time of ticket has expired\n");
            return -1;

        case AUTH_CREATION_TIME_ERROR:
            printf("Error: time of certificate has expired\n");
            return -1;

        default:
            return -1;
    }
}


int server_authenticate(client_info *info, ticket *common_ticket, char *common_skey) {
    certificate cerf;
    memset(&cerf, 0, sizeof(certificate));
    memcpy(cerf.client_name, info->client_name, CLIENT_NAME_MAX_LENGTH);
    cerf.creation_time = time(NULL);

    crypt((char*)&cerf, sizeof(certificate), common_skey);
    int result = authenticate(common_ticket, &cerf);

    switch (result) {
        case AUTH_OK:
            return 0;

        case AUTH_CLIENT_NAME_ERROR:
            printf("Error: incorrect client name\n");
            return -1;

        case AUTH_SERVER_ADDERSS_ERROR:
            printf("Error: wrong server address\n");
            return -1;

        case AUTH_EXPIRATION_TIME_ERROR:
            printf("Error: time of ticket has expired\n");
            return -1;

        case AUTH_CREATION_TIME_ERROR:
            printf("Error: time of certificate has expired\n");
            return -1;

        default:
            return -1;
    }
}


int main(int argc, char const *argv[]) {
    client_info info;
    ticket tgt, common_ticket;
    char session_key[SESSION_KEY_LENGTH], common_skey[SESSION_KEY_LENGTH];

    printf("Request to Authentication Server ...\n");
    if (get_initial_ticket(&info, &tgt, session_key) == -1) exit(0);
    printf("OK: TGS session key is: %s\n\n", session_key);

    printf("Request to Ticket-Granting Server ...\n");
    if (get_server_ticket(&info, &tgt, session_key, &common_ticket, common_skey) == -1) exit(0);
    printf("OK: Server session key is: %s\n\n", common_skey);

    printf("Request to Server ...\n");
    if (server_authenticate(&info, &common_ticket, common_skey) == -1) exit(0);
    printf("OK: Authentication completed\n");

    return 0;
}
