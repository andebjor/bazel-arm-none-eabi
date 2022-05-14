# config/BUILD

load("@arm_none_eabi//:deps.bzl", "targets")

package(default_visibility = ["//visibility:public"])

[
    config_setting(
        name = "{}_compatible".format(cpu),
        constraint_values = [
            "@platforms//os:none",
            "@arm_none_eabi//platforms/cpu:{}".format(cpu),
        ],
    )
    for cpu in targets
]
