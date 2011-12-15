/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_PROGRAMS_H
#define JOS_KERN_PROGRAMS_H
#include <inc/types.h>
#include <inc/memlayout.h>

struct Program {
	const char *name;	// name of ELF binary (e.g. "hello")
	const uint8_t *data;	// ELF data
	size_t size;		// size of ELF
};

extern struct Program programs[];
extern int nprograms;

#endif	// !JOS_KERN_PROGRAMS_H
