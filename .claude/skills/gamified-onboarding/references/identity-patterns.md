# Identity Patterns

## Intent

Transform users from "customers" into "players/members/hunters" with status, rank, and belonging. Identity-first framing increases retention and willingness to pay.

## The identity shift

```
Traditional:          Gamified:
─────────────         ─────────────
Customer      →       Player
Sign up       →       Accept invitation
Account       →       Profile/Character
Features      →       Powers/Abilities
Subscription  →       Membership/Access
Progress      →       Level/Rank/XP
```

## Status grant pattern

First interaction should grant identity, not request information.

### "Chosen one" pattern

```
┌─────────────────────────────────┐
│       (i) NOTIFICATION          │
│  ┌───────────────────────────┐  │
│  │ You have acquired the     │  │
│  │ qualifications to be a    │  │
│  │ [STATUS].                 │  │
│  │ Will you accept?          │  │
│  │                           │  │
│  │       [ Accept ]          │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

**Status names by app type:**

| App type | Status options |
|----------|----------------|
| Fitness | Player, Hunter, Warrior, Athlete |
| Productivity | Operator, Commander, Architect |
| Learning | Scholar, Apprentice, Seeker |
| Finance | Strategist, Builder, Investor |
| Wellness | Guardian, Cultivator, Sage |

### "System" framing

Reference an external system that evaluates/accepts them:

- "The System has identified you..."
- "Based on your potential..."
- "You've been selected for..."
- "Access granted to..."

This creates:
1. External validation (not self-selected)
2. Exclusive feeling (not everyone qualifies)
3. Mysterious authority (the System knows)

## Rank/level system

### Rank naming

| Tier | Fitness | Productivity | Learning |
|------|---------|--------------|----------|
| 1 | E-Rank | Recruit | Novice |
| 2 | D-Rank | Operator | Apprentice |
| 3 | C-Rank | Specialist | Journeyman |
| 4 | B-Rank | Commander | Expert |
| 5 | A-Rank | Elite | Master |
| 6 | S-Rank | Legend | Grandmaster |

### Rank display

```
┌─────────────────────────────────┐
│  Your Current Rank              │
│                                 │
│     ┌─────────────────┐         │
│     │       E         │         │
│     │     RANK        │         │
│     │    [icon]       │         │
│     └─────────────────┘         │
│                                 │
│  XP: 150 / 500 to D-Rank        │
│  ████████░░░░░░░░░░░░           │
│                                 │
└─────────────────────────────────┘
```

### Rank progression teaser

```
┌─────────────────────────────────┐
│  Your potential rank in 90 days │
│                                 │
│  E → D → C → B → [A]            │
│  ○   ○   ○   ○   ●              │
│              You could be here  │
└─────────────────────────────────┘
```

## Stats/attributes system

Transform metrics into RPG-style attributes:

| Real metric | Gamified attribute |
|-------------|-------------------|
| Strength/weight lifted | Strength |
| Cardio capacity | Vitality |
| Flexibility/mobility | Agility |
| Sleep/rest quality | Recovery |
| Focus time | Concentration |
| Tasks completed | Productivity |
| Consistency | Discipline |

### Stats display

```
┌─────────────────────────────────┐
│     Your Arise Stats            │
│                                 │
│  ┌────────────┐ ┌────────────┐  │
│  │STR      12 │ │VIT      12 │  │
│  │████░░░░░░░░│ │████░░░░░░░░│  │
│  └────────────┘ └────────────┘  │
│  ┌────────────┐ ┌────────────┐  │
│  │AGI      14 │ │REC      12 │  │
│  │████░░░░░░░░│ │████░░░░░░░░│  │
│  └────────────┘ └────────────┘  │
│                                 │
│  Total Power: 50                │
└─────────────────────────────────┘
```

## Achievement/title system

### Titles earned through behavior

```
[TITLE] unlocked!

"Early Riser" - Complete 5 morning workouts
"Iron Will" - 7-day streak
"Titan" - Lift 10,000 lbs total
```

### Title display

```
┌─────────────────────────────────┐
│  👤 [Username]                  │
│  "The Consistent"               │  ← equipped title
│                                 │
│  B-Rank Player                  │
│  🏆 12 achievements             │
└─────────────────────────────────┘
```

## Language patterns

### System messages

```
Instead of:                Write:
─────────────              ──────────
"Workout completed"    →   "Quest completed. +50 XP"
"Streak: 7 days"       →   "7-day streak! Title earned"
"New feature!"         →   "New ability unlocked"
"Upgrade now"          →   "Level up your access"
```

### Progress messages

```
Instead of:                Write:
─────────────              ──────────
"Great job!"           →   "Power increased!"
"Keep going"           →   "Your rank is rising"
"Almost there"         →   "Boss battle approaching"
"You did it"           →   "Quest complete. Rewards claimed."
```

### Failure messages

```
Instead of:                Write:
─────────────              ──────────
"You missed a day"     →   "Streak broken. Rise again."
"Try again"            →   "Defeated. Retry?"
"Incomplete"           →   "Quest failed. -10 XP"
```

## Visual identity elements

### Character/avatar system

```
┌─────────────────────────────────┐
│  Choose your avatar             │
│                                 │
│   [👤]  [👤]  [👤]  [👤]         │
│                                 │
│  Or upload your own             │
└─────────────────────────────────┘
```

### Class/archetype selection

```
┌─────────────────────────────────┐
│  Choose your path               │
│                                 │
│  ┌─────────┐ ┌─────────┐        │
│  │ WARRIOR │ │  MAGE   │        │
│  │ Strength│ │ Focus   │        │
│  │ focused │ │ focused │        │
│  └─────────┘ └─────────┘        │
│  ┌─────────┐ ┌─────────┐        │
│  │ RANGER  │ │ HEALER  │        │
│  │ Agility │ │Recovery │        │
│  │ focused │ │ focused │        │
│  └─────────┘ └─────────┘        │
└─────────────────────────────────┘
```

## Thematic references

Popular themes that resonate:

| Theme | Reference | Aesthetic |
|-------|-----------|-----------|
| Solo Leveling | "The System", "Arise", hunters | Dark, neon, Korean manhwa |
| Dark Souls | "Chosen undead", bonfires | Gothic, challenging |
| Pokemon | Badges, evolution, collection | Bright, collectible |
| RPG generic | XP, levels, quests | Fantasy, medieval |
| Sci-fi | Operators, missions, tech | Neon, futuristic |

## Pitfalls

- Gamification that feels childish for adult audience
- Inconsistent terminology (mixing "XP" and "points")
- Stats that don't map to real progress
- Ranks that are too hard/easy to achieve
- Identity language that feels forced
- Missing the "why" behind the theme (Solo Leveling = self-improvement manga)
