package(default_visibility = ["//visibility:public"])

cc_library(
    name = "semihosting",
    srcs = ["src/semihosting.cpp"],
    hdrs = ["semihosting.hpp"],
    include_prefix = "arm",
    linkopts = [
        "-specs=rdimon.specs",
    ],
    linkstatic = True,
)
