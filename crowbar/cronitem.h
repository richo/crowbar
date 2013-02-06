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
    NSMenuItem* menuItem;
    struct cronlist* next;
};

FILE* get_cron_file(void);
bool parse_line(char* line, struct cronitem *item);
struct cronlist* get_cron_items(char** lines);


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
    char *lbrack, *rbrack, *newln, *ellipses;
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

        asprintf(&item->cmd, "%s", rbrack);
        if (strlen(item->cmd) > MAX_CMD_DISPLAY_SIZE) {
            item->display_cmd = malloc(MAX_CMD_DISPLAY_SIZE);
            strncpy(item->display_cmd, item->cmd, MAX_CMD_DISPLAY_SIZE);
            ellipses = &(item->display_cmd[MAX_CMD_DISPLAY_SIZE]);
            *ellipses = '\0';
            *ellipses-- = '.';
            *ellipses-- = '.';
        } else {
            item->display_cmd = item->cmd; // TODO Is using the same buffer here always ok?
        }
        return true;
    }
    return false;
}

#endif
