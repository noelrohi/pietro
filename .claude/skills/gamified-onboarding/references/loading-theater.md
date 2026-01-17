# Loading Theater

## Intent

Create artificial wait times that build perceived value. When users see "work being done," they value the output more than instant results.

## The psychology

- **Labor illusion:** Visible effort = perceived value
- **Expectation setting:** Wait creates anticipation
- **Attention capture:** Ideal time to request permissions (ATT, notifications)

## Plan generation pattern

The most common loading theater in onboarding:

```
┌─────────────────────────────────┐
│           68%                   │
│                                 │
│   We're creating a              │
│   personal plan for you         │
│                                 │
│   ████████████░░░░░░░░░         │
│   [Evaluating your rank...]     │
│                                 │
│  Status                         │
│  Physical Attributes      ✓     │
│  Fitness Level           ✓     │
│  Power Analysis          ✓     │
│  Rank Calibration        ○     │
│  Workout Generation      ○     │
│                                 │
│   🏆 Over 100,000+              │
│      Programs Generated         │
└─────────────────────────────────┘
```

## Checklist animation

Items check off one by one with delays:

```
Timeline:
0.0s: Screen appears, 0%
0.5s: "Physical Attributes" ✓, 15%
1.5s: "Fitness Level" ✓, 30%
2.5s: "Power Analysis" ✓, 50%
3.5s: "Rank Calibration" ✓, 75%
4.5s: "Workout Generation" ✓, 100%
5.0s: Transition to next screen
```

## Status text rotation

The subtitle under the progress bar cycles:

```
"Analyzing your data..."
"Calculating optimal plan..."
"Evaluating your rank..."
"Generating workouts..."
"Finalizing your program..."
```

Each text change happens every 1-2 seconds.

## Progress bar behavior

### Linear progress (basic)

```
████░░░░░░░░░░░░░░░░  20%
████████░░░░░░░░░░░░  40%
████████████░░░░░░░░  60%
████████████████░░░░  80%
████████████████████  100%
```

### Eased progress (better)

Starts fast, slows near end:
- 0-50%: Fast (2 seconds)
- 50-80%: Medium (3 seconds)
- 80-99%: Slow (4 seconds)
- 99-100%: Quick completion

### Stepped progress (with checklist)

Progress jumps when each item completes:
- Item 1 ✓ → 20%
- Item 2 ✓ → 40%
- Item 3 ✓ → 60%
- Item 4 ✓ → 80%
- Item 5 ✓ → 100%

## Permission prompt timing

**Key insight:** Users are distracted during loading—ideal time for permission prompts.

### ATT (App Tracking Transparency)

```
┌─────────────────────────────────┐
│           19%                   │
│   We're creating a              │
│   personal plan for you         │
│  ┌───────────────────────────┐  │
│  │ Allow "[App]" to track    │  │
│  │ your activity across      │  │
│  │ other apps and websites?  │  │
│  │                           │  │
│  │ [Ask App Not to Track]    │  │
│  │ [Allow]                   │  │
│  └───────────────────────────┘  │
│   🏆 Over 100,000+              │
│      Programs Generated         │
└─────────────────────────────────┘
```

Timing: Show ~20% into loading (user committed, but still waiting).

### Notification permission

Can show during loading or on a dedicated screen just before:

```
┌─────────────────────────────────┐
│   Smart Reminders               │
│                                 │
│   90% of users who enable       │
│   reminders reach their goals   │
│   faster                        │
│                                 │
│   [Enable] [Maybe Later]        │
└─────────────────────────────────┘
```

## Calendar preview pattern

Show what they're "unlocking" during the wait:

```
┌─────────────────────────────────┐
│    All done! ✓                  │
│                                 │
│  Time to generate your          │
│  custom plan                    │
│                                 │
│   S  M  T  W  T  F  S           │
│   ●  🏋 ●  🏋 🏋 🏋 ●           │
│   🏋 🏋 ●  🏋 🏋 🏋 🏋           │
│   ●  🏋 🏋 ●  🏋 🏋 🏋           │
│   ●  ●  🏋 🏋 ●  🏋 ●           │
│                                 │
│        [ Continue ]             │
└─────────────────────────────────┘
```

Calendar icons animate in one by one.

## Social proof during loading

Reinforce value while they wait:

```
┌─────────────────────────────────┐
│           45%                   │
│                                 │
│   Creating your plan...         │
│                                 │
│   ████████████░░░░░░░░░         │
│                                 │
│   🏆 Over 100,000+              │
│      Programs Generated         │
│                                 │
│   ⭐ 4.8 average rating         │
│                                 │
│   "Best fitness app I've        │
│    ever used" - @user           │
└─────────────────────────────────┘
```

## Completion celebration

When loading finishes:

```
┌─────────────────────────────────┐
│         100% ✓                  │
│                                 │
│    Your plan is ready!          │
│                                 │
│   [Confetti animation]          │
│                                 │
│        [ View Plan ]            │
└─────────────────────────────────┘
```

Elements:
- Checkmark appears with bounce
- Confetti or particle effect
- Haptic feedback (success pattern)
- Button appears after 0.5s delay

## Duration guidelines

| Context | Recommended duration |
|---------|---------------------|
| Simple calculation | 2-3 seconds |
| Plan generation | 5-8 seconds |
| "AI analysis" | 8-12 seconds |
| Account creation | 3-5 seconds |

**Rule:** Longer than 15 seconds feels broken. Shorter than 3 seconds feels unearned.

## Implementation checklist

- [ ] Progress percentage displayed
- [ ] Progress bar with smooth animation
- [ ] Rotating status text
- [ ] Checklist items (if applicable)
- [ ] Social proof visible
- [ ] Permission prompts timed appropriately
- [ ] Completion celebration
- [ ] Haptic feedback on completion

## Anti-patterns

- Actual instant loading (no perceived value)
- Progress that moves backward
- Getting stuck at 99% for too long
- No status text (feels frozen)
- Loading that blocks without visual feedback
- Missing the completion moment
