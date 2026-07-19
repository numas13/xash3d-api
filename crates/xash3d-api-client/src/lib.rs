#![doc = include_str!("../README.md")]
#![no_std]
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(clippy::type_complexity)]
#![cfg_attr(all(doc, docsrs), feature(doc_cfg))]

#[allow(clippy::missing_safety_doc)]
pub mod sound {
    use xash3d_api::common::*;

    include!("generated/sound_api.rs");
}

use core::{ffi::c_int, mem};

use xash3d_api::common::*;
use xash3d_api::efx::*;
use xash3d_api::event::*;
use xash3d_api::net::*;
use xash3d_api::player_move::*;
use xash3d_api::render::*;
use xash3d_api::studio::*;
use xash3d_api::tri::*;

use crate::sound::*;

include!("generated/client.rs");

impl Default for SCREENINFO {
    fn default() -> SCREENINFO {
        Self {
            iSize: mem::size_of::<Self>() as c_int,
            ..unsafe { mem::zeroed() }
        }
    }
}
