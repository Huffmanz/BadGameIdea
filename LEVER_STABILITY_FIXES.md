# Lever Stability Fixes

## Problem: Lever Moving Unpredictably

The lever was moving/rotating randomly even when the player wasn't on it. This was caused by several issues.

## Root Causes Identified

### 1. Collision with Ground/Walls
The lever (layer 4, mask 1) was colliding with ground and walls (layer 1), causing random impulses that made it jitter and rotate unpredictably.

### 2. Characters and World on Same Layer
Originally:
- Ground, walls = layer 1
- Characters = layer 1  
- Lever mask = layer 1 (collided with EVERYTHING)

The lever couldn't distinguish between "things to collide with" (characters) and "things to ignore" (walls/ground).

### 3. No Damping for Small Movements
Tiny velocities accumulated over time, causing drift even when no forces were applied.

### 4. No Return-to-Neutral Mechanism
When all characters left the lever, it would stay tilted instead of returning to horizontal.

## Solutions Applied

### Solution 1: Separate Collision Layers

**New Layer Setup:**
- **Layer 1**: Static world (ground, walls, platforms) - doesn't move
- **Layer 2**: Dynamic characters (player, enemy) - move around
- **Layer 4**: Lever system - rotates only

**Character Configuration:**
```gdscript
collision_layer = 2   # Characters exist on layer 2
collision_mask = 13   # Detect layers 1 (world), 2 (other characters), 4 (lever)
```

**Lever Configuration:**
```gdscript
collision_layer = 4   # Lever exists on layer 4
collision_mask = 2    # ONLY detect layer 2 (characters), NOT layer 1 (walls/ground)
```

**LeverSurface Configuration:**
```gdscript
collision_layer = 4   # On same layer as lever
collision_mask = 2    # ONLY detect layer 2 (characters)
```

**Result:** Lever can physically collide with characters (to support them) but completely ignores walls and ground, preventing unwanted impulses.

### Solution 2: Velocity Damping

Added automatic damping for tiny movements in `fulcrum_lever.gd`:

```gdscript
# Dampen small movements to prevent drift
if abs(angular_velocity) < 0.01:
    angular_velocity = 0.0
if linear_velocity.length() < 0.1:
    linear_velocity = Vector2.ZERO
```

**Result:** Small accumulated velocities are zeroed out, preventing slow drift.

### Solution 3: Initial State Reset

Added initialization in `_ready()`:

```gdscript
linear_velocity = Vector2.ZERO
angular_velocity = 0.0
rotation = 0.0
```

**Result:** Lever always starts in a clean, stable state.

### Solution 4: Return to Neutral

Added automatic return-to-neutral when no characters are on the lever:

```gdscript
# If no one is on the lever, slowly return to neutral
if not lever_surface.has_active_affectors():
    var angle = rotation
    if abs(angle) > 0.01:
        var return_torque = -angle * 500.0
        apply_torque(return_torque)
```

**Result:** Lever gradually returns to horizontal position when empty, providing more intuitive behavior.

### Solution 5: Increased Angular Damping

Changed `angular_damp` from `2.0` to `3.0` for more stability.

**Result:** Lever doesn't swing as wildly, settles faster.

### Solution 6: High Linear Damping

Set `linear_damp = 10.0` to strongly resist any translational movement.

**Result:** Even if something tries to push the lever, it resists moving from its position.

## Expected Behavior Now

### When No One is On the Lever:
- ✓ Lever stays horizontal (or returns to horizontal if tilted)
- ✓ No random movement or rotation
- ✓ Completely stable and still

### When Player Lands On Lever:
- ✓ Lever tilts toward the player
- ✓ Smooth, predictable rotation
- ✓ No jittering or sudden jumps

### When Player Moves On Lever:
- ✓ Torque changes smoothly with position
- ✓ Lever responds predictably
- ✓ No interaction with walls/ground

### When Player Leaves Lever:
- ✓ Lever gradually returns to horizontal
- ✓ Smooth deceleration
- ✓ No abrupt snapping

## Verification Checklist

Run the game and verify:

- [ ] Lever starts perfectly horizontal
- [ ] Lever doesn't move when player is on the ground (not on lever)
- [ ] Lever tilts smoothly when player lands on it
- [ ] No console errors about missing nodes
- [ ] No jittering or vibration
- [ ] Lever returns to horizontal after player jumps off
- [ ] Moving left/right on lever changes tilt smoothly
- [ ] No random rotation when idle

## If Problems Persist

### Lever Still Jitters
1. Check "Visible Collision Shapes" in Debug menu
2. Verify no collision shapes overlap or have offsets
3. Increase `angular_damp` to 4.0 or 5.0
4. Check PinJoint2D is properly connected

### Lever Doesn't Return to Neutral
1. Check console for errors about `has_active_affectors`
2. Verify LeverSurface is properly detecting body_exit
3. Increase return torque multiplier (try 1000.0 instead of 500.0)

### Lever Moves Instead of Rotating
1. Verify `linear_damp = 10.0`
2. Check PinJoint2D `softness = 0.0` and `bias = 0.9`
3. Ensure both bodies have no position offsets on collision shapes

### Player Falls Through Lever
1. Check player `collision_mask` includes layer 4 (should be 13)
2. Check lever `collision_mask` includes layer 2 (should be 2)
3. Verify collision shapes are present and enabled

## Technical Summary

The key insight was separating **static world geometry** (layer 1) from **dynamic characters** (layer 2), allowing the lever (layer 4) to selectively interact with only the characters. This eliminates all unwanted collision forces while maintaining the necessary physical support for characters standing on the lever.

Combined with velocity damping and return-to-neutral behavior, the lever now behaves in a stable, predictable manner that feels natural and responsive to player actions.
