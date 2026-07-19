#![doc = include_str!("../README.md")]
#![no_std]
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(clippy::type_complexity)]
#![cfg_attr(all(doc, docsrs), feature(doc_cfg))]

use xash3d_api::common::*;
use xash3d_api::player_move::*;
use xash3d_api::render::*;
use xash3d_api::tri::*;

use xash3d_api_server::SAVERESTOREDATA;

include!("generated/phys_api.rs");

pub type PHYSICAPI = Option<
    unsafe extern "C" fn(
        version: core::ffi::c_int,
        eng_funcs: *mut server_physics_api_t,
        dll_funcs: *mut physics_interface_t,
    ) -> core::ffi::c_int,
>;
