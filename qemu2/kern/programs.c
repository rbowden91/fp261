#include <kern/programs.h>
extern const uint8_t _binary_obj_user_idle_start[], _binary_obj_user_idle_size[];
extern const uint8_t _binary_obj_user_pingpong_start[], _binary_obj_user_pingpong_size[];
extern const uint8_t _binary_obj_user_primes_start[], _binary_obj_user_primes_size[];
extern const uint8_t _binary_obj_user_faultregs_start[], _binary_obj_user_faultregs_size[];
extern const uint8_t _binary_obj_user_writemotd_start[], _binary_obj_user_writemotd_size[];
extern const uint8_t _binary_obj_user_icode_start[], _binary_obj_user_icode_size[];
extern const uint8_t _binary_obj_user_testtime_start[], _binary_obj_user_testtime_size[];
extern const uint8_t _binary_obj_user_httpd_start[], _binary_obj_user_httpd_size[];
extern const uint8_t _binary_obj_user_echosrv_start[], _binary_obj_user_echosrv_size[];
extern const uint8_t _binary_obj_user_echotest_start[], _binary_obj_user_echotest_size[];
extern const uint8_t _binary_obj_fs_bufcache_start[], _binary_obj_fs_bufcache_size[];
extern const uint8_t _binary_obj_net_testoutput_start[], _binary_obj_net_testoutput_size[];
extern const uint8_t _binary_obj_net_testinput_start[], _binary_obj_net_testinput_size[];
extern const uint8_t _binary_obj_net_ns_start[], _binary_obj_net_ns_size[];
extern const uint8_t _binary_obj_user_migrated_start[], _binary_obj_user_migrated_size[];
extern const uint8_t _binary_obj_user_testmigrate_start[], _binary_obj_user_testmigrate_size[];
struct Program programs[] = {
{ "bufcache", _binary_obj_fs_bufcache_start, (int)_binary_obj_fs_bufcache_size },
{ "ns", _binary_obj_net_ns_start, (int)_binary_obj_net_ns_size },
{ "testinput", _binary_obj_net_testinput_start, (int)_binary_obj_net_testinput_size },
{ "testoutput", _binary_obj_net_testoutput_start, (int)_binary_obj_net_testoutput_size },
{ "echosrv", _binary_obj_user_echosrv_start, (int)_binary_obj_user_echosrv_size },
{ "echotest", _binary_obj_user_echotest_start, (int)_binary_obj_user_echotest_size },
{ "faultregs", _binary_obj_user_faultregs_start, (int)_binary_obj_user_faultregs_size },
{ "httpd", _binary_obj_user_httpd_start, (int)_binary_obj_user_httpd_size },
{ "icode", _binary_obj_user_icode_start, (int)_binary_obj_user_icode_size },
{ "idle", _binary_obj_user_idle_start, (int)_binary_obj_user_idle_size },
{ "migrated", _binary_obj_user_migrated_start, (int)_binary_obj_user_migrated_size },
{ "pingpong", _binary_obj_user_pingpong_start, (int)_binary_obj_user_pingpong_size },
{ "primes", _binary_obj_user_primes_start, (int)_binary_obj_user_primes_size },
{ "testmigrate", _binary_obj_user_testmigrate_start, (int)_binary_obj_user_testmigrate_size },
{ "testtime", _binary_obj_user_testtime_start, (int)_binary_obj_user_testtime_size },
{ "writemotd", _binary_obj_user_writemotd_start, (int)_binary_obj_user_writemotd_size },
{ 0, 0, 0 } };
int nprograms = sizeof(programs) / sizeof(programs[0]) - 1;
