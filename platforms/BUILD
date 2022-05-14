# platforms/BUILD

load("@arm_none_eabi//:deps.bzl", "targets")

package(default_visibility = ["//visibility:public"])

alias(
    name = "arm_none_generic",
    actual = ":arm",
)

[
    platform(
        name = cpu,
        constraint_values = [
            "@platforms//os:none",
            "@arm_none_eabi//platforms/cpu:{}".format(cpu),
        ],
    )
    for cpu in targets
]
