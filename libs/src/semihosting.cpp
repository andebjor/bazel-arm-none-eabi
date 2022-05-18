#include "arm/semihosting.hpp"

#include <cstdint>

extern "C" {
extern void initialise_monitor_handles();
}

namespace arm::semihosting {

void init() { initialise_monitor_handles(); }

void __attribute__((optimize("O0")))
exit(int ec)
{
    // https://github.com/ARM-software/abi-aa/blob/main/semihosting/semihosting.rst#sys-exit-extended-0x20

    static constexpr std::int32_t SYS_EXIT_EXTENDED = 0x20U;
    static constexpr std::int32_t ADP_Stopped_ApplicationExit = 0x20026;

    const std::int32_t argblock[2] = {
        ADP_Stopped_ApplicationExit,
        static_cast<std::int32_t>(ec)
    };

    register std::int32_t r0 asm("r0") = SYS_EXIT_EXTENDED;
    register const std::int32_t* r1 asm("r1") = argblock;

    (void)r0;
    (void)r1;
    asm volatile("bkpt #0xAB");
}

}
