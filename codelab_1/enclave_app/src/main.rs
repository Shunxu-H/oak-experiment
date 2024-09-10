#![no_std]
#![no_main]
#![feature(alloc_error_handler)]
#![feature(never_type)]

extern crate alloc;

use alloc::boxed::Box;

use oak_restricted_kernel_sdk::{
    channel::{start_blocking_server, FileDescriptorChannel},
    utils::samplestore::StaticSampleStore,
};

#[oak_restricted_kernel_sdk::entrypoint]
fn start_server() -> ! {
    let mut invocation_stats = StaticSampleStore::<1000>::new().unwrap();
    let service = service::EnclaveImpl {};
    let server = service::proto::EnclaveServiceServer::new(service);
    start_blocking_server(Box::<FileDescriptorChannel>::default(), server, &mut invocation_stats)
        .expect("server encountered an unrecoverable error");
}