// Main public header file for our user-land support library,
// whose code lives in the lib directory.
// This library is roughly our OS's version of a standard C library,
// and is intended to be linked into all user-mode applications
// (NOT the kernel or boot loader).

#ifndef JOS_INC_LIB_H
#define JOS_INC_LIB_H 1

#include <inc/types.h>
#include <inc/stdio.h>
#include <inc/stdarg.h>
#include <inc/string.h>
#include <inc/error.h>
#include <inc/assert.h>
#include <inc/env.h>
#include <inc/memlayout.h>
#include <inc/syscall.h>
#include <inc/trap.h>
#include <inc/fs.h>
#include <inc/fd.h>
#include <inc/args.h>
#include <inc/ns.h>

#define USED(x)		(void)(x)

// main user program
void	umain(int argc, char **argv);

// libos.c or entry.S
extern const char *binaryname;
extern const volatile struct Env *thisenv;
extern const volatile struct Env envs[NENV];
extern const volatile struct Page pages[];
void	exit(void);

// pgfault.c
typedef void (*pgfault_handler_t)(struct UTrapframe *);

void	add_pgfault_handler(pgfault_handler_t handler);
int add_fault_handler(uint32_t trapno, pgfault_handler_t handler);


// resume.S
asmlinkage void resume(struct UTrapframe *utf) __attribute__((noreturn));

// readline.c
char*	readline(const char *buf);

// syscall.c
void	sys_cputs(const char *string, size_t len);
int	sys_cgetc(void);
envid_t	sys_getenvid(void);
int	sys_env_destroy(envid_t);
void	sys_yield(void);
int	sys_env_set_status(envid_t env, int status);

static envid_t sys_exofork(void) __attribute__((always_inline));
// Excercise for the reader: Why must sys_exofork() always be inlined?

int	sys_page_alloc(envid_t env, void *pg, int perm);
int	sys_page_map(envid_t src_env, void *src_pg,
		     envid_t dst_env, void *dst_pg, int perm);
int	sys_page_unmap(envid_t env, void *pg);
int	sys_env_set_trapframe(envid_t env, struct Trapframe *tf);
int	sys_env_set_pgfault_upcall(envid_t env, void *upcall);
int	sys_ipc_try_send(envid_t to_env, uint32_t value, void *pg, int perm);
int	sys_ipc_recv(void *rcv_pg);
int sys_env_set_priority(envid_t e, int p);
int	sys_program_lookup(const char *name, size_t len);
ssize_t	sys_program_read(envid_t dst_env, void *pg, int programid, size_t offset, size_t len);
unsigned 	sys_time_msec(void);
int sys_e1000_transmit(void *buffer, size_t len);
size_t sys_e1000_receive(void *buffer);
int sys_page_evict(unsigned ppn);
int sys_page_audit(unsigned ppn);
int sys_page_recover(unsigned ppn);
int sys_page_alloc_exists_on_remote(envid_t envid, void *va, int perm);

#define THISENV (&envs[ENVX(sys_getenvid())])

static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
}

// dumbfork.c
envid_t	dumbfork(void);

// ipc.c
void	ipc_send(envid_t to_env, uint32_t value, void *pg, int perm);
int32_t ipc_recv(envid_t *from_env_store, void *pg, int *perm_store);

// fork.c
#define	PTE_SHARE	0x400
envid_t	fork(void);
envid_t	sfork(void);	// Challenge!

// spawn.c
envid_t	spawn(const char *prog, const char **argv);
envid_t	spawnl(const char *prog, const char *arg0, ...);

// fd.c
int	close(int fd);
ssize_t	read(int fd, void *buf, size_t nbytes);
ssize_t	write(int fd, const void *buf, size_t nbytes);
int	seek(int fd, off_t offset);
void	close_all(void);
ssize_t	readn(int fd, void *buf, size_t nbytes);
int	dup(int oldfd, int newfd);
int	fstat(int fd, struct Stat *statbuf);
int	stat(const char *path, struct Stat *statbuf);

void *malloc(size_t size);
void free(void *addr);

// file.c
int	open(const char *path, int mode);
int	ftruncate(int fd, off_t size);
int	unlink(const char *path);
int	istat(inum_t inum, struct Stat *statbuf);
int	sync(void);
int	fsck(void);

// sockets.c
int     accept(int s, struct sockaddr *addr, socklen_t *addrlen);
int     bind(int s, struct sockaddr *name, socklen_t namelen);
int     shutdown(int s, int how);
int     closesocket(int s);
int     connect(int s, const struct sockaddr *name, socklen_t namelen);
int     listen(int s, int backlog);
int     recv(int s, void *mem, int len, unsigned int flags);
int     send(int s, const void *dataptr, int size, unsigned int flags);
int     socket(int domain, int type, int protocol);

// nsipc.c
int     nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen);
int     nsipc_bind(int s, struct sockaddr *name, socklen_t namelen);
int     nsipc_shutdown(int s, int how);
int     nsipc_close(int s);
int     nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen);
int     nsipc_listen(int s, int backlog);
int     nsipc_recv(int s, void *mem, int len, unsigned int flags);
int     nsipc_send(int s, const void *dataptr, int size, unsigned int flags);
int     nsipc_socket(int domain, int type, int protocol);

// pageref.c
int	pageref(void *addr);


// console.c
void	cputchar(int c);
int	getchar(void);
int	iscons(int fd);
int	opencons(void);

// pipe.c
int	pipe(int pipefds[2]);
int	pipeisclosed(int pipefd);
int pipe_ipc_recv_read(envid_t *from_envid);
int pipe_ipc_send(envid_t envid, int read_fdnum);

// wait.c
void	wait(envid_t env);

// migrate.c
void migrate_shared_page_fault_handler(struct UTrapframe *utf);

// File open modes
#define	O_RDONLY	0x0000		// open for reading only
#define	O_WRONLY	0x0001		// open for writing only
#define	O_RDWR		0x0002		// open for reading and writing
#define	O_ACCMODE	0x0003		// mask for above modes

#define	O_CREAT		0x0100		// create if nonexistent
#define	O_TRUNC		0x0200		// truncate to zero length
#define	O_EXCL		0x0400		// error if already exists
#define O_MKDIR		0x0800		// create directory, not regular file

#endif	// !JOS_INC_LIB_H
