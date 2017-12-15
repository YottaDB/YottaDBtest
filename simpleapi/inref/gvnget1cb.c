/****************************************************************
 *								*
 * Copyright (c) 2017 YottaDB LLC. and/or its subsidiaries.	*
 * All rights reserved.						*
 *								*
 *	This source code contains the intellectual property	*
 *	of its copyright holder(s), and is made available	*
 *	under a license.  If you do not know the terms of	*
 *	the license, please stop and do not read further.	*
 *								*
 ****************************************************************/

#include "libyottadb.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#undef DEBUGGVN			/* Change to define to enable debugging */
#define ERRBUF_SIZE	1024
#define MAX_LINE_BUF	1024
#define MAX_VALUE_LEN	8	/* Current value is always '42' but that could change */
#define INFILE		"gvnget1-M-extract.txt"

#ifdef DEBUGGVN
# define DBGGVN(x) {printf x; fflush(stderr); fflush(stdout);}
# define DBGGVN_ONLY(x) x
#else
# define DBGGVN(x)
# define DBGGVN_ONLY(x)
#endif

void gvnget1cb(void);
char *find_char(char fchr, char *lineptr, char *lineend);
int drive_ydb_get_s(ydb_buffer_t *varvalue, int subcnt, ydb_buffer_t *varname, ydb_buffer_t subscrs[YDB_MAX_SUBS]);

/* Read file created by M code in this process, separate the variable, subscripts, etc and
 * read the variable. Then compare the value from the file with the value we fetched.
 */
void gvnget1cb(void)
{
	FILE		*infile;
	char		linebuf[MAX_LINE_BUF + 1], *lineptr, *lineend;
	char		*varstart, *varend, *varrefend, *substart, *subend, *subliststart, *sublistend;
	char		valuebuf[MAX_VALUE_LEN + 1], *valuestart, *valueend;
	ydb_buffer_t	varname, subscrs[YDB_MAX_SUBS], varvalue;
	int		toklen, linenum, subscridx, valuelen;

	printf("gvnget1cb: Entered external call - processing key/value pair file..\n");
	fflush(stdout);
	infile = fopen(INFILE, "r");
	lineptr = fgets(linebuf, sizeof(linebuf), infile);	/* Waste/ignore the first 2 records in this file */
	lineptr = fgets(linebuf, sizeof(linebuf), infile);
	for (linenum = 3; ; linenum++)
	{	/* Obtain and parse key/value pair */
		DBGGVN(("\ngvnget1cb(): ***** Starting new key/value pair\n"));
		lineptr = fgets(linebuf, sizeof(linebuf), infile);
		if (NULL == lineptr)
		{
			DBGGVN(("gvnget1cb(): NULL pointer from read - assumed EOF\n"));
			break;						/* Assume end-of-file */
		}
		DBGGVN(("gvnget1cb(): Input line: %s\n", lineptr));
		lineend = valueend = lineptr + strlen(lineptr) - 1;	/* Pull the newline char off the end with -1 */
		/* Have a var=value pair - break it down into its pieces */
		varstart = lineptr;
		/* Locate end of variable reference - look for and unquoted '=' */
		lineptr = find_char('=', lineptr, lineend);
		if (NULL == lineptr)
		{
			printf("gvnget1cb(): Error - could not locate unquoted '=' in line %d\n", linenum);
			fflush(stdout);
			exit(1);
		}
		varrefend = lineptr;
		valuestart = lineptr + 1;
		/* Now restart the scan at the start to look for '(' denoting the beginning of subscripts */
		subliststart = find_char('(', varstart, varrefend);
		if (NULL == subliststart)
		{	/* No subscripts found so this whole thing is just a variable name */
			varend = varrefend;
			subscridx = 0;
			DBGGVN(("gvnget1cb(): No subscripts found for varname %.*s\n", (int)(varend - varstart), varstart));
		} else
		{	/* Scan our subscripts (all strings) into the subscrs array */
			varend = subliststart;
			DBGGVN(("gvnget1cb(): Beginning subscript parse for varname %.*s\n", (int)(varend - varstart), varstart));
			sublistend = --varrefend;			/* Back up to the closing ')' */
			if (')' != *sublistend)
			{
				printf("gvnget1cb(): Error - char prior to '=' was not ')' in line %d\n", linenum);
				fflush(stdout);
				exit(1);
			}
			substart = ++subliststart;			/* Start subscript past '(' */
			for (subscridx = 0; substart < sublistend; subscridx++)
			{	/* Locate each subscript and place it in the subscript array. Note quoted values
				 * should have their quotes removed. We don't need to scan for inside doubled-up
				 * quotes as the double quote is not in the list of characters from which values
				 * are generated.
				 */
				subend = find_char(',', substart, sublistend);
				if (NULL == subend)
				{	/* This was the last subscript */
					subend = sublistend;
					if (')' != *subend)
					{
						printf("gvnget1cb(): Error - subend char is not ')' as expected\n");
						fflush(stdout);
						exit(1);
					}
					DBGGVN(("gvnget1cb(): The next subscript is the LAST subscript\n"));
				}
				if ('"' == *substart)
				{	/* This is a quoted string value. Remove the first and last characters from
					 * the subscript value and fix the length.
					 */
					subscrs[subscridx].buf_addr = substart + 1;
					subscrs[subscridx].len_alloc = subscrs[subscridx].len_used = subend - substart - 2;
					DBGGVN(("gvnget1cb(): String subscript specified: %.*s\n", subscrs[subscridx].len_alloc,
						subscrs[subscridx].buf_addr));
				} else
				{	/* This is a numeric string value - pass as-is */
					subscrs[subscridx].buf_addr = substart;
					subscrs[subscridx].len_alloc = subscrs[subscridx].len_used = subend - substart;
					DBGGVN(("gvnget1cb(): Numeric specified: %.*s\n", subscrs[subscridx].len_alloc,
						subscrs[subscridx].buf_addr));
				}
				substart = subend + 1;			/* Next subscript (if any) starts after ',' */
			}	/* Note subscridx is set to the subscript count on exit */
		}
		varname.buf_addr = varstart;
		varname.len_alloc = varname.len_used = varend - varstart;
		/* Value at this time is only numeric but mupip extract returns it as a string. Dequote the value returned */
		varvalue.buf_addr = valuebuf;
		varvalue.len_alloc = sizeof(valuebuf);			/* Where value is stored */
		varvalue.len_used = 0;
		drive_ydb_get_s(&varvalue, subscridx, &varname, subscrs);
		if ((1 < varvalue.len_used) && ('"' == *varvalue.buf_addr))
		{	/* This is a quoted value - remove quotes */
			varvalue.buf_addr++;				/* Bump past open quote */
			varvalue.len_used -= 2;				/* Remove count for open and close quote */
		}
		/* Fetched value should be in varvalue - compare it with what we expect to find there */
		DBGGVN(("gvnget1cb(): Varname: %.*s, value: %.*s\n", (int)(varrefend - varstart), varstart,
			varvalue.len_used, varvalue.buf_addr));
		DBGGVN_ONLY(fflush(stdout));
		/* Again, check the source value if it is quoted and remove the quotes if so */
		valuelen = valueend - valuestart;
		if ((1 < valuelen) && ('"' == *valuestart))
		{	/* Value is quoted - remove quotes */
			valuestart++;
			valuelen -= 2;
		}
		if ((varvalue.len_used != valuelen) || (0 != memcmp(valuestart, varvalue.buf_addr, valuelen)))
		{
			printf("Line %i, fetched and actual value are not the same for var with basevar %.*s - "
			       "expected |%.*s| (len=%d) but got |%.*s| (len=%d)\n", linenum, varname.len_used, varname.buf_addr,
			       valuelen, valuestart, valuelen, varvalue.len_used, varvalue.buf_addr, varvalue.len_used);
			fflush(stdout);
		}
	}
	fclose(infile);
	printf("Processed %d records\n", linenum);
	return;
}

/* Routine to locate 'fchr' in the string defined by the start/end pair lineptr/lineend. Return NULL if
 * the character is not found in the string.
 */
char *find_char(char fchr, char *lineptr, char *lineend)
{
	int	inside_quote;

	inside_quote = FALSE;
	while(lineptr < lineend)
	{
		if (inside_quote)
		{	/* Can't find char inside quote so only look for close quote here */
			if ('"' == *lineptr)
				inside_quote = FALSE;
			lineptr++;
			continue;
		}
		if ('"' == *lineptr)
		{
			inside_quote = TRUE;
			lineptr++;
			continue;
		}
		if (fchr == *lineptr)
			return lineptr;
		lineptr++;
	}
	return NULL;			/* Character was not found */
}

/* Routine to make a call to ydb_get_s() with a variable number of parameters depending on how many subscripts
 * we have. This routine will pass extra parms in 3 cases out of 4 but a call for each size seems overkill for
 * this test.
 */
int drive_ydb_get_s(ydb_buffer_t *varvalue, int subcnt, ydb_buffer_t *varname, ydb_buffer_t subscrs[YDB_MAX_SUBS])
{
	int	status;
	char	errbuf[ERRBUF_SIZE];

	switch(subcnt)
	{
		case 0:
			status = ydb_get_s(varvalue, 0, varname);
			break;
		case 1:
		case 2:
		case 3:
		case 4:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3]);
			break;
		case 5:
		case 6:
		case 7:
		case 8:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7]);
			break;
		case 9:
		case 10:
		case 11:
		case 12:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11]);
			break;
		case 13:
		case 14:
		case 15:
		case 16:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11],
					   &subscrs[12], &subscrs[13], &subscrs[14], &subscrs[15]);
			break;
		case 17:
		case 18:
		case 19:
		case 20:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11],
					   &subscrs[12], &subscrs[13], &subscrs[14], &subscrs[15],
					   &subscrs[16], &subscrs[17], &subscrs[18], &subscrs[19]);
			break;
		case 21:
		case 22:
		case 23:
		case 24:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11],
					   &subscrs[12], &subscrs[13], &subscrs[14], &subscrs[15],
					   &subscrs[16], &subscrs[17], &subscrs[18], &subscrs[19],
					   &subscrs[20], &subscrs[21], &subscrs[22], &subscrs[23]);
			break;
		case 25:
		case 26:
		case 27:
		case 28:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11],
					   &subscrs[12], &subscrs[13], &subscrs[14], &subscrs[15],
					   &subscrs[16], &subscrs[17], &subscrs[18], &subscrs[19],
					   &subscrs[20], &subscrs[21], &subscrs[22], &subscrs[23],
					   &subscrs[24], &subscrs[25], &subscrs[26], &subscrs[27]);
			break;
		case 29:
		case 30:
		case 31:
			status = ydb_get_s(varvalue, subcnt, varname,
					   &subscrs[0], &subscrs[1], &subscrs[2], &subscrs[3],
					   &subscrs[4], &subscrs[5], &subscrs[6], &subscrs[7],
					   &subscrs[8], &subscrs[9], &subscrs[10], &subscrs[11],
					   &subscrs[12], &subscrs[13], &subscrs[14], &subscrs[15],
					   &subscrs[16], &subscrs[17], &subscrs[18], &subscrs[19],
					   &subscrs[20], &subscrs[21], &subscrs[22], &subscrs[23],
					   &subscrs[24], &subscrs[25], &subscrs[26], &subscrs[27],
					   &subscrs[28], &subscrs[29], &subscrs[30]);
			break;
		default:
			printf("gvnget1cb - Error - bad subscript count (%d)\n", subcnt);
			exit(1);
	}
	if (YDB_OK != status)
	{
		ydb_zstatus(errbuf, ERRBUF_SIZE);
		printf("gvnget1cb(): %s\n", errbuf);
		fflush(stdout);
		exit(status);
	}
	return status;
}