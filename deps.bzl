"""deps.bzl"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

hosts = [
    "macos_x86_64",
    "linux_x86_64",
    "linux_aarch64",
    "windows_x86_32",
    "windows_x86_64",
]
targets = [
    "arm",
    "armv7-m",
    "cortex-m3",
    "armv7e-m",
    "cortex-m4",
    "cortex-m7",
]
architecture = {
    "cortex-m3": "armv7-m",
    "cortex-m4": "armv7e-m",
    "cortex-m7": "armv7e-m",
}

gcc_version = "11.2.1"

def arm_none_eabi_deps():
    """Workspace dependencies for the arm none eabi gcc toolchain"""

    http_archive(
        name = "arm_none_eabi_macos_x86_64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "31d6d3b400db89e204ab1a7ff3f4bb6230d2cdf5a551514ae9deedeebbb07bac",
        strip_prefix = "gcc-arm-11.2-2022.02-darwin-x86_64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-darwin-x86_64-arm-none-eabi.tar.xz",
    )

    http_archive(
        name = "arm_none_eabi_linux_x86_64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "8c5acd5ae567c0100245b0556941c237369f210bceb196edfe5a2e7532c60326",
        strip_prefix = "gcc-arm-11.2-2022.02-x86_64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-x86_64-arm-none-eabi.tar.xz",
    )

    http_archive(
        name = "arm_none_eabi_linux_aarch64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "ef1d82e5894e3908cb7ed49c5485b5b95deefa32872f79c2b5f6f5447cabf55f",
        strip_prefix = "gcc-arm-11.2-2022.02-aarch64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-aarch64-arm-none-eabi.tar.xz",
    )

    http_archive(
        name = "arm_none_eabi_windows_x86_32",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "585156432d73c9c2c8b4742e342564a75d47886d90ac821f88d2b564c33e6766",
        strip_prefix = "gcc-arm-11.2-2022.02-mingw-w64-i686-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-mingw-w64-i686-arm-none-eabi.zip",
    )

    native.register_toolchains(
        *[
            "@arm_none_eabi//toolchain:{host}-{target}".format(host = host, target = target)
            for host in hosts
            for target in targets
        ]
    )
