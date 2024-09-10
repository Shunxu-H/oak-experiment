#![no_std]
#![feature(never_type)]

extern crate alloc;

use alloc::format;
use log::info;
use oak_attestation::dice::evidence_to_proto;
use oak_restricted_kernel_sdk::attestation::{EvidenceProvider, InstanceEvidenceProvider};

use crate::proto::{
    EchoRequest, EchoResponse, GetEvidenceRequest, GetEvidenceResponse, EnclaveService,
};

pub mod proto {
    #![allow(dead_code)]
    use prost::Message;
    include!(concat!(env!("OUT_DIR"), "/sealed.codelabs.enclave.rs"));
}

#[derive(Default)]
pub struct EnclaveImpl {}

impl EnclaveService for EnclaveImpl {
    fn echo(&mut self, request: EchoRequest) -> Result<EchoResponse, micro_rpc::Status> {
        let msg: &[u8] = request.msg.as_ref();
        info!("Received a request, size: {}", msg.len());
        Ok(EchoResponse { msg: msg.to_vec() })
    }

    fn get_evidence(
        &mut self,
        _request: GetEvidenceRequest,
    ) -> Result<GetEvidenceResponse, micro_rpc::Status> {
        let evidence = evidence_to_proto(
            InstanceEvidenceProvider::create()
                .expect("couldn't get evidence")
                .get_evidence()
                .clone(),
        )
        .map_err(|err| {
            micro_rpc::Status::new_with_message(
                micro_rpc::StatusCode::Internal,
                format!("failed to convert evidence to proto: {err}"),
            )
        })?;
        Ok(GetEvidenceResponse { evidence: Some(evidence) })
    }
}