# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Architecture

- `index.html` — the single-page portfolio (navbar, hero, about, courses, books, contact, footer). ~600 lines.
- `privacy.html` — standalone privacy policy page with its own **inline `<style>`** (does not use `style.css`).
- `style.css` — all styling for `index.html` only.
- `images/` — all assets, referenced by relative path (`images/...`).
- Pure HTML5 and CSS3. No JavaScript. No build step. No framework

## Commands** section listing: `terraform init`, `terraform plan`, `terraform apply`

##Commands section listing: `terraform init`, `terraform plan`, `terraform apply`

## Conventions section with these three rules:

## Things to know before editing

- **`index.html` has no `<script>` tag.** The nav buttons use `onclick="goToSection('...')"` and the footer has `<span id="year">`, but no JavaScript defines `goToSection` or sets the year. Navigation works via `#anchor` `href` links, not the onclick handlers. If you add interactivity, you must add the `<script>` yourself.
- `style.css` applies **only** to `index.html`. `privacy.html` is fully self-contained — style changes must be duplicated there if they should match.
- Font Awesome is loaded from a CDN (`cdnjs.cloudflare.com`); icons break offline.

## DMI ownership-proof rule (from README)

Before deploying, the footer of `index.html` must be edited to add a "Deployed by" line identifying the student, cohort, group, and date — this must be visible in the submission screenshot. The current footer credits the original author (Pravin Mishra); the deploy line is added, not replaced.

- All infrastructure changes go through Terraform — never modify AWS resources manually
   - No JavaScript in this project
   - CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

   ## Safety section:
   > "Never put secrets in this file. No API keys, passwords, or AWS credentials."
```bash

## Local preview & deploy
 
# Preview locally
python3 -m http.server 8000        # then open http://localhost:8000

# Deploy target (per README): Ubuntu VM + Nginx
sudo cp -r index.html privacy.html style.css images/ /var/www/html/
sudo systemctl enable --now nginx  # site served at http://<public-ip>
```
