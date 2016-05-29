#ifndef __kdc__
#define __kdc__


#include "crypto.h"
#include <time.h>


#define CLIENT_NAME "client_name"
#define CLIENT_PASSWORD "client_password"
#define SERVER_PASSWORD "server_password"
#define TICKET_PASSWORD "ticket_password"
#define SESSION_KEY_PASSWORD "session_key_password"

#define SESSION_KEY_LENGTH 100
#define CLIENT_NAME_MAX_LENGTH 50
#define SERVER_ADDRESS_MAX_LENGTH 10
#define EXPIRATION_TIME 1
#define CREATION_TIME_DELTA 1

#define AUTH_OK 0
#define AUTH_CLIENT_NAME_ERROR 1
#define AUTH_SERVER_ADDERSS_ERROR 2
#define AUTH_EXPIRATION_TIME_ERROR 3
#define AUTH_CREATION_TIME_ERROR 4


struct client_info{
    char client_name[CLIENT_NAME_MAX_LENGTH];
    char server_address[SERVER_ADDRESS_MAX_LENGTH];
} ;

struct ticket{
    char session_key[SESSION_KEY_LENGTH];
    char client_name[CLIENT_NAME_MAX_LENGTH];
    char client_adderss[SERVER_ADDRESS_MAX_LENGTH];
    char server_address[SERVER_ADDRESS_MAX_LENGTH];
    time_t creation_time;
} ;

struct certificate{
    char client_name[CLIENT_NAME_MAX_LENGTH];
    time_t creation_time;
} ;


int get_tgt(client_info *info, char* session_key, ticket *tgt);
int get_common_ticket(ticket *tgt, certificate *crf, char* session_key, ticket *common_ticket);
int authenticate(ticket *common_ticket, certificate *cerf);


#endif
