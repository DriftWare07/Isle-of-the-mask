# Godot Jump buffer

This plugin adds a node for jump buffering (remembering a player's jump input, so if they press jump right before landing the character still jumps).

## API

### Export variables

- **jump_action_name:** The name of the jump action in your game.

- **buffer_time:** The amount of time before the the input is discarded.

### Functions

- **reset:** Discards the input immediately, useful for actions you dont't want the player to jump after, like the stomp machanic in the demo
