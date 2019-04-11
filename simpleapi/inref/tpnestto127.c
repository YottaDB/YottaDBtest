#include <stdio.h>
#include <string.h>
#include "libyottadb.h"

#define getTLevel()({\
		int tStatus;\
		tLevel.len_used = 0;\
		tStatus = ydb_get_s(&dollarTLEVEL, 0, NULL, &tLevel);\
		YDB_ASSERT(tStatus == YDB_OK);\
		tLevel.buf_addr[tLevel.len_used] = '\0';\
		})

int tpNest();

char errbuf[2048];
char buf[5];
int status;

ydb_tpfnptr_t tpfn;
ydb_buffer_t dollarTLEVEL;
ydb_buffer_t tLevel;


/* calls ydb_tp_s() on a function which nests until TPTOODEEP ($TLEVEL 127)
 * then checks to ensure that all the transactions up to that point still finish
 */
int main(){
	YDB_LITERAL_TO_BUFFER("$TLEVEL", &dollarTLEVEL);
	YDB_MALLOC_BUFFER(&tLevel, 4);

	ydb_buffer_t basevar, outvalue;
	YDB_MALLOC_BUFFER(&outvalue, 5);
	YDB_MALLOC_BUFFER(&basevar, 5);

	tpfn = &tpNest;

	/* check initial $TLEVEL */
	getTLevel();
	if(strcmp(tLevel.buf_addr, "0") == 0){
		printf("$TLEVEL is correctly starting at 0\n");
	} else {
		printf("$TLEVEL is not starting at 0 as expected\nStarting at %s\n", tLevel.buf_addr);
		return 1;
	}

	/* check ydb_tp_s() status */
	printf("Starting nest until TPTOODEEP and setting\n");
	status = ydb_tp_s(tpfn, NULL, "ID", 0, NULL);
	if(status == YDB_OK){
		printf("ydb_tp_s() nest returned YDB_OK as expected\n");
	} else {
		ydb_zstatus(errbuf, sizeof(errbuf));
		printf("ydb_tp_s() nest did not return YDB_OK as expected\nError message: %s\n", errbuf);
		return 1;
	}

	/* check that $TLEVEL reset to 0 */
	getTLevel();
	if(strcmp(tLevel.buf_addr, "0") == 0){
		printf("$TLEVEL returned to 0 as expected\n");
	} else {
		printf("$TLEVEL did not return to 0 as expected\nReturned to %s\n", tLevel.buf_addr);
		return 1;
	}

	/* check that the globalVars was set properly */
	int i;
	for(i = 1; i <= 126; ++i){
		sprintf(buf, "^a%d", i);
		YDB_COPY_STRING_TO_BUFFER(buf, &basevar, status);
		status = ydb_get_s(&basevar, 0, NULL, &outvalue);
		outvalue.buf_addr[outvalue.len_used] = '\0';
		if(status == YDB_OK && strcmp(buf, outvalue.buf_addr) == 0){
			printf("ydb_get_s() for $TLEVEL %d returned YDB_OK and value was correct as expected\n", i);
		} else {
			ydb_zstatus(errbuf, sizeof(errbuf));
			printf("ydb_get_s() for $TLEVEL %d did not return YDB_OK as expected\nError message: %s\n", i, errbuf);
			return 1;
		}
	}

	printf("TP nest till TPTOODEEP correctly completes transactions\n");
	return 0;
}

/* recursively calls ydb_tp_s() until TPTOODEEP ($TLEVEL 127)
 * then attempts to set a globalVar at every $TLEVEL
 */
int tpNest(){
	getTLevel();
	printf("$TLEVEL is %s\n", tLevel.buf_addr);
	status = ydb_tp_s(tpfn, NULL, "ID", 0, NULL);
	if(status == YDB_ERR_TPTOODEEP)
		printf("Returned YDB_ERR_TPTOODEEP\nPerforming sets now\n");
	
	ydb_buffer_t basevar;

	getTLevel();
	YDB_MALLOC_BUFFER(&basevar, 5);
	sprintf(buf, "^a%s", tLevel.buf_addr); //prepend ^a to $TLEVEL to use as a global
	YDB_COPY_STRING_TO_BUFFER(buf, &basevar, status); 
	status = ydb_set_s(&basevar, 0, NULL, &basevar);
	YDB_ASSERT(status == YDB_OK);
	YDB_FREE_BUFFER(&basevar);
	return status;
}
