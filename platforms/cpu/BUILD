# platforms/cpu/BUILD

load("@arm_none_eabi//:deps.bzl", "targets")

package(default_visibility = ["//visibility:public"])

[
    alias(
        name = cpu,
        actual = "@platforms//cpu:{}".format(cpu),
    ) if cpu.startswith("arm") else constraint_value(
        name = cpu,
        constraint_setting = "@platforms//cpu",
    )
    for cpu in targets
]
