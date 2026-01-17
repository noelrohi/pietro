# Pietro → Arise Transformation

**Summary:** Transform Pietro from a basic workout tracker into a gamified fitness app inspired by Solo Leveling. Players earn XP, level up, climb hunter ranks (E→S), complete daily quests, and unlock achievements.

**Progress:** Phases 1-3 complete, Phases 4-6 remaining.

**Plan Transcript:** `/Users/rohi/.claude/projects/-Users-rohi-xcode-pietro/ea709ef5-bdfe-4b8c-8b5b-3a739f931b1b.jsonl`

---

## Phase 1: Core Gamification Models ✅

**Goal**: Establish data foundation for gamification.

### New Files
- `Models/PlayerProfile.swift` - Player data with stats, rank, XP, onboarding preferences
- `Models/HunterRank.swift` - E → D → C → B → A → S rank enum with styling
- `Models/XPEvent.swift` - XP earning history

### Modifications
- `pietroApp.swift` - Add new models to SwiftData schema
- `Models/Models.swift` - Add `xpValue` to CompletedWorkout

---

## Phase 2: Onboarding Flow ✅

**Goal**: Create dramatic onboarding questionnaire (15 screens).

### New Views: `Views/Onboarding/`
- `OnboardingContainerView` - Page navigation + progress bar
- `AwakeningView` - "You have acquired qualifications to be a Player"
- `GenderSelectionView`, `GoalSelectionView`, `MotivationSelectionView`
- `FocusAreasView`, `FitnessLevelView`, `ActivityLevelView`
- `PersonalInfoView`, `EquipmentAccessView`, `WorkoutFrequencyView`
- `StatsRevealView`, `PotentialStatsView`, `RankProjectionView`
- `CommitmentView`, `LockInView`

### New Components: `Components/OnboardingComponents.swift`
- Progress bar, selection cards, stat bars, system messages

---

## Phase 3: XP System & Leveling ✅

**Goal**: Implement XP earning and level-up mechanics.

### New Files
- `Models/LevelConfig.swift` - XP thresholds per level
- `Services/XPService.swift` - Award XP, check level/rank ups
- `Components/PlayerHeader.swift` - XP bar, rank badge
- `Components/Overlays/` - LevelUpOverlay, RankUpOverlay, XPGainToast

### XP Rules
| Action | XP |
|--------|---:|
| Complete workout | 50-150 (based on duration) |
| Daily streak bonus | +25/day (capped at 7) |
| First workout of day | +20 |
| Weekly goal complete | +100 |

---

## Phase 4: Daily Quests & Achievements 🔲

**Goal**: Add engagement loops via quests and achievements.

### New Models
- `Models/Quest.swift` - Daily/weekly quests with progress
- `Models/Achievement.swift` - Unlockable achievements with tiers

### New Services
- `Services/QuestService.swift` - Generate/track quests
- `Services/AchievementService.swift` - Check/unlock achievements

### New Views
- `Views/Quests/QuestsView.swift` - Quest list
- `Views/Quests/QuestCard.swift` - Individual quest
- `Views/Achievements/AchievementsView.swift` - Achievement grid
- `Views/Achievements/AchievementCard.swift` - Individual achievement

### Achievements
- First Workout, 7/30/100-Day Streak, 10/50/100 Workouts
- Rank ups (E→D, D→C, etc.)
- Level milestones (5, 10, 25, 50)
- Category mastery (10 Push workouts, etc.)

---

## Phase 5: Player Dashboard 🔲

**Goal**: Create RPG-style player profile with stats visualization.

### New Views: `Views/Player/`
- `PlayerDashboardView.swift` - Main player profile screen
- `StatsGridView.swift` - 2x2 stats grid
- `RankBadgeView.swift` - Rank with glow effect
- `XPProgressBar.swift` - Level progress

### Rank Styling
| Rank | Color |
|------|-------|
| E | Gray |
| D | Bronze |
| C | Silver |
| B | Blue |
| A | Purple |
| S | Gold + glow |

---

## Phase 6: Share Cards & Polish 🔲

**Goal**: Viral share cards and final polish.

### New Share Cards: `Components/ShareCards/`
- `RankShareCard.swift` - Current rank display
- `AchievementShareCard.swift` - Unlocked achievement
- `LevelUpShareCard.swift` - Level up celebration
- `WeeklyRecapShareCard.swift` - Weekly summary

### Polish
- Animations for stat changes
- Skeleton loading states
- Empty states with motivational messages

---

## Dependencies

```
Phase 1 (Models) ✅
    ↓
Phase 2 (Onboarding) ✅ → Phase 3 (XP System) ✅
    ↓                         ↓
Phase 4 (Quests & Achievements) ←─┘
    ↓
Phase 5 (Player Dashboard)
    ↓
Phase 6 (Share Cards & Polish)
```
