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

def has_float_abi(cpu):
    arch = [
        "armv7e-m",
    ]
    return cpu in arch or architecture.get(cpu, "") in arch

gcc_version = "11.2.1"

def arm_none_eabi_deps():
    """Workspace dependencies for the arm none eabi gcc toolchain"""

    http_archive(
        name = "arm_none_eabi_macos_x86_64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "946e5b1b93d48ac71a83bb907a0f8aaa05041ba8eb1007792cc2921475460d4e",
        strip_prefix = "arm-gnu-toolchain-12.2.mpacbti-bet1-darwin-x86_64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-bet1/binrel/arm-gnu-toolchain-12.2.mpacbti-bet1-darwin-x86_64-arm-none-eabi.tar.xz?rev=84494f738c6349fe84e509e91713f409&hash=F740DA913B3F2DADEC857F189AC97F76",
    )

    http_archive(
        name = "arm_none_eabi_linux_x86_64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "51d99d11950446ac64a5664c860b9e03b3241757db8dc9f673dbd8fa4a830b18",
        strip_prefix = "arm-gnu-toolchain-12.2.mpacbti-bet1-x86_64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-bet1/binrel/arm-gnu-toolchain-12.2.mpacbti-bet1-x86_64-arm-none-eabi.tar.xz?rev=bad6fbd075214a34b48ddbf57e741249&hash=F87A67141928852E079463E67E2B7A02",
    )

    http_archive(
        name = "arm_none_eabi_linux_aarch64",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "af61803dbf2972ce2236e937ffc0a2f5cb3d86ddc6c14cd935e274fc1c6c69a1",
        strip_prefix = "arm-gnu-toolchain-12.2.mpacbti-bet1-aarch64-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-bet1/binrel/arm-gnu-toolchain-12.2.mpacbti-bet1-aarch64-arm-none-eabi.tar.xz?rev=cd13d8fc408f42d680fcccc26281d945&hash=DD68E49B16AFE10346AE2B6D0AF4E23A",
    )

    http_archive(
        name = "arm_none_eabi_windows_x86_32",
        build_file = "@arm_none_eabi//toolchain:compiler.BUILD",
        sha256 = "cd2fd7ff4eeba41319ca47ceaab223d0ddbbc1f5df410354e2365c3ece5b7cd5",
        strip_prefix = "arm-gnu-toolchain-12.2.mpacbti-bet1-mingw-w64-i686-arm-none-eabi",
        url = "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.mpacbti-bet1/binrel/arm-gnu-toolchain-12.2.mpacbti-bet1-mingw-w64-i686-arm-none-eabi.zip?rev=02b9889af49c4da9bc47018c00e18eb5&hash=AE65D45D5C9377AC531CF2EDB447FA99",
    )

    native.register_toolchains(
        *[
            "@arm_none_eabi//toolchain:{host}-{target}".format(host = host, target = target)
            for host in hosts
            for target in targets
        ]
    )
