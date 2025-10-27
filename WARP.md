# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a static marketing website for "Where is my cash?" - an iOS expense tracking application. The site is a single-page application (SPA) with multi-language support (English, French, Arabic) featuring:

- Hero section with App Store download link
- Feature highlights
- FAQ section
- Contact form
- Multi-language support with RTL (right-to-left) for Arabic

## Technology Stack

- **Frontend**: Vanilla HTML, CSS, JavaScript (no framework)
- **CSS Framework**: Bootstrap 5 (bootstrap.min.css)
- **Icons**: LineIcons (lineicons.css)
- **Animations**: WOW.js for scroll animations (wow.min.js)
- **Analytics**: PostHog analytics integration
- **Build Tools**: PurgeCSS for CSS optimization (via npm)

## Common Commands

### Install Dependencies
```bash
npm install
```

### CSS Optimization
The project uses PurgeCSS to remove unused CSS. Run after making CSS changes:
```bash
npx purgecss --css assets/css/*.css --content index.html --output assets/css/
```

### Image Optimization
Convert images to WebP format and create responsive sizes:
```bash
bash optimize-images.sh
```

Note: Requires `cwebp` and ImageMagick's `convert` to be installed.

### Local Development
Since this is a static site, use any local server:
```bash
python3 -m http.server 8000
# or
npx serve .
```

## Architecture

### File Structure

- **index.html**: Main landing page with embedded CSS and JavaScript
- **assets/css/**: Stylesheets (Bootstrap, custom styles, LineIcons)
- **assets/js/**: JavaScript files (Bootstrap bundle, WOW.js, main.js, performance.js)
- **assets/images/**: Image assets organized by section (hero, features, faq, footer, etc.)
- **privacy-policy/**, **copyright/**, **feedback/**: Static subpages

### Internationalization (i18n)

The translation system is custom-built, not using a library:

- **Translation data**: Embedded in `index.html` as a JavaScript object (`translations`)
- **Supported languages**: English (en), French (fr), Arabic (ar)
- **Translation keys**: Use dot notation (e.g., `features.translation.title`)
- **HTML attributes**: Elements with `data-translate` attribute get translated
- **Storage**: Current language stored in `localStorage`
- **RTL support**: Arabic automatically switches to RTL layout via `dir="rtl"` attribute

To add a new translatable element:
1. Add `data-translate="section.key"` attribute to HTML element
2. Add corresponding translations in the `translations` object for all languages

### Theme & Styling

The site uses a **black and white theme** with custom CSS properties:

```css
:root {
  --primary-color: #ffffff;
  --bg-primary: #000000;
  --text-primary: #ffffff;
  /* etc. */
}
```

Key styling features:
- Dark theme by default
- Glass-morphism effects (backdrop-filter blur)
- Sticky header that changes on scroll
- Custom language switcher dropdown (not native select)
- WOW.js scroll animations with delays
- Particle animation system (JavaScript-generated)

### JavaScript Organization

1. **main.js**: Core functionality
   - Sticky header behavior
   - Mobile menu toggle
   - Smooth scroll for anchor links
   - Back-to-top button
   - Logo switching

2. **performance.js**: Performance optimizations
   - Lazy loading for images with `.lazy` class
   - Uses IntersectionObserver API

3. **Inline scripts in index.html**:
   - Translation system class
   - Particle animation system
   - Menu scroll handlers
   - PostHog analytics initialization

### Images

- Logos: `assets/images/logo/logo-light.png` (used throughout, no dark variant)
- Hero image: `assets/images/hero/hero-image.png`
- SVG shapes for decorative elements in various sections
- Organized by section: `404/`, `about/`, `banner/`, `blog/`, `brands/`, `faq/`, `footer/`, `hero/`, `team/`, `testimonials/`

### Forms

The contact form (`#contact` section) uses Formspree for form submission:
- **Service**: Formspree (action URL: `https://formspree.io/f/xrbozqjv`)
- **Method**: POST
- **Fields**: Name, Email, Phone, Message
- **Translations**: Form field labels and placeholders are translatable via `data-translate` and `data-translate-placeholder` attributes

No backend code is required - form submissions are handled by Formspree.

## Key JavaScript Files

When modifying JavaScript functionality, be aware of these files:

1. **assets/js/main.js** - Core UI interactions:
   - Sticky header on scroll
   - Mobile menu toggle
   - Back-to-top button
   - Logo switching (uses same logo in all states currently)
   - Smooth scroll animation with custom easing

2. **assets/js/performance.js** - Performance optimizations:
   - Lazy loading implementation using IntersectionObserver
   - Images with `class="lazy"` and `data-src` attribute are lazy-loaded

3. **Inline scripts in index.html**:
   - **Translation System** (lines 1173-1686): Custom-built i18n with `TranslationSystem` class
   - **Particle Animation** (lines 1119-1170): Decorative floating particles on hero section
   - **Menu Scroll Handler** (lines 1075-1117): Active menu highlighting based on scroll position
   - **PostHog Analytics** (lines 1688-1693): Analytics initialization

## Development Guidelines

### Adding New Sections

1. Add HTML structure following existing patterns (use `ud-` prefix for section classes)
2. Add animations with WOW.js: `class="wow fadeInUp" data-wow-delay=".1s"`
3. Add translation keys to the `translations` object in `index.html` (around line 1175)
4. Add `data-translate` attributes to translatable elements
5. Test in all three languages (en, fr, ar) and verify RTL layout for Arabic

### Modifying Styles

- Critical CSS is inlined in the `<head>` for performance
- External stylesheets loaded after: bootstrap.min.css → lineicons.css → ud-styles.css
- Custom styles use CSS custom properties for consistency
- RTL adaptations handled via `[dir="rtl"]` selectors

### Performance Considerations

- Images should use lazy loading: `class="lazy"` with `data-src` attribute
- Fonts preloaded with `rel="preload"` and async stylesheet loading
- Critical resources preloaded (CSS, JS, key images)
- Browser caching configured via `.htaccess`
- Compression (gzip/deflate) configured via `.htaccess`

### Multi-language Content

When adding new content:
1. Write English version first
2. Add French translation in `translations.fr` object
3. Add Arabic translation in `translations.ar` object
4. Ensure Arabic text flows correctly in RTL layout

### Browser Compatibility

- Uses modern JavaScript features (ES6+ classes, arrow functions)
- IntersectionObserver for lazy loading (has fallback)
- CSS custom properties (no fallback for older browsers)
- Backdrop-filter for glass effects (may not work in all browsers)

## Server Configuration

The `.htaccess` file configures:
- Gzip compression for text resources
- Long-term caching for images (1 year)
- Medium-term caching for CSS/JS (1 month)

Ensure Apache `mod_deflate` and `mod_expires` modules are enabled.

## Analytics

PostHog is integrated for analytics:
- **Project Key**: `phc_jDXbxwKzvOzxFs6GJpXz5KAgvA6yxXnzNHewDl1NzOd`
- **API Host**: `https://us.i.posthog.com`
- **Person Profiles**: `identified_only` (only creates profiles for identified users)
- Event tracking and session recording can be added using PostHog's API
- Initialization code is in index.html (lines 1688-1693)

## Important Notes

### No Build Process
This is a **static site** with no build step beyond optional CSS purging and image optimization. All code is directly served as-is. Changes to HTML, CSS, or JavaScript are immediately visible after refresh.

### Testing
1. **Local server**: Use `python3 -m http.server 8000` or `npx serve .`
2. **Multi-language**: Test all three languages (en, fr, ar) using the language switcher
3. **RTL Layout**: Verify Arabic properly displays right-to-left
4. **Responsive**: Test on mobile breakpoints (<768px) for mobile-specific styles
5. **Forms**: Contact form submissions go to Formspree - check `soufiane.masmoud@gmail.com` for submissions

### Deployment
For Apache hosting:
1. Ensure `mod_deflate` and `mod_expires` modules are enabled
2. `.htaccess` file configures caching and compression
3. No server-side processing required (static HTML/CSS/JS only)
