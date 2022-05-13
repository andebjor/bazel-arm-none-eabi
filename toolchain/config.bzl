# toolchain/config.bzl

load(
    "@rules_cc//cc:action_names.bzl",
    "ALL_CC_COMPILE_ACTION_NAMES",
    "ALL_CC_LINK_ACTION_NAMES",
    "ALL_CPP_COMPILE_ACTION_NAMES",
)
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
)
load(
    "@arm_none_eabi//toolchain:defs.bzl",
    "f_feature",
    "wrapper_path",
)

def _impl(ctx):
    tool_paths = [
        wrapper_path(ctx, tool)
        for tool in [
            "gcc",
            "ld",
            "ar",
            "cpp",
            "gcov",
            "nm",
            "objdump",
            "strip",
        ]
    ]

    compile_flags_feature = feature(
        name = "compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_COMPILE_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            "-fno-canonical-system-headers",
                        ],
                    ),
                ],
            ),
        ],
    )

    link_flags_feature = feature(
        name = "link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-lm",
                        ],
                    ),
                ],
            ),
        ],
    )

    rtti_feature = f_feature(
        name = "rtti",
        enabled = False,
        actions = ALL_CPP_COMPILE_ACTION_NAMES,
    )

    exceptions_feature = f_feature(
        name = "exceptions",
        enabled = False,
        actions = ALL_CC_COMPILE_ACTION_NAMES,
    )

    threadsafe_statics_feature = f_feature(
        name = "threadsafe-statics",
        enabled = False,
        actions = ALL_CPP_COMPILE_ACTION_NAMES,
    )

    lib_stdcxx_feature = feature(
        name = "libstdc++",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = ["-lstdc++"],
                    ),
                ],
            ),
        ],
    )

    nano_feature = feature(
        name = "nano",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_COMPILE_ACTION_NAMES + ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = ["-specs=nano.specs"],
                    ),
                ],
            ),
        ],
    )

    nosys_feature = feature(
        name = "nosys",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = ["-specs=nosys.specs"],
                    ),
                ],
            ),
        ],
    )

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = ctx.attr.toolchain_identifier,
        host_system_name = ctx.attr.host_system_name,
        target_system_name = "arm-none-eabi",
        target_cpu = "arm-none-eabi",
        target_libc = "gcc",
        compiler = ctx.attr.gcc_repo,
        abi_version = "eabi",
        abi_libc_version = ctx.attr.gcc_version,
        tool_paths = tool_paths,
        features = [
            compile_flags_feature,
            link_flags_feature,
            rtti_feature,
            exceptions_feature,
            threadsafe_statics_feature,
            lib_stdcxx_feature,
            nano_feature,
            nosys_feature,
        ],
    )

cc_arm_none_eabi_config = rule(
    implementation = _impl,
    attrs = {
        "toolchain_identifier": attr.string(default = ""),
        "host_system_name": attr.string(default = ""),
        "wrapper_path": attr.string(default = ""),
        "wrapper_ext": attr.string(default = ""),
        "gcc_repo": attr.string(default = ""),
        "gcc_version": attr.string(default = ""),
    },
    provides = [CcToolchainConfigInfo],
)

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

def darwin_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "@platforms//os:osx",
    )

def windows_filegroup(name, srcs):
    platform_filegroup(
        name = name,
        srcs = srcs,
        platform = "@platforms//os:windows",
    )
