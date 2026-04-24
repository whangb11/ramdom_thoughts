# Godot 4.6 Project — ramdom_thoughts

## Stack
- Godot 4.6 (Forward Plus renderer, Jolt Physics, D3D12 on Windows)
- GDScript — no static typing, no type checking, no linter
- No CI, no tests, no build scripts

## Structure
- `scenes/main/main.tscn` — entry point (referenced in project.godot)
- `scenes/player/player.gd` — CharacterBody3D with WASD + space/C movement, camera-relative motion
- `addons/Todo_Manager/` and `addons/script-ide/` — third-party addons (enabled in project.godot)

## Workflow
- Open the `.godot` folder in Godot Editor to run/edit
- No command-line build or test commands apply here

## Editing
- `project.godot` config_version=5 — do not edit manually; use Godot Editor UI
- Input actions (ui_*, movement_*) are defined in project.godot `[input]` section