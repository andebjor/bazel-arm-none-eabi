# toolchains/BUILD.bazel

load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")
load("@arm_none_eabi//toolchain:config.bzl", "cross_toolchain")
load("@arm_none_eabi//:deps.bzl", "hosts", "targets")

[
    cross_toolchain(
        host_os = host.partition("_")[0],
        host_cpu = host.partition("_")[-1],
        target_cpu = target_cpu,
    )
    for host in hosts
    for target_cpu in targets
]
