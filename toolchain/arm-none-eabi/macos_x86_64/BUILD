# toolchains/arm-none-eabi/macos_x86_64/BUILD.bazel

load("@arm_none_eabi//toolchain:config.bzl", "cc_arm_none_eabi_config", "macos_filegroup")

package(default_visibility = ["//visibility:public"])

compiler = "arm_none_eabi_macos_x86_64"

macos_filegroup(
    name = "all_files",
    srcs = [
        ":ar_files",
        ":compiler_files",
        ":linker_files",
        "@{}//:compiler_pieces".format(compiler),
    ],
)

macos_filegroup(
    name = "compiler_files",
    srcs = [
        "arm-none-eabi-gcc",
        "@{}//:compiler_pieces".format(compiler),
        "@{}//:gcc".format(compiler),
    ],
)

macos_filegroup(
    name = "linker_files",
    srcs = [
        "arm-none-eabi-gcc",
        "arm-none-eabi-ld",
        "@{}//:ar".format(compiler),
        "@{}//:compiler_pieces".format(compiler),
        "@{}//:gcc".format(compiler),
        "@{}//:ld".format(compiler),
    ],
)

macos_filegroup(
    name = "ar_files",
    srcs = [
        "arm-none-eabi-ar",
        "@{}//:ar".format(compiler),
    ],
)

macos_filegroup(
    name = "objcopy_files",
    srcs = [
        "arm-none-eabi-objcopy",
        "@{}//:objcopy".format(compiler),
    ],
)

macos_filegroup(
    name = "strip_files",
    srcs = [
        "arm-none-eabi-strip",
        "@{}//:strip".format(compiler),
    ],
)

cc_arm_none_eabi_config(
    name = "config",
    gcc_repo = compiler,
    gcc_version = "11.2.1",
    host_system_name = "macos_x86_64",
    toolchain_identifier = "arm_none_eabi_macos_x86_64",
    wrapper_path = "arm-none-eabi/macos_x86_64",
)
