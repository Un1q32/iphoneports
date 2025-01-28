#include <mach/mach.h>
#include <stdio.h>

int main(void) {
  vm_statistics64_data_t vm_stat;
  mach_msg_type_number_t count = sizeof(vm_stat) / sizeof(natural_t);
  host_statistics64(mach_host_self(), HOST_VM_INFO64, (host_info64_t)&vm_stat,
                    &count);
  printf("%llu\n", (vm_stat.active_count + vm_stat.inactive_count) * 4ULL);
  return 0;
}
