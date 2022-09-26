# toolchain/config.bzl

load(
    "@rules_cc//cc:defs.bzl",
    "cc_toolchain",
)
load(
    "@rules_cc//cc:action_names.bzl",
    "ALL_CC_COMPILE_ACTION_NAMES",
    "ALL_CC_LINK_ACTION_NAMES",
    "ALL_CPP_COMPILE_ACTION_NAMES",
    "C_COMPILE_ACTION_NAME",
)
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "with_feature_set",
)
load(
    "@arm_none_eabi//:deps.bzl",
    "gcc_version",
    "has_float_abi",
)
load(
    "@arm_none_eabi//toolchain:defs.bzl",
    "exclusive_features",
    "f_feature",
    "common_warnings",
    "cpp_warnings",
    "c_warnings",
    "wrapper_path",
)

def arm_flags(cpu):
    if cpu == "arm":
        return []

    return [
        "{opt}={value}".format(
            opt = "-march" if cpu.startswith("arm") else "-mcpu",
            value = cpu,
        ),
        "-mthumb",
    ]

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

    arm_features = [] if ctx.attr.target_cpu == "arm" else (
        [
            feature(
                name = "arm_flags",
                enabled = True,
                flag_sets = [
                    flag_set(
                        actions = ALL_CC_COMPILE_ACTION_NAMES + ALL_CC_LINK_ACTION_NAMES,
                        flag_groups = [
                            flag_group(
                                flags = arm_flags(ctx.attr.target_cpu),
                            ),
                        ],
                    ),
                ],
            ),
        ] +
        exclusive_features(
            configs =
                [
                    {
                        "name": "float-abi-soft",
                        "flags": ["-mfloat-abi=soft"],
                    },
                ] +
                (
                    [
                        {
                            "name": "float-abi-softfp",
                            "flags": ["-mfloat-abi=softfp"],
                        },
                        {
                            "name": "float-abi-hard",
                            "flags": ["-mfloat-abi=hard"],
                        },
                    ] if has_float_abi(ctx.attr.target_cpu) else []
                ),
            actions = ALL_CC_COMPILE_ACTION_NAMES + ALL_CC_LINK_ACTION_NAMES,
            enabled = "float-abi-hard" if has_float_abi(ctx.attr.target_cpu) else "float-abi-soft",
        )
    )

    dbg_feature = feature(name = "dbg")

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
                            "-fno-common",
                            "-fdiagnostics-color",
                            "-fstack-usage",
                            "-ffreestanding",
                            "-Os",
                        ] + common_warnings,
                    ),
                ],
            ),
            flag_set(
                actions = ALL_CPP_COMPILE_ACTION_NAMES,
                flag_groups = [
                    flag_group(
                        flags = cpp_warnings,
                    ),
                ],
            ),
            flag_set(
                actions = [C_COMPILE_ACTION_NAME],
                flag_groups = [
                    flag_group(
                        flags = c_warnings,
                    ),
                ],
            ),
            flag_set(
                actions = ALL_CC_COMPILE_ACTION_NAMES,
                flag_groups = [flag_group(flags = ["-g"])],
                with_features = [with_feature_set(features = ["dbg"])],
            ),
        ],
    )

    link_flags_feature = feature(
        name = "link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [flag_group(flags = [
                    "-lm",
                    "-Wl,--print-memory-usage",
                    "-Wl,--warn-common",
                ])],
            ),
        ],
    )

    treat_warnings_as_errors_feature = feature(
        name = "treat_warnings_as_errors",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_COMPILE_ACTION_NAMES,
                flag_groups = [flag_group(flags = ["-Werror"])],
            ),
        ],
    )

    gc_sections_feature = feature(
        name = "gc_sections",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_CC_COMPILE_ACTION_NAMES,
                flag_groups = [flag_group(flags = [
                    "-fdata-sections",
                    "-ffunction-sections",
                ])],
            ),
            flag_set(
                actions = ALL_CC_LINK_ACTION_NAMES,
                flag_groups = [flag_group(flags = [
                    "-Wl,--gc-sections",
                    # TODO add a verbose variant of this feature
                    #"-Wl,--print-gc-sections",
                ])],
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
        target_cpu = ctx.attr.target_cpu,
        target_libc = "gcc",
        compiler = ctx.attr.gcc_repo,
        abi_version = "eabi",
        abi_libc_version = gcc_version,
        tool_paths = tool_paths,
        features = arm_features +
                   [
                       dbg_feature,
                       compile_flags_feature,
                       link_flags_feature,
                       treat_warnings_as_errors_feature,
                       gc_sections_feature,
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
        "target_cpu": attr.string(default = ""),
    },
    provides = [CcToolchainConfigInfo],
)

def cross_toolchain(host_os, host_cpu, target_cpu):
    name = "{}_{}-{}".format(host_os, host_cpu, target_cpu)

    cc_toolchain_name = "cc_toolchain_{}".format(name)

    # On Windows, no 64bit source is available, so we reuse the 32bit one.
    host = "{}_{}".format(
        host_os,
        "x86_32" if host_os == "windows" else host_cpu,
    )

    toolchain_identifier = "arm_none_eabi_{}".format(name)
    toolchain_config = "config_{}".format(name)

    def toolpkg(tool):
        return "//toolchain/arm-none-eabi/{host}:{tool}".format(
            host = host,
            tool = tool,
        )

    cc_arm_none_eabi_config(
        name = toolchain_config,
        gcc_repo = "arm_none_eabi_{}".format(host),
        host_system_name = host,
        toolchain_identifier = toolchain_identifier,
        wrapper_path = "arm-none-eabi/{}".format(host),
        wrapper_ext = ".bat" if host_os == "windows" else "",
        target_cpu = target_cpu,
    )

    cc_toolchain(
        name = cc_toolchain_name,
        all_files = toolpkg("all_files"),
        ar_files = toolpkg("ar_files"),
        compiler_files = toolpkg("compiler_files"),
        dwp_files = ":empty",
        linker_files = toolpkg("linker_files"),
        objcopy_files = toolpkg("objcopy_files"),
        strip_files = toolpkg("strip_files"),
        supports_param_files = 0,
        toolchain_config = toolchain_config,
        toolchain_identifier = toolchain_identifier,
    )

    native.toolchain(
        name = name,
        exec_compatible_with = [
            "@platforms//os:{}".format(host_os),
            "@platforms//cpu:{}".format(host_cpu),
        ],
        target_compatible_with = [
            "@platforms//os:none",
            "@arm_none_eabi//platforms/cpu:{}".format(target_cpu),
        ],
        toolchain = ":{}".format(cc_toolchain_name),
        toolchain_type = "@rules_cc//cc:toolchain_type",
    )
