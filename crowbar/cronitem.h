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
struct cronlist* get_cron_items(char** lines);


FILE* get_cron_file(void) {
	wordexp_t exp_result;
	wordexp(CROWTAB, &exp_result, 0);
	return fopen(exp_result.we_wordv[0], "r");
}

#endif
