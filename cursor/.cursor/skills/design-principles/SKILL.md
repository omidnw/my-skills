---
name: design-principles
description: >
  UI/UX design standards for calm, intentional, production-ready interfaces.
  Load automatically for any design or UI work: building or reviewing pages,
  components, themes, RTL (Persian/Arabic/Hebrew) or LTR layouts, dark modes,
  design tokens, typography, accessibility, responsive screens, or motion.
  Triggers: "design", "ui", "ux", "interface", "layout", "component",
  "theme", "style", "dark mode", "rtl", "accessibility", "responsive",
  "doesn't look good" — in any language the user speaks.
---

# Design Principles — ZCode

## Purpose

Produce interfaces that feel intentional, readable, calm, and
production-ready — never just "pretty". This is the full playbook behind the
compact `User Design Standards` rule in the global AGENTS.md.

## When to use

- Building or editing any user-facing UI: pages, components, themes, layouts.
- Reviewing a design before delivery ("does this look good?").
- RTL work (Persian, Arabic, Hebrew) or LTR work.
- Dark/light themes, design tokens, typography, motion, accessibility,
  responsive screens.

Do **not** use for non-UI work (APIs, logic, infra).

## Preconditions

- The compact `User Design Standards` section in the global AGENTS.md has
  already loaded the non-negotiables; this skill carries the detail.

## Rules

### Intent first

The goal is not only visual beauty. The interface must feel intentional,
readable, calm, and production-ready.

Prioritize:
1. Clarity over decoration
2. Consistency over novelty
3. Accessibility over visual effects
4. Meaningful design decisions over random creativity

Avoid:
- unnecessary visual noise
- excessive animations
- generic AI-generated layouts
- decoration without purpose

### Long-Term Usage Principle

Interfaces are not screenshots. Optimize for:
- 8 hours of usage
- readability
- reduced eye strain
- consistent interaction

A beautiful UI that becomes tiring after 30 minutes is a bad UI.

### Layout Direction (LTR / RTL)

Always detect the writing direction before designing.

**RTL interfaces** (Persian, Arabic, Hebrew, other RTL):

Mirror the layout direction, not just the text alignment.
- Navigation flows from right to left.
- Primary actions should feel natural from the right side.
- Icons with directional meaning must be mirrored: arrows, pagination,
  back/forward actions, timelines, progress indicators.

Do not simply apply `direction: rtl` and keep an LTR design.

Consider: reading rhythm, visual hierarchy, content scanning behavior,
logical placement of controls.

Examples:
- Sidebar navigation starts from the right.
- Important actions are positioned where RTL users naturally look.
- Cards and dashboards preserve RTL visual balance.

**LTR interfaces** (English, others):
- Navigation starts from the left.
- Content hierarchy follows left-to-right scanning.
- Icons and directional elements follow LTR meaning.

### Spacing & Composition

Spacing is a core part of design quality.

- Prefer consistent spacing systems; avoid random margins and padding.
- Use whitespace intentionally; think in hierarchy:
  - Small gap: related elements
  - Medium gap: component sections
  - Large gap: different content groups

Avoid: crowded interfaces, elements touching without purpose, excessive
empty space without meaning. Prefer: breathing room, clear grouping, visual
rhythm.

### Color Aesthetics & Design System

Color is not decoration. Color communicates hierarchy, meaning, and
interaction. Never choose colors individually — always design a complete
color system.

#### Color System Foundation

Every interface should define:

**Background Layer** — application background / page canvas.
- Avoid pure black (`#000000`) for dark themes; avoid pure white
  (`#FFFFFF`) for light themes.
- Prefer slightly tinted neutrals. Dark: charcoal, deep blue-gray, warm dark
  tones. Light: soft gray, warm white, subtle tinted surfaces.

**Surface Hierarchy** — different layers need different visual depth.
- Define: background, surface, elevated surface, hover surface, active
  surface.
- Example: `Background → Card → Dropdown/Modal → Tooltip`.
- Do not make every surface the same color.

**Text Color Hierarchy** — never one text color everywhere.
- Primary text (titles, important content): high contrast but comfortable.
- Secondary text (descriptions, metadata): lower contrast.
- Disabled text (unavailable actions): low emphasis but still readable.
- Avoid: white text everywhere (dark theme), black text everywhere (light).

#### Contrast Rules

Every foreground color must be readable against its background — check the
combination before using text, icons, buttons, badges, or hover states.

Common mistakes:
- Dark button + dark text (e.g. `background: #1E293B` + `text: #111827` —
  unreadable).
- Bright background + pure white text (e.g. yellow bg + white text).

#### Interactive State Colors

Every interactive element needs complete states: default, hover, active,
focus, disabled. Never change only the background on hover without checking
text/icon contrast.

Button example:

```
Primary:  background + text
Hover:    background-hover + text-hover
Focus:    focus-ring
Disabled: disabled-background + disabled-text
```

The entire component must remain readable in every state.

#### Color Roles Instead of Raw Colors

Prefer semantic tokens; do not scatter raw hex values through components:

```css
--color-background
--color-surface
--color-surface-hover
--color-primary
--color-primary-hover
--color-primary-text
--color-text-primary
--color-text-secondary
--color-text-disabled
--color-border
--color-success
--color-warning
--color-error
```

#### Accent Color Usage

Accents guide attention.
- Avoid: accent everywhere, multiple competing primary colors, rainbow
  interfaces without purpose.
- Prefer: one dominant accent, limited supporting colors, clear hierarchy.

#### Dark Theme Aesthetics

Dark themes should feel calm and premium.
- Prefer: layered surfaces, subtle borders, soft shadows, muted secondary
  text.
- Avoid: extremely bright colors, excessive glowing effects, maximum
  contrast everywhere.
- Dark UI is for comfortable long sessions.

#### Color Psychology

Choose colors based on product personality:
- Professional/Technical: cool neutrals, controlled accents
- Luxury: deep tones, restrained highlights
- Friendly: softer colors, warmer accents
- Creative: stronger contrasts, expressive palette

Do not choose trendy colors without matching the product identity.

#### Final Color Review

Before finishing, ask:
1. Can I read every text element?
2. Are hover states still readable?
3. Does every button have enough contrast?
4. Is the hierarchy obvious?
5. Does the palette feel intentional?
6. Would this still look good after hours of usage?

### Typography

Typography defines the personality of the interface.

- Create a clear hierarchy; avoid too many font families.
- Match typography with product personality.

Define: display/headline, title, body, caption, metadata.

Avoid: random font sizes, weak hierarchy, long unreadable paragraphs.

### Components

Components should feel like one system.

- Reuse patterns; keep spacing, border radius, and shadows consistent.

Before creating a new component, ask: "Does an existing pattern already
solve this?"

Avoid: one-off styling, inconsistent buttons, different card styles
everywhere.

### Motion & Interaction

Animations communicate.

- Use motion for: state changes, feedback, transitions, important moments.
- Avoid: animations everywhere, distracting effects, unnecessary movement.
- Prefer: subtle, fast, meaningful.

### Responsive Design

Design mobile-first when appropriate.

- Consider screen sizes, touch targets, content priority.
- Do not simply shrink desktop layouts.

### Accessibility

Always consider: readable contrast, keyboard navigation, focus states,
semantic HTML, reduced motion preferences.

A beautiful interface that is hard to use is a failed design.

## Common mistakes

- Applying `direction: rtl` without mirroring layout and directional icons —
  the most common RTL bug.
- Pure `#000` background with pure `#FFF` text in dark themes.
- Random colors without a token system.
- One-off components instead of reusing existing patterns.
- Generic AI-generated layouts or decoration without purpose.
- Animations everywhere instead of on state changes/feedback.
- Shipping a design without running the final review.

## Validation

Before finishing any UI work, run the Final Design Review:

### Visual
- Does it feel intentional?
- Is spacing consistent?
- Are colors balanced?
- Is hierarchy clear?

### UX
- Can users understand it immediately?
- Are important actions obvious?
- Are states handled?

### Quality
- No placeholder-looking UI
- No inconsistent components
- No accidental generic AI style