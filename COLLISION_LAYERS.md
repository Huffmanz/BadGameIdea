# Collision Layers Reference

## Layer Assignments

| Layer | Name | Used By | Purpose |
|-------|------|---------|---------|
| 1 | World | Ground, Walls, Platforms | Static environment collisions |
| 2 | Characters | Player, Enemy | Dynamic character collisions |
| 3 | (Unused) | - | Reserved for future use |
| 4 | Lever System | FulcrumLever, LeverSurface | Lever physics and detection |

## Object Configuration

### Characters (Player, Enemy)

```gdscript
collision_layer = 2  # They exist on layer 2
collision_mask = 13  # They detect layers 1, 2, and 4 (binary: 1101)
```

**What this means:**
- Characters can collide with each other (layer 2)
- Characters can collide with ground, walls, platforms (layer 1)
- Characters can physically collide with the lever (layer 4)
- Characters can be detected by LeverSurface (which masks layer 2)

**Why layer 2?** This separates characters from world geometry, preventing the lever from colliding with walls/ground.

### FulcrumLever (RigidBody2D)

```gdscript
collision_layer = 4  # It exists on layer 4
collision_mask = 2   # It detects layer 2 (characters ONLY)
```

**What this means:**
- Lever exists separately from characters/world
- Lever can physically collide with CHARACTERS (layer 2)
- Lever does NOT collide with walls/ground (layer 1)
- This prevents unwanted collisions that cause jittering

### LeverSurface (Area2D)

```gdscript
collision_layer = 4  # It exists on layer 4
collision_mask = 2   # It ONLY detects layer 2 (characters)
```

**What this means:**
- LeverSurface can detect characters entering/exiting
- LeverSurface does NOT detect its parent (FulcrumLever)
- LeverSurface does NOT detect walls/ground
- This prevents the "detecting itself" bug and unwanted detections

### Ground, Walls, Platforms (StaticBody2D)

```gdscript
collision_layer = 1  # Default, on layer 1
collision_mask = 1   # Default, detects layer 1
```

**What this means:**
- World geometry is on the same layer as characters
- Simple and straightforward collision

## Binary Layer Explanation

Collision masks use binary representation:

| Binary | Decimal | Layers Detected |
|--------|---------|----------------|
| 0001 | 1 | Layer 1 only |
| 0010 | 2 | Layer 2 only |
| 0011 | 3 | Layers 1 and 2 |
| 0100 | 4 | Layer 3 only |
| 0101 | 5 | Layers 1 and 4 |
| 1000 | 8 | Layer 4 only |
| 1111 | 15 | All layers |

**Example:** collision_mask = 13
- Binary: 1101
- Bit 0 (value 1) = Layer 1 ✓
- Bit 1 (value 2) = Layer 2 ✓
- Bit 2 (value 4) = Layer 3 ✗
- Bit 3 (value 8) = Layer 4 ✓
- Result: Detects layers 1, 2, and 4

## Why This Setup?

### Problems We Solved
1. **LeverSurface detecting itself**: Originally on same layer, causing false detections
2. **Lever colliding with walls/ground**: Was causing unpredictable movement

### Solution Benefits
1. **Clean Separation**: Each type of object on its own layer
   - Layer 1: Static world (doesn't move)
   - Layer 2: Dynamic characters (move around)
   - Layer 4: Lever system (rotates only)
2. **Selective Detection**: LeverSurface only sees characters, not itself or walls
3. **No Unwanted Collisions**: Lever only collides with characters, not environment
4. **Stable Lever**: No random forces from ground/wall collisions
5. **Extensible**: Layer 3 available for future features (projectiles, hazards, etc.)

## Future Extensions

### Adding More Layers

If you need additional object types:

**Layer 2 - Projectiles:**
```gdscript
collision_layer = 2
collision_mask = 1  # Hit characters only
```

**Layer 3 - Environmental Hazards:**
```gdscript
collision_layer = 3
collision_mask = 1  # Detect characters
```

Then update character collision_mask:
```gdscript
collision_mask = 15  # Binary 1111 = detect all layers
```

## Debugging Collision Layers

### In Godot Editor
1. Select a node with collision
2. Look at Inspector panel
3. Find "Collision" section
4. Click the grid of checkboxes to see/modify layers

### In Game
Enable "Visible Collision Shapes" from Debug menu to see what's colliding.

### Console Output
Our debug code prints when bodies enter LeverSurface. If you see wrong bodies, check their layer configuration.

## Common Issues

### "My object isn't colliding"
- Check collision_layer (where it exists)
- Check collision_mask (what it detects)
- Objects must be on each other's mask to collide

### "Area2D not detecting"
- Area2D collision_mask must include the layer of target objects
- Target objects must have collision_layer set

### "Detecting too many things"
- Narrow the collision_mask to only needed layers
- Separate object types onto different layers
