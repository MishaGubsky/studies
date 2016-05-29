#include "stdafx.h"
#include "kdc.h"
#include <stdio.h>
#include <string.h>
#include <time.h>


void generate_session_key(client_info *info, char *session_key) {
    memset(session_key, 0, SESSION_KEY_LENGTH);
    sprintf(session_key, "%s$%s$%d", info->client_name, info->server_address, (int)time(NULL));
}


int get_tgt(client_info *info, char* session_key, ticket *tgt) {
    crypt((char*)info, sizeof(client_info), CLIENT_PASSWORD);
    if (strcmp(info->client_name, CLIENT_NAME))
        return AUTH_CLIENT_NAME_ERROR;

    generate_session_key(info, session_key);
    memcpy(tgt->client_name, info->client_name, CLIENT_NAME_MAX_LENGTH);
    memcpy(tgt->server_address, info->server_address, SERVER_ADDRESS_MAX_LENGTH);
    memcpy(tgt->session_key, session_key, SESSION_KEY_LENGTH);
    tgt->creation_time = time(NULL);

    crypt(session_key, SESSION_KEY_LENGTH, CLIENT_PASSWORD);
    crypt((char*)tgt, sizeof(ticket), TICKET_PASSWORD);

    return AUTH_OK;
}
