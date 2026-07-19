#![doc = include_str!("../README.md")]
#![no_std]
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(clippy::type_complexity)]
#![cfg_attr(all(doc, docsrs), feature(doc_cfg))]

pub mod fs {
    use xash3d_api::common::*;

    include!("generated/fs_api.rs");
}

use xash3d_api::common::*;
use xash3d_api::player_move::*;
use xash3d_api::render::*;
use xash3d_api::studio::*;
use xash3d_api::tri::*;

use crate::fs::*;

include!("generated/render.rs");
