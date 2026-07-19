#![doc = include_str!("../README.md")]
#![no_std]
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(clippy::type_complexity)]
#![cfg_attr(all(doc, docsrs), feature(doc_cfg))]

#[cfg(feature = "std")]
extern crate std;

#[macro_use]
mod macros;

pub mod common;

pub mod keys {
    //! Key numbers definitions.
    include!("generated/keys.rs");
}

#[cfg(feature = "studio-api")]
pub mod studio {
    use crate::common::*;

    include!("generated/studio_api.rs");
}

#[cfg(feature = "render-api")]
pub mod render {
    use crate::common::*;
    use crate::studio::*;

    include!("generated/render_api.rs");
}

#[cfg(feature = "net-api")]
pub mod net {
    use crate::common::*;

    include!("generated/net_api.rs");
}

#[cfg(feature = "tri-api")]
pub mod tri {
    use crate::common::*;

    include!("generated/tri_api.rs");
}

#[cfg(feature = "event-api")]
pub mod event {
    use crate::common::*;
    use crate::player_move::*;

    include!("generated/event_api.rs");
}

#[cfg(feature = "player-move")]
pub mod player_move {
    use crate::common::*;

    include!("generated/player_move.rs");
}

#[cfg(feature = "glam")]
pub use glam;
