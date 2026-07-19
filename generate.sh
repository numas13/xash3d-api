#!/bin/sh

set -e

script=$(readlink -f "$0")
root=$(dirname "$script")
cd "$root"

target="${1:-i686-unknown-linux-gnu}"

MSRV=1.64

CFLAGS=""
CFLAGS+=" -target $target"
CFLAGS+=" -Iinclude"
CFLAGS+=" -Ixash3d-fwgs"
CFLAGS+=" -Ixash3d-fwgs/common"
CFLAGS+=" -Ixash3d-fwgs/public"
CFLAGS+=" -Ixash3d-fwgs/pm_shared"
CFLAGS+=" -Ixash3d-fwgs/filesystem"

CFLAGS+=" -Ixash3d-fwgs/engine"
# sound-api: common.h included in engine/platform/platform.h
CFLAGS+=" -Ixash3d-fwgs/engine/common"
# sound-api: avi/avi.h included in engine/common/common.h
CFLAGS+=" -Ixash3d-fwgs/engine/client"

library_suffix_path="3rdparty/library_suffix"
CFLAGS+=" -Ixash3d-fwgs/$library_suffix_path/include"

if [ ! -f "$root/xash3d-fwgs/wscript" ]; then
    git submodule update --init --depth=1 xash3d-fwgs
fi

# library_suffix required since 0dfeea521396c6c99591bb5a32240f7b663ad1e8
if [ ! -f "$root/xash3d-fwgs/$library_suffix_path/wscript" ]; then
    pushd "$root/xash3d-fwgs"
    git submodule update --init --depth=1 "$library_suffix_path"
    popd
fi

function generate() {
    wrapper_h="$1"
    output="$2"
    shift 2
    echo "generate $output ($wrapper_h)"
    mkdir -p "$(dirname "$output")"
    bindgen \
        "include/$wrapper_h" \
        --rust-target $MSRV \
        --use-core \
        --generate-cstr \
        --ignore-functions \
        --no-doc-comments \
        --no-layout-tests \
        --use-array-pointers-in-arguments \
        --default-macro-constant-type signed \
        --blocklist-file "/usr/.*" \
        --blocklist-file "xash3d-fwgs/$library_suffix_path/include/build.h" \
        --blocklist-item "NUM_AMBIENTS" \
        --blocklist-type "mnode_s" \
        --blocklist-type "mnode_s__.*" \
        --blocklist-type "float_bits_[st]" \
        --blocklist-type "vec[234]_t" \
        --blocklist-var "boxpnt" \
        --blocklist-var "gEntityInterface" \
        --blocklist-var "gNewDLLFunctions" \
        --blocklist-var "m_bytenormals" \
        --blocklist-var "svc_.*strings" \
        --opaque-type va_list \
        "$@" -- $CFLAGS > "$output"
}

##############################################################################
# common definitions
##############################################################################

generate "wrapper-common.h" "crates/xash3d-api/src/generated/common.rs" \
    --allowlist-file "xash3d-fwgs/.*" \
    --blocklist-type "netadr_s" \
    --blocklist-type "mstudio.*" \
    --blocklist-var "ATTN_NONE"

generate "wrapper-keys.h" "crates/xash3d-api/src/generated/keys.rs" \
    --allowlist-file "xash3d-fwgs/.*"

##############################################################################
# xash3d-api
##############################################################################

generate "wrapper-player-move.h" "crates/xash3d-api/src/generated/player_move.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/pm_shared/pm_defs.h"

generate "wrapper-net-api.h" "crates/xash3d-api/src/generated/net_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/net_api.h"

generate "wrapper-studio-api.h" "crates/xash3d-api/src/generated/studio_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/r_studioint.h" \
    --allowlist-file "xash3d-fwgs/common/studio_event.h" \
    --allowlist-file "xash3d-fwgs/engine/studio.h"

generate "wrapper-tri-api.h" "crates/xash3d-api/src/generated/tri_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/triangleapi.h"

generate "wrapper-render-api.h" "crates/xash3d-api/src/generated/render_api.rs" \
    --no-recursive-allowlist \
    --blocklist-type "dlight_s" \
    --allowlist-file "xash3d-fwgs/common/lightstyle.h" \
    --allowlist-file "xash3d-fwgs/common/render_api.h"

generate "wrapper-event-api.h" "crates/xash3d-api/src/generated/event_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/event_api.h"

##############################################################################
# xash3d-api-server
##############################################################################

generate "wrapper-server.h" "crates/xash3d-api-server/src/generated/server.rs" \
    --no-recursive-allowlist \
    --allowlist-type "edict_t" \
    --allowlist-type "delta_s" \
    --allowlist-file "xash3d-fwgs/engine/progdefs.h" \
    --allowlist-file "xash3d-fwgs/engine/edict.h" \
    --allowlist-file "xash3d-fwgs/engine/eiface.h"

##############################################################################
# xash3d-api-phys
##############################################################################

generate "wrapper-phys-api.h" "crates/xash3d-api-phys/src/generated/phys_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/engine/physint.h"

##############################################################################
# xash3d-api-client
##############################################################################

generate "wrapper-efx-api.h" "crates/xash3d-api-client/src/generated/efx_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/r_efx.h"

generate "wrapper-sound-api.h" "crates/xash3d-api-client/src/generated/sound_api.rs" \
    --no-recursive-allowlist \
    --allowlist-type "wavdata_[st]" \
    --allowlist-file "xash3d-fwgs/common/sound_api.h"

generate "wrapper-client.h" "crates/xash3d-api-client/src/generated/client.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/ivoicetweak.h" \
    --allowlist-file "xash3d-fwgs/common/demo_api.h" \
    --allowlist-file "xash3d-fwgs/engine/cdll_int.h" \
    --allowlist-file "xash3d-fwgs/engine/cdll_exp.h"

##############################################################################
# xash3d-api-menu
##############################################################################

generate "wrapper-menu.h" "crates/xash3d-api-menu/src/generated/menu.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/common/gameinfo.h" \
    --allowlist-file "xash3d-fwgs/engine/menu_int.h"

##############################################################################
# xash3d-api-ref
##############################################################################

generate "wrapper-fs-api.h" "crates/xash3d-api-ref/src/generated/fs_api.rs" \
    --no-recursive-allowlist \
    --allowlist-file "xash3d-fwgs/filesystem/filesystem.h"

generate "wrapper-render.h" "crates/xash3d-api-ref/src/generated/render.rs" \
    --no-recursive-allowlist \
    --allowlist-type "convar_[st]" \
    --allowlist-file "xash3d-fwgs/common/com_image.h" \
    --allowlist-file "xash3d-fwgs/engine/ref_api.h"
