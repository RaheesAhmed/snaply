# Snaply UI Theme Guide

## Premium Design System

This document outlines the comprehensive design system for Snaply: Quick Edits, Stunning Results - an AI-powered image editing app with a premium, minimalistic aesthetic.

## Color Palette

### Primary Colors

- **Primary**: `#6C63FF` - A refined purple accent color used for key actions and branding elements
- **Secondary**: `#2ECBAA` - A teal accent for calls-to-action and secondary interactions
- **Tertiary**: `#FF8A65` - A warm accent for highlights and special features

### Neutral Colors

- **White**: `#FFFFFF` - Clean background color
- **Light Gray 1**: `#F8F9FA` - Subtle surface backgrounds
- **Light Gray 2**: `#F1F3F5` - Alternative surface and form field backgrounds
- **Light Gray 3**: `#E9ECEF` - Dividers and subtle outlines
- **Medium Gray**: `#ADB5BD` - Inactive elements and secondary text
- **Dark Gray**: `#495057` - Body text and secondary content
- **Near Black**: `#212529` - Headings and primary content

### Functional Colors

- **Success**: `#40C057` - Confirmation messages and positive actions
- **Warning**: `#FFD43B` - Alert messages and cautionary feedback
- **Error**: `#FA5252` - Error messages and destructive actions

### Gradients

- **Primary Gradient**: Linear gradient from `#6C63FF` to `#5A54D4`
  - Used for premium features, key buttons, and visual accents

## Typography

### Fonts

- **Headings & Titles**: Poppins - A geometric sans-serif with clean, modern proportions
- **Body & UI Text**: Inter - A highly legible sans-serif optimized for UI applications

### Type Scale

- **Display Large**: 44px, Bold, -0.5px letter spacing
- **Display Medium**: 36px, Bold, -0.5px letter spacing
- **Display Small**: 28px, Semi-Bold, -0.25px letter spacing
- **Headline Large**: 26px, Semi-Bold, -0.25px letter spacing
- **Headline Medium**: 22px, Semi-Bold
- **Headline Small**: 18px, Semi-Bold
- **Title Large**: 18px, Semi-Bold
- **Title Medium**: 16px, Medium
- **Title Small**: 14px, Medium
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Body Small**: 12px, Regular
- **Label Large**: 14px, Medium, 0.1px letter spacing
- **Label Medium**: 12px, Medium, 0.5px letter spacing
- **Label Small**: 11px, Medium, 0.5px letter spacing

## Spacing & Layout

### Spacing Scale

- **XXS**: 4dp - Minimal spacing between related elements (icon and label)
- **XS**: 8dp - Compact spacing (between related items in a group)
- **SM**: 12dp - Default spacing (between related components)
- **MD**: 16dp - Standard spacing (between distinct components)
- **LG**: 24dp - Generous spacing (between content sections)
- **XL**: 32dp - Section spacing (between major content sections)
- **XXL**: 48dp - Layout spacing (significant page sections)

### Layout Principles

- **Content Width**: Max 100% on mobile, 90% (with max-width constraints) on larger devices
- **Card Layout**: 16dp horizontal margins, 8dp vertical margins
- **Vertical Rhythm**: Consistent spacing multiples throughout the layout
- **Whitespace**: Generous use of whitespace to create a premium, uncluttered feel

## UI Components

### Buttons

- **Primary Button**: Height 56dp, 12dp border radius, 24dp horizontal padding
- **Secondary Button**: Same dimensions as primary, with outline style
- **Text Button**: Height 40dp, 16dp horizontal padding, no background

### Cards

- **Standard Card**: 16dp border radius, subtle elevation (2dp), 8-16dp margins
- **Premium Card**: Same as standard with accent color or gradient highlight

### Text Fields

- **Height**: 56dp for standard input fields
- **Border Radius**: 12dp
- **Padding**: 16dp horizontal, 18dp vertical
- **States**: Unfilled (light gray background), Filled, Focused (primary color outline), Error (error color outline)

### Dialogs & Modals

- **Border Radius**: 16dp
- **Elevation**: 8dp
- **Padding**: 24dp
- **Spacing**: 16dp between title and content, 24dp bottom spacing

## UI Elements & Interactions

### Icons

- **Style**: Outlined, uniform stroke weight (1.5dp)
- **Sizing**: 24dp standard, 20dp compact, 28dp large
- **Touchpoints**: Minimum 48dp touch target for all interactive elements

### Animations & Transitions

- **Duration**:
  - Short: 150ms (micro-interactions)
  - Medium: 300ms (standard transitions)
  - Long: 500ms (emphasis animations)
- **Easing**: Standard easing for most transitions (decelerate)
- **Micro-interactions**: Subtle scale, opacity and position transitions for feedback

### Shadows

- **Subtle**: Small drop shadow (2dp blur, 0.05 opacity) for subtle elevation
- **Moderate**: Medium drop shadow (4dp y-offset, 12dp blur, 0.08 opacity) for cards and elevated components
- **Emphasized**: Large drop shadow (8dp y-offset, 24dp blur, 0.12 opacity) for modals and emphasized elements

## Responsive Design

### Breakpoints

- **Small**: 0-599dp (Small phones)
- **Medium**: 600-904dp (Large phones, small tablets)
- **Large**: 905dp+ (Tablets and larger)

### Adaptation Principles

- **Font Scaling**: Typography scales appropriately on different screen sizes
- **Touch Targets**: Maintain minimum 48dp touch targets on all devices
- **Margins**: Proportional margins that scale with screen size
- **Layouts**: Single column on small devices, optional multi-column on medium and large

## Accessibility

- **Color Contrast**: All text meets WCAG AA standards (4.5:1 ratio for normal text, 3:1 for large text)
- **Touch Targets**: Minimum 48dp size for all interactive elements
- **Text Scaling**: Support for dynamic text sizes
- **Focus States**: Clear visual indicators for keyboard navigation
- **Screen Reader Support**: All UI elements include appropriate semantic labels

## Implementation Notes

- UI components leverage Flutter's Material 3 design system
- Custom theme extensions provide access to Snaply-specific design tokens
- Custom widgets maintain consistent styling across the application
- Responsive layouts adapt based on MediaQuery constraints
