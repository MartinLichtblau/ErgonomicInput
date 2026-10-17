# Bug: TrackPoint middle-button scrolling prevents dragging

Reported: 2026-10-17

## Environment

- Windows
- Lenovo ThinkPad TrackPoint Keyboard II
- Lenovo settings: Keyboard Properties > External TrackPoint Keyboard (`Externe TrackPoint-Tastatur`)
- AutoHotkey mapping: `Autohotkey/scripts/global/trackpad/Trackpad.ahk`

## Summary

The physical middle button is mapped to left-button down/up. Clicking works, but holding the middle button and moving the TrackPoint scrolls instead of moving the pointer. This prevents dragging with the TrackPoint.

## Reproduction

1. Run the repository's AutoHotkey script.
2. Hold the keyboard's middle button over a draggable item.
3. Move the TrackPoint: the gesture produces scrolling rather than pointer movement, preventing the drag.
4. Keeping the middle button held, move the touchpad instead: dragging works.
5. Exit AutoHotkey and repeat the middle-button + TrackPoint gesture: scrolling still occurs.

## Expected behavior

For the remapping to support dragging, TrackPoint motion must continue moving the pointer while the synthetic left button is held.

## Confirmed observations

- The middle-to-left click mapping works.
- Touchpad movement allows dragging while the remapped middle button is held.
- TrackPoint movement while the middle button is held produces scrolling, including with AutoHotkey exited.
- Toggling `ThinkPad - bevorzugt. Blättern` (ThinkPad preferred scrolling) changes the scrolling mode/cursor, but disabling it does not stop this behavior.

## Suspected cause

The Lenovo driver or keyboard firmware appears to convert TrackPoint motion into scrolling while the physical middle button is held. The exact layer has not been confirmed. The behavior with AutoHotkey exited shows that the scrolling is not solely caused by the script.

## Workaround under test

Use `RButton & MButton` or `MButton & RButton` to set `LButtonLocked` and send left-button down. Release both physical buttons before moving the TrackPoint, then click middle again to release the synthetic left button and drop.

This avoids physically holding the middle button while moving the TrackPoint. The workaround has been implemented in `Trackpad.ahk`, but successful operation on the hardware has not yet been confirmed.