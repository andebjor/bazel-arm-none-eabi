#include "arm/semihosting.hpp"

#include <cstdint>

extern "C" {
extern void initialise_monitor_handles();
}

namespace arm::semihosting {

void init() { initialise_monitor_handles(); }

void exit(int ec)
{
    // https://github.com/ARM-software/abi-aa/blob/main/semihosting/semihosting.rst#sys-exit-extended-0x20

    static constexpr auto SYS_EXIT_EXTENDED = 0x20U;

    static constexpr auto ADP_Stopped_ApplicationExit = 0x20026;

    const std::uint32_t argblock[2] = {
        ADP_Stopped_ApplicationExit,
        static_cast<std::uint32_t>(ec)
    };

    register std::uint32_t r0 __asm__("r0");
    r0 = SYS_EXIT_EXTENDED;

    register const std::uint32_t* r1 __asm__("r1");
    r1 = argblock;

    __asm__ volatile("bkpt #0xAB");
}

}
