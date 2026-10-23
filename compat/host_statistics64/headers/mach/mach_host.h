#if __has_include(<Availability.h>)
#include <Availability.h>
#endif
#ifndef __IPHONE_3_0
__BEGIN_DECLS
kern_return_t host_statistics64(host_t, host_flavor_t, host_info_t,
                                mach_msg_type_number_t *);
__END_DECLS
#endif
