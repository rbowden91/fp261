/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_KCLOCK_H
#define JOS_KERN_KCLOCK_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#define	IO_RTC		0x070		/* RTC port */

#define	MC_NVRAM_START	0xe	/* start of NVRAM: offset 14 */
#define	MC_NVRAM_SIZE	50	/* 50 bytes of NVRAM */

/* NVRAM bytes 7 & 8: amount of base memory (1K units) */
#define NVRAM_BASELO	(MC_NVRAM_START + 7)	/* low byte; RTC offset 0x15 */
#define NVRAM_BASEHI	(MC_NVRAM_START + 8)	/* high byte; RTC off 0x16 */

/* NVRAM bytes 9 & 10: amount of extended memory (>1MB) (1K units) */
#define NVRAM_EXTLO	(MC_NVRAM_START + 9)	/* low byte; RTC off 0x17 */
#define NVRAM_EXTHI	(MC_NVRAM_START + 10)	/* high byte; RTC off 0x18 */

/* NVRAM byte 36: current century */
#define NVRAM_CENTURY	(MC_NVRAM_START + 36)	/* RTC offset 0x32 */

/* NVRAM bytes 38 and 39: amount of memory >16MB (64K units) */
#define NVRAM_EXTABOVE16M_LO (MC_NVRAM_START + 38) /* low byte; RTC off 0x34 */
#define NVRAM_EXTABOVE16M_HI (MC_NVRAM_START + 39) /* high byte; RTC off 0x35 */

unsigned mc146818_read(unsigned reg);
void mc146818_write(unsigned reg, unsigned datum);
void kclock_init(void);

#endif	// !JOS_KERN_KCLOCK_H
