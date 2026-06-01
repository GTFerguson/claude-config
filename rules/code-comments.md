# Code Comments Rules

Code comments should be meaningful, self-contained, and future-proof. Anyone reading the code years from now—without access to internal planning documents, issue trackers, or project history—should understand why the code exists.

## Core Principle: WHY, Not WHAT

Comments should explain **why** code exists or **why** a non-obvious approach was taken. The code itself shows **what** it does.

**Bad - Describes what the code does:**
```python
# Increment counter
counter += 1

# Loop through all items
for item in items:
```

**Good - Explains why:**
```python
# Prevent division by zero when collection is empty
if len(items) == 0:
    return default_value

# Process oldest items first to ensure fair resource distribution
items.sort(key=lambda x: x.created_at)
```

## Avoid Marker Comments

Do not use comments that reference internal tracking systems, planning documents, or development phases. These become meaningless once the referenced context is gone.

**Bad - Internal references:**
```python
# Phase 2 implementation
# C-005 fix
# Issue #123
# per refactor-plan.md
# Step 3 of migration
# fix: calculation bug
# DRY refactoring:
```

**Good - Self-contained explanation:**
```python
# Uses logarithmic scaling to prevent runaway growth
# at high values while maintaining linear behavior at low values

# Fallback to default config when user data is unavailable
```

## @todo Comments

`@todo` is acceptable when it describes genuine future work that the code needs. The comment should be self-explanatory.

**Bad - Vague or tracking-style:**
```python
# @todo Phase 3
# @todo fix later
# @todo see issue #456
```

**Good - Clear and actionable:**
```python
# @todo Add Windows support when path handling is unified
# @todo Consider caching this result if profiling shows it's a bottleneck
# @todo Handle edge case where config file is malformed
```

## When to Comment

Add comments when:
- The code uses a non-obvious algorithm or approach
- There's important context that isn't clear from the code
- A workaround exists for a subtle bug or limitation
- Performance or correctness depends on something non-obvious

**Good examples:**
```python
# Using weak reference to break circular dependency between components
self._parent = weakref.ref(parent)

# Must validate input before processing - external data may be malformed
if not self._validate(data):
    raise ValueError("Invalid input format")

# Intentionally using integer division to snap to grid boundaries
tile_x = world_x // TILE_SIZE
```

## When NOT to Comment

Don't add comments when:
- The code is self-explanatory
- You're just restating what the code does
- You're marking sections for yourself during development

**Unnecessary comments:**
```python
# Constructor
def __init__(self):
    pass

# Getter for name
def get_name(self):
    return self._name

# Check if empty
if len(items) == 0:
```

## Don't State Facts the Code Can Drift Away From

A comment that asserts a concrete dimension, threshold, behavior, or guarantee is untested prose. The moment the code changes, the comment silently becomes a lie, and the next reader trusts it. Comments like `// 48x48 grid (<= 2304 nodes)`, `// all failure modes log a warning`, `// cost is paid in essentia`, or `// callers always pass a valid id` are landmines: each describes something nothing enforces.

If a value or guarantee matters enough to write down, pin it where it cannot drift:

- **A concrete value** → a named constant; reference the constant in prose, not the literal.
- **An invariant or guarantee** → an assertion, a type, or a test that fails when it is violated.
- **A behavior** ("logs on failure", "clamps out-of-range") → let the code show it, or write a test that asserts it.

Reserve prose for the WHY the code genuinely can't express. State a number or a promise in a comment only when something else actually enforces it.

**Bad - prose asserting behavior nothing keeps honest:**
```cpp
// Dijkstra on a 48x48 grid (<= 2304 nodes)   // default later became 100 — comment now lies
// All failure modes log a warning            // the function logs nothing
```

**Good - the code or a constant carries the fact:**
```cpp
// Output grid is local_size x local_size.
static constexpr unsigned kDefaultLocalSize = 100;
```

## Summary

| Do | Don't |
|----|-------|
| Explain WHY | Describe WHAT |
| Write for future readers | Reference internal docs/issues |
| Use @todo for genuine future work | Use @todo as a tracking system |
| Comment non-obvious decisions | Comment obvious code |
| Make comments self-contained | Assume reader has project context |
| Pin values & guarantees in constants/tests | State a dimension or promise only a comment enforces |
