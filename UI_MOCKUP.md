# KanaMate App UI Description

## Main Learning Screen

```
┌─────────────────────────┐
│ Stats      KanaMate  Reset│  <- Header with navigation
├─────────────────────────┤
│                         │
│                         │
│          ka             │  <- Large romaji display
│     (80pt font)         │
│                         │
│                         │
│     ┌─────┐ ┌─────┐     │
│     │ ✔️  │ │ ❌  │     │  <- Answer buttons
│     │Know │ │Don't│     │
│     │     │ │Know │     │
│     └─────┘ └─────┘     │
│                         │
│                         │
│ Progress: 3/20  Basic   │  <- Progress indicator
└─────────────────────────┘
```

## Kana Reveal Screen (when user doesn't know)

```
┌─────────────────────────┐
│ Stats      KanaMate  Reset│
├─────────────────────────┤
│                         │
│          ka             │  <- Original romaji
│     (80pt font)         │
│                         │
│   Hiragana  Katakana    │
│      か        カ       │  <- Large kana display
│   (60pt)    (60pt)      │
│                         │
│   ┌─────────────────┐   │
│   │ 🔊 Play Sound   │   │  <- Audio button
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │    Continue     │   │  <- Continue button
│   └─────────────────┘   │
│                         │
│ Progress: 3/20  Basic   │
└─────────────────────────┘
```

## Welcome Screen

```
┌─────────────────────────┐
│                         │
│                         │
│          🇯🇵            │  <- Japanese flag emoji
│                         │
│   Welcome to KanaMate   │
│   Learn Japanese Kana   │
│                         │
│                         │
│   ┌─────────────────┐   │
│   │  Start Learning │   │  <- Main action button
│   └─────────────────┘   │
│                         │
│                         │
│                         │
│                         │
└─────────────────────────┘
```

## Statistics Screen

```
┌─────────────────────────┐
│ Done     Statistics     │  <- Modal header
├─────────────────────────┤
│                         │
│ ┌─────────────────────┐ │
│ │ Total Kana      140 │ │  <- Stats cards
│ │ Studied Kana     45 │ │
│ │ Success Rate     78%│ │
│ └─────────────────────┘ │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
└─────────────────────────┘
```

## Color Scheme
- **Green**: ✔️ Know button, Audio button, Success indicators
- **Red**: ❌ Don't know button, Error states
- **Blue**: Hiragana text, App accent, Continue button
- **Orange**: Reset button, Warning states
- **Gray**: Secondary text, Backgrounds

## Typography
- **Romaji**: 80pt, Bold, Rounded system font
- **Kana**: 60pt, Medium weight
- **Buttons**: Title2/Title3, Semibold
- **Labels**: Body/Caption, Regular

## Animations
- Smooth fade transition when revealing kana
- Button press feedback
- Page transitions between kana

This design prioritizes:
✅ Large, easy-to-read text
✅ Minimal, clean interface
✅ Clear visual hierarchy
✅ Accessible button sizes
✅ Intuitive user flow