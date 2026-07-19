#![doc = include_str!("../README.md")]
#![no_std]
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(clippy::type_complexity)]
#![cfg_attr(all(doc, docsrs), feature(doc_cfg))]

use xash3d_api::common::*;
use xash3d_api::net::*;

include!("generated/menu.rs");
