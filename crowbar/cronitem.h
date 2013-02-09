#ifndef HAS_CRONITEM_H
#define HAS_CRONITEM_H

#include <stdlib.h>
#include <stdbool.h>
#include <wordexp.h>

#define CROWTAB "~/.crowtab"
#define MAX_CMD_DISPLAY_SIZE 15

struct cronitem {
    char *cmd;
    char *display_cmd;
    unsigned long period;
};

struct cronlist {
    struct cronitem* cronitem;
    void* menuItem;
    void* timer;
    struct cronlist* next;
};

FILE* get_cron_file(void);
bool parse_line(char* line, struct cronitem *item);


FILE* get_cron_file(void) {
	wordexp_t exp_result;
	if (wordexp(CROWTAB, &exp_result, 0) == 0) {
        return fopen(exp_result.we_wordv[0], "r");
    } else {
        perror("wordexp()");
        exit(1);
    }
}

bool parse_line(char* line, struct cronitem* item) {
    char *lbrack, *rbrack, /* parens, wrapping period */
         *lsqbrack, *rsqbrack, /* square brackers, wrapping optional pretty name */
         *newln, *ellipses;
    if ((lbrack = strchr(line, '(')) &&
        (rbrack = strchr(line, ')')))
    {
        if (newln = strchr(line, '\n'))
            *newln = '\0';

        *rbrack = '\0';
        lbrack++;
        rbrack++;

        if((item->period = atoi(lbrack)) == 0)
            return false;

        if ((lsqbrack = strchr(rbrack, '[')) &&
            (rsqbrack = strchr(rbrack, ']')) &&
            ((lsqbrack - rbrack) < 3))
        {
            *rsqbrack = '\0';
            asprintf(&item->display_cmd, "%s", ++lsqbrack);
            asprintf(&item->cmd, "%s", ++rsqbrack);
        }
        else
        {
            asprintf(&item->cmd, "%s", rbrack);
            if (strlen(item->cmd) > MAX_CMD_DISPLAY_SIZE) {
                item->display_cmd = malloc(MAX_CMD_DISPLAY_SIZE+1);
                strncpy(item->display_cmd, item->cmd, MAX_CMD_DISPLAY_SIZE+1);
                ellipses = &(item->display_cmd[MAX_CMD_DISPLAY_SIZE]);
                *ellipses = '\0';
                *--ellipses = '.';
                *--ellipses = '.';
            } else {
                item->display_cmd = item->cmd; // TODO Is using the same buffer here always ok?
            }
        }
        return true;
    }
    return false;
}

#endif
