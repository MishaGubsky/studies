#include "stdafx.h"
#include "kdc.h"
#include <string.h>
#include <time.h>
#include <math.h>
#include "stdafx.h"


int authenticate(ticket *common_ticket, certificate *cerf) {
    crypt((char*)common_ticket, sizeof(ticket), SERVER_PASSWORD);
    crypt((char*)cerf, sizeof(certificate), common_ticket->session_key);

    if (strcmp(common_ticket->client_name, cerf->client_name))
        return AUTH_CLIENT_NAME_ERROR;
    if (fabs((double)cerf->creation_time - time(NULL)) > EXPIRATION_TIME)
        return AUTH_EXPIRATION_TIME_ERROR;
    if (fabs((double)cerf->creation_time - time(NULL)) > CREATION_TIME_DELTA)
        return AUTH_CREATION_TIME_ERROR;
        
    return AUTH_OK;
}
