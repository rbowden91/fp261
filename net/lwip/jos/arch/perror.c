
#define LWIP_PROVIDE_ERRNO
#include <arch/perror.h>
#include <lwip/arch.h>

static const char *
get_errlist(int err)
{

	static const char *sys_errlist[ENSRCNAMELOOP+1];
	sys_errlist[EPERM] = "EPERM";     /* Operation not permitted */
	sys_errlist[ENOENT] = "ENOENT";      /* No such file or directory */
	sys_errlist[ESRCH] = "ESRCH";      /* No such process */
	sys_errlist[EINTR] = "EINTR";      /* Interrupted system call */
	sys_errlist[EIO] = "EIO";      /* I/O error */
	sys_errlist[ENXIO] = "ENXIO";      /* No such device or address */
	sys_errlist[E2BIG] = "E2BIG";      /* Arg list too long */
	sys_errlist[ENOEXEC] = "ENOEXEC";      /* Exec format error */
	sys_errlist[EBADF] = "EBADF";      /* Bad file number */
	sys_errlist[ECHILD] = "ECHILD";      /* No child processes */
	sys_errlist[EAGAIN] = "EAGAIN";      /* Try again */
	sys_errlist[ENOMEM] = "ENOMEM";      /* Out of memory */
	sys_errlist[EACCES] = "EACCES";      /* Permission denied */
	sys_errlist[EFAULT] = "EFAULT";      /* Bad address */
	sys_errlist[ENOTBLK] = "ENOTBLK";      /* Block device required */
	sys_errlist[EBUSY] = "EBUSY";      /* Device or resource busy */
	sys_errlist[EEXIST] = "EEXIST";      /* File exists */
	sys_errlist[EXDEV] = "EXDEV";      /* Cross-device link */
	sys_errlist[ENODEV] = "ENODEV";      /* No such device */
	sys_errlist[ENOTDIR] = "ENOTDIR";      /* Not a directory */
	sys_errlist[EISDIR] = "EISDIR";      /* Is a directory */
	sys_errlist[EINVAL] = "EINVAL";      /* Invalid argument */
	sys_errlist[ENFILE] = "ENFILE";      /* File table overflow */
	sys_errlist[EMFILE] = "EMFILE";      /* Too many open files */
	sys_errlist[ENOTTY] = "ENOTTY";      /* Not a typewriter */
	sys_errlist[ETXTBSY] = "ETXTBSY";      /* Text file busy */
	sys_errlist[EFBIG] = "EFBIG";      /* File too large */
	sys_errlist[ENOSPC] = "ENOSPC";      /* No space left on device */
	sys_errlist[ESPIPE] = "ESPIPE";      /* Illegal seek */
	sys_errlist[EROFS] = "EROFS";      /* Read-only file system */
	sys_errlist[EMLINK] = "EMLINK";      /* Too many links */
	sys_errlist[EPIPE] = "EPIPE";      /* Broken pipe */
	sys_errlist[EDOM] = "EDOM";      /* Math argument out of domain of func */
	sys_errlist[ERANGE] = "ERANGE";      /* Math result not representable */
	sys_errlist[EDEADLK] = "EDEADLK";      /* Resource deadlock would occur */
	sys_errlist[ENAMETOOLONG] = "ENAMETOOLONG";    /* File name too long */
	sys_errlist[ENOLCK] = "ENOLCK";      /* No record locks available */
	sys_errlist[ENOSYS] = "ENOSYS";      /* Function not implemented */
	sys_errlist[ENOTEMPTY] = "ENOTEMPTY";    /* Directory not empty */
	sys_errlist[ELOOP] = "ELOOP";      /* Too many symbolic links encountered */
	sys_errlist[EWOULDBLOCK] = "EWOULDBLOCK"; /* Operation would block */
	sys_errlist[ENOMSG] = "ENOMSG";      /* No message of desired type */
	sys_errlist[EIDRM] = "EIDRM";      /* Identifier removed */
	sys_errlist[ECHRNG] = "ECHRNG";      /* Channel number out of range */
	sys_errlist[EL2NSYNC] = "EL2NSYNC";    /* Level 2 not synchronized */
	sys_errlist[EL3HLT] = "EL3HLT";      /* Level 3 halted */
	sys_errlist[EL3RST] = "EL3RST";      /* Level 3 reset */
	sys_errlist[ELNRNG] = "ELNRNG";      /* Link number out of range */
	sys_errlist[EUNATCH] = "EUNATCH";      /* Protocol driver not attached */
	sys_errlist[ENOCSI] = "ENOCSI";      /* No CSI structure available */
	sys_errlist[EL2HLT] = "EL2HLT";      /* Level 2 halted */
	sys_errlist[EBADE] = "EBADE";      /* Invalid exchange */
	sys_errlist[EBADR] = "EBADR";      /* Invalid request descriptor */
	sys_errlist[EXFULL] = "EXFULL";      /* Exchange full */
	sys_errlist[ENOANO] = "ENOANO";      /* No anode */
	sys_errlist[EBADRQC] = "EBADRQC";      /* Invalid request code */
	sys_errlist[EBADSLT] = "EBADSLT";      /* Invalid slot */

	sys_errlist[EDEADLOCK] = "EDEADLOCK";

	sys_errlist[EBFONT] = "EBFONT";      /* Bad font file format */
	sys_errlist[ENOSTR] = "ENOSTR";      /* Device not a stream */
	sys_errlist[ENODATA] = "ENODATA";      /* No data available */
	sys_errlist[ETIME] = "ETIME";      /* Timer expired */
	sys_errlist[ENOSR] = "ENOSR";      /* Out of streams resources */
	sys_errlist[ENONET] = "ENONET";      /* Machine is not on the network */
	sys_errlist[ENOPKG] = "ENOPKG";      /* Package not installed */
	sys_errlist[EREMOTE] = "EREMOTE";      /* Object is remote */
	sys_errlist[ENOLINK] = "ENOLINK";      /* Link has been severed */
	sys_errlist[EADV] = "EADV";      /* Advertise error */
	sys_errlist[ESRMNT] = "ESRMNT";      /* Srmount error */
	sys_errlist[ECOMM] = "ECOMM";      /* Communication error on send */
	sys_errlist[EPROTO] = "EPROTO";      /* Protocol error */
	sys_errlist[EMULTIHOP] = "EMULTIHOP";    /* Multihop attempted */
	sys_errlist[EDOTDOT] = "EDOTDOT";      /* RFS specific error */
	sys_errlist[EBADMSG] = "EBADMSG";      /* Not a data message */
	sys_errlist[EOVERFLOW] = "EOVERFLOW";    /* Value too large for defined data type */
	sys_errlist[ENOTUNIQ] = "ENOTUNIQ";    /* Name not unique on network */
	sys_errlist[EBADFD] = "EBADFD";      /* File descriptor in bad state */
	sys_errlist[EREMCHG] = "EREMCHG";      /* Remote address changed */
	sys_errlist[ELIBACC] = "ELIBACC";      /* Can not access a needed shared library */
	sys_errlist[ELIBBAD] = "ELIBBAD";      /* Accessing a corrupted shared library */
	sys_errlist[ELIBSCN] = "ELIBSCN";      /* .lib section in a.out corrupted */
	sys_errlist[ELIBMAX] = "ELIBMAX";      /* Attempting to link in too many shared libraries */
	sys_errlist[ELIBEXEC] = "ELIBEXEC";    /* Cannot exec a shared library directly */
	sys_errlist[EILSEQ] = "EILSEQ";      /* Illegal byte sequence */
	sys_errlist[ERESTART] = "ERESTART";    /* Interrupted system call should be restarted */
	sys_errlist[ESTRPIPE] = "ESTRPIPE";    /* Streams pipe error */
	sys_errlist[EUSERS] = "EUSERS";      /* Too many users */
	sys_errlist[ENOTSOCK] = "ENOTSOCK";    /* Socket operation on non-socket */
	sys_errlist[EDESTADDRREQ] = "EDESTADDRREQ";    /* Destination address required */
	sys_errlist[EMSGSIZE] = "EMSGSIZE";    /* Message too long */
	sys_errlist[EPROTOTYPE] = "EPROTOTYPE";    /* Protocol wrong type for socket */
	sys_errlist[ENOPROTOOPT] = "ENOPROTOOPT";    /* Protocol not available */
	sys_errlist[EPROTONOSUPPORT] = "EPROTONOSUPPORT";    /* Protocol not supported */
	sys_errlist[ESOCKTNOSUPPORT] = "ESOCKTNOSUPPORT";    /* Socket type not supported */
	sys_errlist[EOPNOTSUPP] = "EOPNOTSUPP";    /* Operation not supported on transport endpoint */
	sys_errlist[EPFNOSUPPORT] = "EPFNOSUPPORT";    /* Protocol family not supported */
	sys_errlist[EAFNOSUPPORT] = "EAFNOSUPPORT";    /* Address family not supported by protocol */
	sys_errlist[EADDRINUSE] = "EADDRINUSE";    /* Address already in use */
	sys_errlist[EADDRNOTAVAIL] = "EADDRNOTAVAIL";    /* Cannot assign requested address */
	sys_errlist[ENETDOWN] = "ENETDOWN";  /* Network is down */
	sys_errlist[ENETUNREACH] = "ENETUNREACH";  /* Network is unreachable */
	sys_errlist[ENETRESET] = "ENETRESET";  /* Network dropped connection because of reset */
	sys_errlist[ECONNABORTED] = "ECONNABORTED";  /* Software caused connection abort */
	sys_errlist[ECONNRESET] = "ECONNRESET";  /* Connection reset by peer */
	sys_errlist[ENOBUFS] = "ENOBUFS";    /* No buffer space available */
	sys_errlist[EISCONN] = "EISCONN";    /* Transport endpoint is already connected */
	sys_errlist[ENOTCONN] = "ENOTCONN";  /* Transport endpoint is not connected */
	sys_errlist[ESHUTDOWN] = "ESHUTDOWN";  /* Cannot send after transport endpoint shutdown */
	sys_errlist[ETOOMANYREFS] = "ETOOMANYREFS";  /* Too many references: cannot splice */
	sys_errlist[ETIMEDOUT] = "ETIMEDOUT";  /* Connection timed out */
	sys_errlist[ECONNREFUSED] = "ECONNREFUSED";  /* Connection refused */
	sys_errlist[EHOSTDOWN] = "EHOSTDOWN";  /* Host is down */
	sys_errlist[EHOSTUNREACH] = "EHOSTUNREACH";  /* No route to host */
	sys_errlist[EALREADY] = "EALREADY";  /* Operation already in progress */
	sys_errlist[EINPROGRESS] = "EINPROGRESS";  /* Operation now in progress */
	sys_errlist[ESTALE] = "ESTALE";    /* Stale NFS file handle */
	sys_errlist[EUCLEAN] = "EUCLEAN";    /* Structure needs cleaning */
	sys_errlist[ENOTNAM] = "ENOTNAM";    /* Not a XENIX named type file */
	sys_errlist[ENAVAIL] = "ENAVAIL";    /* No XENIX semaphores available */
	sys_errlist[EISNAM] = "EISNAM";    /* Is a named type file */
	sys_errlist[EREMOTEIO] = "EREMOTEIO";  /* Remote I/O error */
	sys_errlist[EDQUOT] = "EDQUOT";    /* Quota exceeded */

	sys_errlist[ENOMEDIUM] = "ENOMEDIUM";  /* No medium found */
	sys_errlist[EMEDIUMTYPE] = "EMEDIUMTYPE";  /* Wrong medium type */


	sys_errlist[ENSROK] = "ENSROK";    /* DNS server returned answer with no data */
	sys_errlist[ENSRNODATA] = "ENSRNODATA";  /* DNS server returned answer with no data */
	sys_errlist[ENSRFORMERR] = "ENSRFORMERR"; /* DNS server claims query was misformatted */
	sys_errlist[ENSRSERVFAIL] = "ENSRSERVFAIL"; /* DNS server returned general failure */
	sys_errlist[ENSRNOTFOUND] = "ENSRNOTFOUND"; /* Domain name not found */
	sys_errlist[ENSRNOTIMP] = "ENSRNOTIMP";  /* DNS server does not implement requested operation */
	sys_errlist[ENSRREFUSED] = "ENSRREFUSED"; /* DNS server refused query */
	sys_errlist[ENSRBADQUERY] = "ENSRBADQUERY"; /* Misformatted DNS query */
	sys_errlist[ENSRBADNAME] = "ENSRBADNAME"; /* Misformatted domain name */
	sys_errlist[ENSRBADFAMILY] = "ENSRBADFAMILY"; /* Unsupported address family */
	sys_errlist[ENSRBADRESP] = "ENSRBADRESP"; /* Misformatted DNS reply */
	sys_errlist[ENSRCONNREFUSED] = "ENSRCONNREFUSED"; /* Could not contact DNS servers */
	sys_errlist[ENSRTIMEOUT] = "ENSRTIMEOUT"; /* Timeout while contacting DNS servers */
	sys_errlist[ENSROF] = "ENSROF";    /* End of file */
	sys_errlist[ENSRFILE] = "ENSRFILE";  /* Error reading file */
	sys_errlist[ENSRNOMEM] = "ENSRNOMEM"; /* Out of memory */
	sys_errlist[ENSRDESTRUCTION] = "ENSRDESTRUCTION"; /* Application terminated lookup */
	sys_errlist[ENSRQUERYDOMAINTOOLONG] = "ENSRQUERYDOMAINTOOLONG";  /* Domain name is too long */
	sys_errlist[ENSRCNAMELOOP] = "ENSRCNAMELOOP"; /* Domain name is too long */


	return sys_errlist[err];
}


void
perror(const char *s) {
	int err = errno;
	cprintf("%s: %s\n", s, e2s(err));
}

const char *
e2s(int err) {
	return get_errlist(err);
}
