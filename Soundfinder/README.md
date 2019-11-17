# Soundfinder.js - A hotkey-based youtube manipulator.

Self-Signed firefox browser extension. 

Works with music.youtube.com and www.youtube.com

Scoping works as follows:
- First checks to see if audio is playing. If so, scopes to that page.
- If on a youtube page, scopes to that.
 - If firefox isn't selected, scopes to last used window.
- If ambiguous, scopes to music.youtube.com page, if it exists. If multiple, goes to the one with the lowest page ID. (First opened, if I'm correct.)

See manifest.json for more info on hotkeys.