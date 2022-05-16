# BUILD

package(default_visibility = ["//visibility:public"])

config_setting(
    name = "macos",
    values = {"host_cpu": "darwin"},
)

config_setting(
    name = "linux",
    values = {"host_cpu": "k8"},
)

config_setting(
    name = "windows",
    values = {"host_cpu": "x64_windows"},
)

sh_binary(
    name = "gcc",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-gcc"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-gcc"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-gcc.exe"],
    }),
)

sh_binary(
    name = "ar",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-ar"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-ar"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-ar.exe"],
    }),
)

sh_binary(
    name = "ld",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-ld"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-ld"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-ld.exe"],
    }),
)

sh_binary(
    name = "nm",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-nm"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-nm"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-nm.exe"],
    }),
)

sh_binary(
    name = "objcopy",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-objcopy"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-objcopy"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-objcopy.exe"],
    }),
)

sh_binary(
    name = "objdump",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-objdump"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-objdump"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-objdump.exe"],
    }),
)

sh_binary(
    name = "strip",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-strip"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-strip"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-strip.exe"],
    }),
)

sh_binary(
    name = "as",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-as"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-as"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-as.exe"],
    }),
)

sh_binary(
    name = "gdb",
    srcs = select({
        "macos": ["@arm_none_eabi_macos_x86_64//:bin/arm-none-eabi-gdb"],
        "linux": ["@arm_none_eabi_linux_x86_64//:bin/arm-none-eabi-gdb"],
        "windows": ["@arm_none_eabi_windows_x86_32//:bin/arm-none-eabi-gdb.exe"],
    }),
)
