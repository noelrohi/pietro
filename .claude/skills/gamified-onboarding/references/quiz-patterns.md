# Quiz Patterns

## Intent

Design personalization questions that collect useful data while building psychological investment through sunk cost.

## Quiz structure

Every quiz screen follows this template:

```
┌─────────────────────────────────┐
│ ←  ████████░░░░░░  (progress)   │
│                                 │
│      [Question Title]           │
│                                 │
│  ┌─────────────────────────┐    │
│  │  Option 1           [○] │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │  Option 2           [○] │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │  Option 3           [○] │    │
│  └─────────────────────────┘    │
│                                 │
│        [ Continue ]             │
└─────────────────────────────────┘
```

**Selected state:** Green checkmark, highlighted border, subtle scale animation.

## Question categories

### Identity questions (2-3)
Ask who they are. Low friction, high personalization signal.

| Question | Options | Input type |
|----------|---------|------------|
| Choose your gender | Male, Female, Other | Single + icons |
| How old are you? | Age picker | Scroll wheel |
| Choose your goal | 3-4 primary goals | Single select |

### Motivation questions (2-3)
Ask why they're here. Builds emotional investment.

| Question | Options | Input type |
|----------|---------|------------|
| What motivates you? | 5-6 motivations | Multi-select |
| Where did you hear about us? | Channels + Other | Single + icons |
| What's held you back before? | 4-5 barriers | Multi-select |

### Specificity questions (4-6)
Collect data that makes results feel personalized.

| Question | Options | Input type |
|----------|---------|------------|
| Current state metric | Number picker | Scroll wheel |
| Target state metric | Number picker | Scroll wheel |
| Experience level | Beginner/Intermediate/Advanced | Single + descriptions |
| Current activity level | 4 levels with descriptions | Single select |
| Any limitations? | 5-6 options + None | Multi-select |
| Resources available? | 5-6 options | Multi-select |

### Preference questions (2-3)
Ask how they want to engage. Creates ownership.

| Question | Options | Input type |
|----------|---------|------------|
| Focus areas | 5-7 options with visuals | Multi-select |
| Frequency preference | Slider or number | Slider with large display |
| Schedule preference | Day chips | Multi-select chips |

## Input type patterns

### Single select with icons
```
┌─────────────────────────────────┐
│  ┌─────────────────────────┐    │
│  │  TikTok            [♪]  │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │  Instagram         [📷] │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

### Multi-select with checkmarks
```
┌─────────────────────────────────┐
│  ┌─────────────────────────┐    │
│  │ ✓ Health           [█]  │ ← highlighted
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │ ○ Weight Loss      [ ]  │    │
│  └─────────────────────────┘    │
│  ┌─────────────────────────┐    │
│  │ ✓ Appearance       [█]  │ ← highlighted
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

### Scroll wheel picker
```
┌─────────────────────────────────┐
│         How old are you?        │
│                                 │
│              17                 │ (dimmed)
│           ┌──────┐              │
│           │  18  │              │ (selected, larger)
│           └──────┘              │
│              19                 │ (dimmed)
│                                 │
└─────────────────────────────────┘
```

### Slider with large display
```
┌─────────────────────────────────┐
│    How often would you like     │
│         to work out?            │
│                                 │
│            4x                   │ (large, accent color)
│       4 workouts a week         │
│                                 │
│  Less  ────●──────────  More    │
│                                 │
└─────────────────────────────────┘
```

### Day chips
```
┌─────────────────────────────────┐
│     Set your workout days       │
│                                 │
│  [Sun] [Mon] [Tue] [Wed]        │
│     [Thu] [Fri] [Sat]           │
│                                 │
│  Selected = filled, accent      │
│  Unselected = outlined          │
└─────────────────────────────────┘
```

## Progress bar behavior

- Always visible at top
- Fills left-to-right as user progresses
- Should feel like it's moving (even if steps vary in length)
- ~70-80% filled by end of quiz phase

## Continue button states

```
Disabled (no selection):  Gray, muted, non-interactive
Enabled (selection made): White/accent, prominent, "Continue"
```

## Smart defaults

Pre-fill reasonable defaults to reduce friction:
- Age: 25-30 range
- Weight: Population median for selected gender
- Frequency: 3-4x per week
- Current state: Slightly below average (creates gap)

## Social proof injection

Add micro social proof on select screens:

```
┌─────────────────────────────────┐
│      Smart Reminders  [ON]      │
│                                 │
│  90% of users who use smart     │
│  reminders reach their goals    │
│  faster                         │
└─────────────────────────────────┘
```

## Question ordering principles

1. Start easy (gender, age) - builds momentum
2. Move to motivation (why) - builds emotional investment
3. Get specific (numbers) - feels personalized
4. End with preferences (how) - creates ownership
5. Save notification/reminder asks for end of quiz

## Category-specific quiz examples

### Finance app (8-10 questions)
1. What's your primary financial goal? (Save, Invest, Pay debt, Budget)
2. What's your monthly income range?
3. How much do you currently save per month?
4. What's your biggest financial challenge?
5. Do you have an emergency fund?
6. What's your investment experience level?
7. When do you want to reach your goal?
8. How often do you want to check in?

### Learning app (6-8 questions)
1. What skill do you want to learn?
2. What's your current experience level?
3. How much time can you dedicate daily?
4. What's your learning style? (Video, Reading, Practice)
5. What's your goal? (Career, Hobby, Certification)
6. When do you want to achieve this?

### Dating app (8-12 questions)
1. What are you looking for? (Relationship, Casual, Friends)
2. Age preference range
3. Location/distance preference
4. What matters most to you? (Values, Interests, Lifestyle)
5. Your interests (multi-select)
6. Deal-breakers (multi-select)
7. Communication style preference
8. How often do you want to connect?

### Health/Wellness app (6-8 questions)
1. What's your primary wellness goal?
2. Any health conditions we should know about?
3. Current activity level
4. Sleep quality
5. Stress level
6. What's worked for you before?
7. What hasn't worked?
8. How much time can you dedicate?

### Productivity app (5-7 questions)
1. What's your biggest productivity challenge?
2. What tools do you currently use?
3. Work style (Deep work, Collaborative, Mixed)
4. Peak productivity time of day
5. What outcome would make this worthwhile?

## Pitfalls

- Too many questions (>15 causes drop-off)
- Questions that feel irrelevant to promised value
- Missing progress indicator
- No visual feedback on selection
- Asking sensitive questions too early
