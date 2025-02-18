#
# Copyright 2024 The Project Oak Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

load("@rules_rust//rust:defs.bzl", "rust_library", "rust_test", "rust_test_suite")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],
)

rust_library(
    name = "oak_attestation_verification",
    srcs = glob(["src/**"]),
    compile_data = [
        "//oak_attestation_verification/data:ask_milan.pem",
        "//oak_attestation_verification/data:ask_genoa.pem",
    ],
    deps = [
        "//oak_dice",
        "//oak_proto_rust",
        "//oak_sev_snp_attestation_report",
        "@oak_crates_index//:anyhow",
        "@oak_crates_index//:base64",
        "@oak_crates_index//:coset",
        "@oak_crates_index//:ecdsa",
        "@oak_crates_index//:getrandom",
        "@oak_crates_index//:hex",
        "@oak_crates_index//:p256",
        "@oak_crates_index//:p384",
        "@oak_crates_index//:prost",
        "@oak_crates_index//:rsa",
        "@oak_crates_index//:serde",
        "@oak_crates_index//:serde_json",
        "@oak_crates_index//:sha2",
        "@oak_crates_index//:time",
        "@oak_crates_index//:x509-cert",
        "@oak_crates_index//:zerocopy",
    ],
)

rust_test(
    name = "oak_attestation_verification_test",
    crate = ":oak_attestation_verification",
    crate_features = ["bazel"],  # TODO: b/333064338 remove.
    data = [
        "//oak_attestation_verification/testdata:endorsement.json",
    ],
)

filegroup(
    name = "test_data",
    srcs = [
        "//oak_attestation_verification/data:ark_genoa.pem",
        "//oak_attestation_verification/data:ark_milan.pem",
        "//oak_attestation_verification/data:ask_genoa.pem",
        "//oak_attestation_verification/data:ask_milan.pem",
        "//oak_attestation_verification/testdata:cb_endorsement.binarypb",
        "//oak_attestation_verification/testdata:cb_evidence.binarypb",
        "//oak_attestation_verification/testdata:cb_reference_values.binarypb",
        "//oak_attestation_verification/testdata:endorsement.json",
        "//oak_attestation_verification/testdata:endorsement.json.sig",
        "//oak_attestation_verification/testdata:fake_evidence.binarypb",
        "//oak_attestation_verification/testdata:fake_expected_values.binarypb",
        "//oak_attestation_verification/testdata:genoa_oc_evidence.binarypb",
        "//oak_attestation_verification/testdata:genoa_oc_reference_values.binarypb",
        "//oak_attestation_verification/testdata:logentry.json",
        "//oak_attestation_verification/testdata:oak-development.pem",
        "//oak_attestation_verification/testdata:oak_containers_stage1.pem",
        "//oak_attestation_verification/testdata:oc_evidence.binarypb",
        "//oak_attestation_verification/testdata:oc_vcek_milan.der",
        "//oak_attestation_verification/testdata:oc_vcek_milan.pem",
        "//oak_attestation_verification/testdata:rekor_public_key.pem",
        "//oak_attestation_verification/testdata:rk_evidence.binarypb",
        "//oak_attestation_verification/testdata:rk_evidence_20240312.binarypb",
        "//oak_attestation_verification/testdata:rk_vcek_milan.der",
        "//oak_attestation_verification/testdata:vcek_genoa.der",
    ],
)

rust_test_suite(
    name = "integration_tests",
    srcs = glob(["tests/**"]),
    crate_features = ["bazel"],  # TODO: b/333064338 remove.
    data = [":test_data"],
    deps = [
        ":oak_attestation_verification",
        "//oak_attestation_verification_test_utils",
        "//oak_proto_rust",
        "@oak_crates_index//:anyhow",
        "@oak_crates_index//:hex",
        "@oak_crates_index//:prost",
        "@oak_crates_index//:x509-cert",
    ],
)

rust_library(
    name = "oak_attestation_verification_with_regex",
    srcs = glob(["src/**"]),
    compile_data = [
        "//oak_attestation_verification/data:ask_milan.pem",
        "//oak_attestation_verification/data:ask_genoa.pem",
    ],
    crate_features = ["regex"],
    crate_name = "oak_attestation_verification",
    deps = [
        "//oak_dice",
        "//oak_proto_rust",
        "//oak_sev_snp_attestation_report",
        "@oak_crates_index//:anyhow",
        "@oak_crates_index//:base64",
        "@oak_crates_index//:coset",
        "@oak_crates_index//:ecdsa",
        "@oak_crates_index//:getrandom",
        "@oak_crates_index//:hex",
        "@oak_crates_index//:p256",
        "@oak_crates_index//:p384",
        "@oak_crates_index//:prost",
        "@oak_crates_index//:regex-lite",
        "@oak_crates_index//:rsa",
        "@oak_crates_index//:serde",
        "@oak_crates_index//:serde_json",
        "@oak_crates_index//:sha2",
        "@oak_crates_index//:time",
        "@oak_crates_index//:x509-cert",
        "@oak_crates_index//:zerocopy",
    ],
)

rust_test(
    name = "oak_attestation_verification_with_regex_test",
    crate = ":oak_attestation_verification_with_regex",
    crate_features = ["bazel"],  # TODO: b/333064338 remove.
    data = [
        "//oak_attestation_verification/testdata:endorsement.json",
    ],
)

rust_test_suite(
    name = "integration_tests_with_regex",
    srcs = glob(["tests/**"]),
    crate_features = [
        "regex",
        "bazel",
    ],  # TODO: b/333064338 remove bazel feature.
    data = [":test_data"],
    deps = [
        ":oak_attestation_verification_with_regex",
        "//oak_attestation_verification_test_utils",
        "//oak_proto_rust",
        "@oak_crates_index//:anyhow",
        "@oak_crates_index//:hex",
        "@oak_crates_index//:prost",
        "@oak_crates_index//:x509-cert",
    ],
)
