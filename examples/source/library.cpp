#include "library.h"

#include <cstdint>
#include <vector>

std::uint16_t baz(int a)
{
    return static_cast<std::uint16_t>(a) * 2;
}

std::uint32_t foo()
{
    static constexpr int k = 5;
    return baz(k);
}

std::uint16_t foobaz()
{
    std::vector<std::uint8_t> vec(10);
    vec.push_back(1);
    return vec[0];
}
