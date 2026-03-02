# Physics Tuning Guide

This guide helps you tune the fulcrum platformer physics for optimal gameplay feel.

## FulcrumLever Settings

Located in: `scenes/fulcrum_lever.tscn` (FulcrumSystem/FulcrumLever node) and `scripts/fulcrum_lever.gd`

- **mass**: `20.0` - Base mass of the lever (lighter = more responsive to characters)
- **lever_length**: `400.0` - Half-length from center to each end (affects torque leverage)
- **max_rotation_angle**: `60.0` - Maximum tilt angle in degrees (30-70° recommended)
- **angular_damping_value**: `2.0` - Resistance to rotation (higher = less spinning, 1-5 recommended)

### Tuning Tips:
- If the lever spins too much: increase `angular_damping_value`
- If characters don't affect it enough: decrease `mass` or increase character `mass`
- If it tips too easily: decrease `max_rotation_angle`

## LeverSurface Settings

Located in: `scenes/fulcrum_lever.tscn` and `scripts/lever_surface.gd`

- **surface_friction**: `0.8` - Friction coefficient (0-1, affects sliding)
- **slide_angle_threshold**: `25.0` - Angle in degrees where sliding starts (15-35° recommended)
- **surface_offset**: `20.0` - Distance above lever surface to snap characters (10-30 recommended)

### Tuning Tips:
- If characters slide too easily: increase `slide_angle_threshold`
- If characters don't slide enough: decrease `slide_angle_threshold`
- If characters jitter on lever: adjust `surface_offset` or `snap_strength` in LeverAffector

## LeverAffector Settings

Located in: `scenes/player.tscn`, `scenes/enemy.tscn`, and `scripts/lever_affector.gd`

- **mass**: `50.0` - Character mass for torque calculation (30-100 recommended)
- **jump_impulse**: `600.0` - Force when jumping (400-800 recommended)
- **slam_impulse_multiplier**: `3.0` - Slam force multiplier (2-5 recommended)
- **slide_acceleration**: `200.0` - Speed of sliding on angled lever (100-400 recommended)
- **launch_angular_velocity_threshold**: `2.0` - Min angular velocity to launch (1-4 recommended)
- **snap_strength**: `0.3` - How quickly character snaps to lever (0.1-0.5 recommended)

### Tuning Tips:
- If characters don't affect lever enough: increase `mass`
- If jumps don't create enough reaction: increase `jump_impulse`
- If slams are too weak: increase `slam_impulse_multiplier`
- If characters aren't launched: decrease `launch_angular_velocity_threshold`
- If characters jitter: decrease `snap_strength`

## CharacterBase Settings

Located in: `scenes/player.tscn`, `scenes/enemy.tscn`, and `scripts/character_base.gd`

- **move_speed**: `200.0` - Horizontal movement speed (150-300 recommended)
- **jump_velocity**: `-500.0` - Upward velocity when jumping (-400 to -600 recommended)
- **gravity_value**: `980.0` - Gravity acceleration (default 980, adjust for game feel)

### Tuning Tips:
- If movement feels sluggish: increase `move_speed`
- If jumps are too weak/strong: adjust `jump_velocity`
- If characters fall too fast/slow: adjust `gravity_value`

## Common Issues and Solutions

### Issue: Lever spins uncontrollably
**Solutions:**
1. Increase `angular_damping_value` (try 3-5)
2. Decrease character `mass` (try 30-40)
3. Add more friction by reducing max angle

### Issue: Characters jitter on rotating lever
**Solutions:**
1. Decrease `snap_strength` (try 0.1-0.2)
2. Increase `surface_offset` (try 25-35)
3. Enable interpolation in character movement

### Issue: Characters don't affect lever enough
**Solutions:**
1. Increase character `mass` (try 70-100)
2. Decrease lever `mass` (try 10-15)
3. Increase torque calculation multipliers in code

### Issue: Launch velocities feel wrong
**Solutions:**
1. Adjust `launch_angular_velocity_threshold` (lower = easier to launch)
2. Modify velocity calculation in `get_velocity_at_position()`
3. Add velocity multipliers or clamps

### Issue: Sliding feels unnatural
**Solutions:**
1. Adjust `slide_angle_threshold` (25° is middle ground)
2. Modify `slide_acceleration` for faster/slower sliding
3. Add friction multipliers based on character state

## Testing Checklist

- [ ] Player can stand on lever and affect its balance
- [ ] Multiple characters create appropriate tipping
- [ ] Jumping creates noticeable counter-force
- [ ] Slamming creates strong impact
- [ ] Characters slide off when lever is too angled
- [ ] Characters launch when lever swings fast enough
- [ ] Lever doesn't spin out of control
- [ ] Characters don't jitter or vibrate on lever
- [ ] Movement feels responsive and fun
- [ ] AI enemies interact properly with lever

## Recommended Starting Tuning Order

1. **Basic Balance**: Adjust `mass` values (lever and characters) until standing affects balance nicely
2. **Rotation Limits**: Set `max_rotation_angle` so the lever feels dynamic but not chaotic
3. **Damping**: Tune `angular_damping_value` to prevent over-spinning
4. **Jumping**: Adjust `jump_impulse` and `jump_velocity` for satisfying jumps
5. **Slamming**: Tune `slam_impulse_multiplier` for impactful slams
6. **Sliding**: Set `slide_angle_threshold` and `slide_acceleration` for intuitive sliding
7. **Launching**: Adjust `launch_angular_velocity_threshold` for fun catapult moments
8. **Polish**: Fine-tune `snap_strength` and `surface_offset` to eliminate jitter
