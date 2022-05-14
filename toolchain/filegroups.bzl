def platform_filegroup(name, srcs, platform):
    native.filegroup(
        name = name,
        srcs = select({
            platform: srcs,
            "//conditions:default": [],
        }),
    )

def linux_x86_64_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "//toolchain/host:linux_x86_64",
    )

def linux_aarch64_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "//toolchain/host:linux_aarch64",
    )

def macos_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "@platforms//os:macos",
    )

def windows_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "@platforms//os:windows",
    )
