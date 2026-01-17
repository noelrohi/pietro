---
name: gamified-onboarding
description: Design high-conversion onboarding flows with gamification and dopamine engineering. Use when creating app onboarding, designing quiz flows, building paywalls, or needing psychological engagement patterns.
---

# Gamified Onboarding

## What's universal vs category-specific

This skill documents patterns at two levels:

### Universal patterns (use for ANY app)
These psychological principles work across all categories:
- **Investment before ask** - Users spend time before seeing price
- **Fear/hope contrast** - Pain of inaction before pleasure of solution
- **Commitment ladder** - Micro-yeses prime for macro-yes
- **Value stacking** - Benefits > features, specific > vague
- **Price anchoring** - Show expensive option first
- **Loading theater** - Visible work = perceived value
- **Social proof** - Numbers and testimonials everywhere

### Gamification layer (optional, category-dependent)
RPG/gaming aesthetics work best for:
- Fitness & self-improvement (strong fit)
- Learning & skill-building (good fit)
- Habit tracking (good fit)
- Finance/savings goals (moderate fit)

Less appropriate for:
- Productivity/business tools (too playful)
- Health/medical apps (credibility concerns)
- Professional services (tone mismatch)
- Utility apps (over-engineered)

## Quick start by app category

### Fitness / Self-improvement
Full gamification works. Use all references including identity-patterns.md and stats-visualization.md.
```
Hook → Quiz → Value preview → Fear carousel → Stats comparison →
Commitment questions → Ritual → Paywall
```

### Productivity / Business
Skip gamification. Focus on time/money saved, professional credibility.
```
Hook (pain point) → Quiz (workflow questions) → Value preview (time saved) →
Testimonials (professionals) → Commitment (ROI questions) → Paywall
```

### Finance / Budgeting
Moderate gamification (progress bars yes, "ranks" no). Focus on concrete numbers.
```
Hook (financial goal) → Quiz (income/expenses) → Gap analysis →
Projection (with vs without) → Commitment → Paywall
```

### Learning / Education
Light gamification (streaks, levels). Focus on skill gap and career outcomes.
```
Hook (skill aspiration) → Quiz (current level) → Gap analysis →
Learning path preview → Commitment → Paywall
```

### Health / Wellness (non-fitness)
No gamification. Focus on science, calm, trust.
```
Hook (wellness goal) → Quiz (symptoms/history) → Personalized insights →
Gentle fear (consequences) → Expert credibility → Paywall
```

### Dating / Social
No RPG gamification. Focus on belonging, success stories, FOMO.
```
Hook (connection desire) → Quiz (preferences) → Match preview →
Success stories → Scarcity (limited matches) → Paywall
```

## Quick start workflow

1. **Identify your category** from the list above
2. **Map your flow phases** using `references/flow-phases.md` - adapt intensity to category
3. **Design personalization** using `references/quiz-patterns.md` - questions should feel valuable
4. **Add emotional contrast** using `references/fear-hope-sandwich.md` - adjust tone for category
5. **Build commitment** using `references/commitment-ladder.md` - questions vary by category
6. **Design paywall** using `references/paywall-patterns.md` - universal patterns apply

## Core principles

1. **Investment before ask** - Users spend 10-15 minutes in quiz before seeing price.
2. **Identity over features** - "You're a Player now" beats "Track your workouts".
3. **Specific over vague** - "April 17, 2026" beats "in 90 days".
4. **Loss over gain** - Fear of what they'll lose converts better than promise of gain.
5. **Ritual over click** - Physical gestures (hold, swipe) create psychological commitment.
6. **Social proof everywhere** - Numbers, testimonials, ratings at every decision point.

## Workflow for designing onboarding

1. Define the transformation promise (before state → after state).
2. List 8-15 personalization questions that feel valuable to answer.
3. Design the "gap" - show users where they are vs where they could be.
4. Create 3-5 fear screens showing consequences of inaction.
5. Transition to hope with a single "time for change" moment.
6. Add 3-4 commitment questions user can only say "yes" to.
7. Include a ritual moment (fingerprint, hold, swipe-to-commit).
8. Stack value with specific date, benefits list, social proof.
9. Present price with anchoring (monthly vs yearly, savings shown).

## Key metrics to design for

- **Quiz completion rate** - Should be >80% if questions feel personalized.
- **Fear carousel completion** - Users should see all fear screens.
- **Commitment question "yes" rate** - Should be >95% per question.
- **Paywall conversion** - Industry benchmark 2-5%, gamified flows hit 8-15%.

## Component references

Use `references/` for specific patterns:

| Reference | Use when |
|-----------|----------|
| `flow-phases.md` | Structuring the overall onboarding sequence |
| `quiz-patterns.md` | Designing personalization questions |
| `fear-hope-sandwich.md` | Creating emotional contrast |
| `commitment-ladder.md` | Building micro-commitments before paywall |
| `paywall-patterns.md` | Designing the conversion screen |
| `identity-patterns.md` | Adding gamified language and status |
| `stats-visualization.md` | Showing progress with RPG-style UI |
| `loading-theater.md` | Creating perceived value through wait |
| `screen-templates.md` | ASCII templates for common screen types |

## Anti-patterns to avoid

- Showing price before value demonstration.
- Skipping the fear/pain section (hope alone doesn't convert).
- Using generic fitness/productivity imagery (differentiated aesthetic IS the product).
- Asking for payment without commitment ladder.
- Long text explanations instead of visual contrast.
- Forgetting the ritual moment before conversion.
