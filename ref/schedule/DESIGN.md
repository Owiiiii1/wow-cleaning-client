---
name: Wow Now Cleaning
colors:
  surface: '#fbf9f8'
  surface-dim: '#dbd9d9'
  surface-bright: '#fbf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f3'
  surface-container: '#efeded'
  surface-container-high: '#eae8e7'
  surface-container-highest: '#e4e2e2'
  on-surface: '#1b1c1c'
  on-surface-variant: '#40484f'
  inverse-surface: '#303030'
  inverse-on-surface: '#f2f0f0'
  outline: '#707880'
  outline-variant: '#c0c7d0'
  surface-tint: '#016492'
  primary: '#004b6f'
  on-primary: '#ffffff'
  primary-container: '#006492'
  on-primary-container: '#b4ddff'
  inverse-primary: '#8cceff'
  secondary: '#6f5d00'
  on-secondary: '#ffffff'
  secondary-container: '#f8df7c'
  on-secondary-container: '#746105'
  tertiary: '#444647'
  on-tertiary: '#ffffff'
  tertiary-container: '#5c5e5e'
  on-tertiary-container: '#d7d8d7'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cae6ff'
  primary-fixed-dim: '#8cceff'
  on-primary-fixed: '#001e2f'
  on-primary-fixed-variant: '#004b6f'
  secondary-fixed: '#fbe27f'
  secondary-fixed-dim: '#dec666'
  on-secondary-fixed: '#221b00'
  on-secondary-fixed-variant: '#544600'
  tertiary-fixed: '#e2e3e2'
  tertiary-fixed-dim: '#c6c7c6'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#fbf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e2'
  picton-blue: '#37b7ff'
  mustard-gold: '#fede58'
  surface-bg: '#fbf9f8'
  glow-shadow: rgba(55, 183, 255, 0.08)
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  section-title:
    fontFamily: Montserrat
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.08em
  body-lg:
    fontFamily: Montserrat
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 28px
  body-md:
    fontFamily: Montserrat
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: Montserrat
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  caption-xs:
    fontFamily: Montserrat
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  container-margin: 20px
---

## Brand & Style
The brand identity is "Corporate-Playful"—a professional, reliable home service utility with a friendly, energetic personality. It targets busy professionals and families who value cleanliness and convenience.

The design style is **Corporate / Modern** with a touch of **Glassmorphism** in its shadow treatment. It utilizes a bright, airy aesthetic characterized by high-key backgrounds, vibrant blue accents, and a "Mustard" secondary color to denote warmth and attention. The use of a poodle mascot (Benjamin) and soft, tinted shadows creates an approachable, high-trust environment that feels "fresh" and "sparkling."

## Colors
The palette is dominated by "Clean Water" blues and "Sunlight" yellows. 

- **Primary Blue (#006492):** Used for brand identity, headers, and primary iconography.
- **Primary Container (#37b7ff):** A brighter "Picton Blue" used for high-visibility CTAs and active states.
- **Secondary Mustard (#6f5d00):** Used sparingly as a "high-alert" or "warmth" accent, such as borders on upcoming service cards or floating action buttons.
- **Background (#fbf9f8):** An off-white, slightly warm neutral that prevents the interface from feeling clinical.
- **Shadow Tint:** Unique to this system, shadows are not neutral gray but are tinted with the primary blue (`rgba(55, 183, 255, 0.08)`) to maintain the "clean" and "vibrant" atmosphere.

## Typography
The system uses **Montserrat** exclusively to achieve a modern, geometric, and energetic feel. 

- **Hierarchy:** Strong contrast between uppercase section titles and bold headlines creates a clear scanning path.
- **Numerical/Status:** Status tags and timestamps use a `caption-xs` size with heavy weights to remain legible despite their small footprint.
- **Letter Spacing:** Headlines use slight negative tracking for a tighter, more "logo-like" appearance, while section titles use expanded tracking for better readability in all-caps.

## Layout & Spacing
The system uses a **Fixed Grid** approach for mobile (max-width: 672px/2xl) centered on the screen, transitioning to a fluid layout within that container.

- **Margins:** A standard 20px horizontal margin ensures content doesn't hit the screen edges.
- **Vertical Rhythm:** Sections are separated by 24px (`lg`), while internal card elements use 12px (`sm`) or 16px (`md`) spacing.
- **Safe Areas:** The bottom navigation uses `pb-safe` to account for mobile gesture bars, with a total height including the floating action button that requires at least 80px of padding at the bottom of the main content.

## Elevation & Depth
Depth is created through **Ambient Shadows** and **Tonal Layers**.

- **Shadows:** Standard cards and the top navigation use a light blue-tinted shadow (`0px 4px 12px rgba(55, 183, 255, 0.08)`). This avoids the "dirty" look of black shadows.
- **Surface Tiers:** 
  - `surface`: Background level (#fbf9f8).
  - `surface-container-lowest`: Primary card backgrounds (#ffffff), providing maximum contrast against the off-white background.
  - `surface-container-low`: Notification bars and hover states.
- **Interactive Depth:** On press, cards scale down slightly (98%) to provide tactile feedback without needing heavy drop shadows.

## Shapes
The shape language is **Rounded**, conveying a friendly and safe brand image.

- **Primary Cards/Buttons:** Use `rounded-xl` (1.5rem / 24px) for a soft, approachable feel.
- **Bento Grid Actions:** Use `rounded-lg` (1rem / 16px) for slightly tighter structural grouping.
- **Avatars/Badges:** Fully circular (`rounded-full`) to contrast against the rectangular grid.
- **Specialty:** Service cards use a heavy left-border (8px) to provide a color-coded "category" accent while maintaining the overall rounded container shape.

## Components

### Buttons
- **Primary CTA:** Large, `rounded-xl`, using `primary-container` (#37b7ff) with a drop shadow. Includes an icon for quick recognition.
- **Floating Action Button (FAB):** A 56x56 circular button with a 4px white border, centered in the navigation bar.

### Cards
- **Feature Card:** White background, blue-tinted shadow, with a thick secondary-color left border.
- **Quick Action (Bento):** 2-column grid. Icons are housed in tinted background squares (10% opacity of the icon color).

### Navigation
- **Top Bar:** Fixed, 64px height, blurring the background if possible, or using a solid `surface` color with a bottom shadow.
- **Bottom Bar:** `rounded-t-xl` with an inset FAB. Active states are indicated by the primary color and bold text.

### Status Indicators
- **Chips:** Small, all-caps, bold text inside a 15% opacity background of the primary color.
- **Pulse:** Active notifications use a small `primary` color dot with a pulse animation to draw attention without being intrusive.