#ifndef HAS_CRONITEM_H
#define HAS_CRONITEM_H

#include <stdlib.h>
#include <stdbool.h>
#include <wordexp.h>

#define CROWTAB "~/.crowtab"

struct cronitem {
    char *cmd;
    unsigned long period;
};

struct cronlist {
    struct cronitem _this;
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
    char *lbrack, *rbrack, *newln;
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
        return true;
    }
    return false;
}

#endif
