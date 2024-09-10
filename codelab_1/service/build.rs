fn main() {
    micro_rpc_build::compile(
        &["proto/service.proto"],
        &[".", "rust_proto_stubs"],
        micro_rpc_build::CompileOptions {
            bytes: vec!["client_message".to_string(), "account_state".to_string()],
            extern_paths: vec![micro_rpc_build::ExternPath::new(
                ".oak.attestation.v1",
                "::oak_proto_rust::oak::attestation::v1",
            )],
            ..Default::default()
        },
    );
}