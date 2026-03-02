# Fulcrum Platformer - Component-Based Physics System

A 2D sideview action platformer featuring a physics-based fulcrum/lever system where players and enemies balance, jump, slam, and launch each other through dynamic interactions.

## Core Concept

Players and enemies stand on a lever that rotates around a central pivot point. Their position and mass affect the balance, creating a dynamic see-saw effect. Characters can:
- **Stand/Move**: Continuous torque based on position and mass
- **Jump**: Creates counter-torque, affecting lever balance
- **Slam**: Land with extra force for powerful impacts
- **Slide**: Automatically slide down steep angles
- **Launch**: Get catapulted when the lever swings fast enough

### Core Components

1. **FulcrumSystem** (`Node2D`)
   - Container for the entire fulcrum mechanism
   - **FulcrumPoint** (`StaticBody2D`) - Fixed pivot point
   - **FulcrumLever** (`RigidBody2D`) - Main lever with physics simulation
   - **PinJoint2D** - Connects the StaticBody2D pivot to the RigidBody2D lever
   - Provides angle and velocity information

2. **CharacterBase** (`CharacterBody2D`)
   - Base class with state machine
   - Standard platformer movement
   - Jump and slam abilities

3. **Player** (extends `CharacterBase`)
   - Handles keyboard input
   - Controls: Arrow keys to move, Space/Up to jump, Down to slam

4. **Enemy** (extends `CharacterBase`)
   - Simple AI for patrol and random actions
   - Occasionally jumps and slams

