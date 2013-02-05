#ifndef HAS_CRONITEM_H
#define HAS_CRONITEM_H

#include <stdlib.h>
#include <wordexp.h>

#define CROWTAB "~/.crowtab"

struct cronitem {
    char *cmd;
};

struct cronlist {
    struct cronitem _this;
    struct cronlist* next;
};

FILE* get_cron_file(void);
struct cronitem* parse_line(char* line);
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

struct cronitem *parse_line(char* line) {
    return NULL;
}

#endif
