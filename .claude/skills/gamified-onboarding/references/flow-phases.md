# Flow Phases

## Intent

Structure onboarding as a 6-phase psychological journey that builds investment before asking for conversion.

## The 6 phases

### Phase 1: Hook (1-2 screens)

**Goal:** Create curiosity and grant identity.

```
┌─────────────────────────────────┐
│         [Brand Logo]            │
│                                 │
│    [Aspirational imagery]       │
│                                 │
│      "Level Up In Real Life"    │
│                                 │
│      [ Get Started >> ]         │
└─────────────────────────────────┘
```

**Pattern:** Don't explain features. Create mystery and aspiration.

**Identity grant screen:**
```
┌─────────────────────────────────┐
│       (i) NOTIFICATION          │
│  ┌───────────────────────────┐  │
│  │ You have acquired the     │  │
│  │ qualifications to be a    │  │
│  │ [STATUS_NAME].            │  │
│  │ Will you accept?          │  │
│  │                           │  │
│  │       [ Accept ]          │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

**Pattern:** User is "chosen" not "signing up". Single button - no opt-out.

### Phase 2: Investment (8-15 screens)

**Goal:** Collect personalization data while building sunk cost.

See `quiz-patterns.md` for detailed question design.

**Key metrics:**
- 10-15 minutes of user time invested
- Progress bar visible throughout
- Questions feel valuable to answer

### Phase 3: Value demonstration (3-5 screens)

**Goal:** Show personalized results that feel "calculated just for them".

```
┌─────────────────────────────────┐
│  Your personalized summary      │
│                                 │
│  ┌─────────────────────────┐    │
│  │ [Progress visualization] │    │
│  │  Current → Target        │    │
│  └─────────────────────────┘    │
│                                 │
│  ┌────┐  ┌────┐  ┌────┐        │
│  │1766│  │121g│  │49g │        │
│  │kcal│  │prot│  │fat │        │
│  └────┘  └────┘  └────┘        │
│                                 │
│  Fitness level: Beginner        │
│  Activity: Sedentary            │
└─────────────────────────────────┘
```

**Pattern:** Numbers feel scientific. Specificity builds trust.

### Phase 4: Fear/Hope sandwich (5-7 screens)

**Goal:** Create emotional contrast - pain of inaction vs pleasure of change.

See `fear-hope-sandwich.md` for detailed design.

**Structure:**
1. Gap creation: "You're wasting X% potential"
2. Fear carousel: 4-5 consequences of inaction (RED)
3. Hope transition: "Time for change" (BLUE)
4. Transformation preview: Before/after stats

### Phase 5: Commitment (4-6 screens)

**Goal:** Get micro-yeses that prime for macro-yes (payment).

See `commitment-ladder.md` for question design.

**Structure:**
1. 3-4 rhetorical yes questions
2. Ritual moment (fingerprint hold, swipe)
3. Journey initiation animation

### Phase 6: Conversion (2-4 screens)

**Goal:** Convert invested, committed user with stacked value.

See `paywall-patterns.md` for detailed design.

**Structure:**
1. Value stack with specific date
2. Social proof (testimonials, user count)
3. Referral/discount urgency
4. Price with anchoring and risk reversal

## Timing guidelines

| Phase | Screens | Time invested |
|-------|---------|---------------|
| Hook | 1-2 | 10-30 seconds |
| Investment | 8-15 | 8-12 minutes |
| Value | 3-5 | 1-2 minutes |
| Fear/Hope | 5-7 | 2-3 minutes |
| Commitment | 4-6 | 1-2 minutes |
| Conversion | 2-4 | 1-2 minutes |

**Total:** ~15-20 minutes before paywall

## Phase transitions

Each phase should have a clear transition moment:

- Hook → Investment: Identity acceptance ("Accept" button)
- Investment → Value: "All done!" with celebration
- Value → Fear: Comparison gap ("You're behind")
- Fear → Hope: Color shift (red → blue)
- Hope → Commitment: "Unlock My Potential" CTA
- Commitment → Conversion: Journey initiation animation

## Pitfalls

- Rushing to paywall (skipping phases = low conversion)
- Weak transitions between phases
- Missing the fear phase entirely
- Value demonstration without personalization
- Generic commitment questions user might say "no" to
