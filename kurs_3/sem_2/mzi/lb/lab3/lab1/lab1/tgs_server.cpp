#include "stdafx.h"
#include "kdc.h"
#include <time.h>
#include <string.h>
#include <math.h>
#include <stdio.h>


void generate_common_session_key(ticket *t, char *session_key) {
    memset(session_key, 0, SESSION_KEY_LENGTH);
    sprintf(
        session_key,
        "%s$%s$%s$%d",
        t->client_name,
        t->server_address,
        t->client_adderss,
        (int)t->creation_time
    );
}

int get_common_ticket(ticket *tgt,
                      certificate *cerf,
                      char* common_session_key,
                      ticket *common_ticket)
{
    crypt((char*)tgt, sizeof(ticket), TICKET_PASSWORD);
    crypt((char*)cerf, sizeof(certificate), tgt->session_key);

    if (strcmp(tgt->client_name, cerf->client_name))
        return AUTH_CLIENT_NAME_ERROR;
    if (fabs((double)cerf->creation_time - time(NULL)) > EXPIRATION_TIME)
        return AUTH_EXPIRATION_TIME_ERROR;
    if (abs((double)cerf->creation_time - time(NULL)) > CREATION_TIME_DELTA)
        return AUTH_CREATION_TIME_ERROR;

    generate_common_session_key(tgt, common_session_key);
    memcpy(common_ticket->client_name, tgt->client_name, CLIENT_NAME_MAX_LENGTH);
    memcpy(common_ticket->server_address, tgt->server_address, SERVER_ADDRESS_MAX_LENGTH);
    memcpy(common_ticket->client_adderss, tgt->client_adderss, SERVER_ADDRESS_MAX_LENGTH);
    memcpy(common_ticket->session_key, common_session_key, SESSION_KEY_LENGTH);
    common_ticket->creation_time = time(NULL);

    crypt(common_session_key, SESSION_KEY_LENGTH, tgt->session_key);
    crypt((char*)common_ticket, sizeof(ticket), SERVER_PASSWORD);

    return AUTH_OK;
}
