# toolchains/arm-none-eabi/windows/BUILD.bazel

load("@arm_none_eabi//toolchain:filegroups.bzl", "windows_filegroup")

package(default_visibility = ["//visibility:public"])

compiler = "arm_none_eabi_windows_x86_32"

windows_filegroup(
    name = "all_files",
    srcs = [
        ":ar_files",
        ":compiler_files",
        ":linker_files",
        "@{}//:compiler_pieces".format(compiler),
    ],
)

windows_filegroup(
    name = "compiler_files",
    srcs = [
        "arm-none-eabi-gcc.bat",
        "@{}//:compiler_pieces".format(compiler),
        "@{}//:gcc".format(compiler),
    ],
)

windows_filegroup(
    name = "linker_files",
    srcs = [
        "arm-none-eabi-gcc.bat",
        "arm-none-eabi-ld.bat",
        "@{}//:ar".format(compiler),
        "@{}//:compiler_pieces".format(compiler),
        "@{}//:gcc".format(compiler),
        "@{}//:ld".format(compiler),
    ],
)

windows_filegroup(
    name = "ar_files",
    srcs = [
        "arm-none-eabi-ar.bat",
        "@{}//:ar".format(compiler),
    ],
)

windows_filegroup(
    name = "objcopy_files",
    srcs = [
        "arm-none-eabi-objcopy.bat",
        "@{}//:objcopy".format(compiler),
    ],
)

windows_filegroup(
    name = "strip_files",
    srcs = [
        "arm-none-eabi-strip.bat",
        "@{}//:strip".format(compiler),
    ],
)
