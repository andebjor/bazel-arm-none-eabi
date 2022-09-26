# toolchain/defs.bzl

load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
    "with_feature_set",
)

common_warnings = [
    "-Wall",
    "-Wextra",
    "-Wcast-align",
    "-Wunused",
    "-Wpedantic",
    "-Wconversion",
    "-Wsign-conversion",
    "-Wdouble-promotion",
    "-Wformat=2",
    "-Wshadow=compatible-local",
    "-Wlogical-op",
    "-Wduplicated-cond",
    "-Wduplicated-branches",
    "-Wmisleading-indentation",
]
cpp_warnings = [
    "-Wnon-virtual-dtor",
    "-Wold-style-cast",
    "-Woverloaded-virtual",
    "-Wuseless-cast",
]

c_warnings = [
    "-Wbad-function-cast",
    "-Wjump-misses-init",
    "-Wstrict-prototypes",
    "-Wold-style-declaration",
    "-Wold-style-definition",
    "-Wnested-externs",
]

def wrapper_path(ctx, tool):
    wrapped_path = "{}/arm-none-eabi-{}{}".format(ctx.attr.wrapper_path, tool, ctx.attr.wrapper_ext)
    return tool_path(name = tool, path = wrapped_path)

def _feature_flags(name, actions, flags, disable_flags = None):
    return [
        flag_set(
            actions = actions,
            flag_groups = [
                flag_group(
                    flags = flags,
                ),
            ],
            with_features = [with_feature_set(features = [name])],
        ),
    ] + ([
        flag_set(
            actions = actions,
            flag_groups = [
                flag_group(
                    flags = disable_flags,
                ),
            ],
            with_features = [with_feature_set(not_features = [name])],
        ),
    ] if disable_flags else [])

def _f_feature_flags(name, actions, flagbases = None):
    flagbases = flagbases if flagbases else [name]

    return _feature_flags(
        name = name,
        actions = actions,
        flags = ["-f{}".format(base) for base in flagbases],
        disable_flags = ["-fno-{}".format(base) for base in flagbases],
    )

def f_feature(name, enabled, actions, flag = None):
    flag = flag if flag else name

    return feature(
        name = name,
        enabled = enabled,
        flag_sets = _f_feature_flags(
            name = name,
            actions = actions,
            flagbases = [flag],
        ),
    )

def exclusive_features(configs, actions, enabled = None):
    names = [c["name"] for c in configs]

    if not (not enabled or enabled in names):
        fail("`enabled` must be false or in {}".format(names))

    return [
        feature(
            name = c["name"],
            enabled = enabled == c["name"],
            flag_sets = [
                flag_set(
                    actions = actions,
                    flag_groups = [
                        flag_group(
                            flags = c["flags"],
                        ),
                    ],
                    with_features = [
                        with_feature_set(
                            not_features = [n for n in names if n != c["name"]],
                        ),
                    ],
                ),
            ],
        )
        for c in configs
    ]
