---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Touchpad: 3-finger horizontal swipe switches workspaces (macOS style)
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Touchscreen: Hyprland has no multi-finger touchscreen gestures, only a
-- one-finger swipe in from the left/right screen edge
hl.config({
    gestures = {
        workspace_swipe_touch = true,
    },
})
