/* See COPYRIGHT for copyright information. */

#ifndef _CONSOLE_H_
#define _CONSOLE_H_
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/types.h>

#define MONO_BASE	0x3B4
#define MONO_BUF	0xB0000
#define CGA_BASE	0x3D4
#define CGA_BUF		0xB8000

#define CRT_ROWS	25
#define CRT_COLS	80
#define CRT_SIZE	(CRT_ROWS * CRT_COLS)

#define ESC			0x1B

// Ansi Font Colors
#define ANSI_BLACK 30
#define ANSI_RED 31
#define ANSI_GREEN 32
#define ANSI_YELLOW 33
#define ANSI_BLUE 34
#define ANSI_MAGENTA 35
#define ANSI_CYAN 36
#define ANSI_WHITE 37
#define ANSI_BG_BLACK 40
#define ANSI_BG_RED 41
#define ANSI_BG_GREEN 42
#define ANSI_BG_YELLOW 43
#define ANSI_BG_BLUE 44
#define ANSI_BG_MAGENTA 45
#define ANSI_BG_CYAN 46
#define ANSI_BG_WHITE 47

// VGA Font Colors
#define VGA_FG_CLEAR(x) (0xF0 & x)
#define VGA_BLACK(x) (x = VGA_FG_CLEAR(x) | 0)
#define VGA_RED(x) (x = VGA_FG_CLEAR(x) | 4)
#define VGA_GREEN(x) (x = VGA_FG_CLEAR(x) | 2)
#define VGA_YELLOW(x) (x = VGA_FG_CLEAR(x) | 14)
#define VGA_BLUE(x) (x = VGA_FG_CLEAR(x) | 1)
#define VGA_MAGENTA(x) (x = VGA_FG_CLEAR(x) | 5)
#define VGA_CYAN(x) (x = VGA_FG_CLEAR(x) | 3)
#define VGA_WHITE(x) (x = VGA_FG_CLEAR(x) | 7)
#define VGA_BG_CLEAR(x) (0xF & x)
#define VGA_BG_BLACK(x) (x = VGA_BG_CLEAR(x) | 0)
#define VGA_BG_RED(x) (x = VGA_BG_CLEAR(x) | 4<<4)
#define VGA_BG_GREEN(x) (x = VGA_BG_CLEAR(x) | 2<<4)
#define VGA_BG_YELLOW(x) (x = VGA_BG_CLEAR(x) | 14<<4)
#define VGA_BG_BLUE(x) (x = VGA_BG_CLEAR(x) | 1<<4)
#define VGA_BG_MAGENTA(x) (x = VGA_BG_CLEAR(x) | 5<<4)
#define VGA_BG_CYAN(x) (x = VGA_BG_CLEAR(x) | 3<<4)
#define VGA_BG_WHITE(x) (x = VGA_BG_CLEAR(x) | 7<<4)

// convenient font-color-changing function
#define FONT_COLOR(x) (cprintf("%c[%d",ESC,x))

void cons_init(void);
int cons_getc(void);

void kbd_intr(void); // irq 1
void serial_intr(void); // irq 4

#endif /* _CONSOLE_H_ */
