#!/bin/bash

APPS_DIR="_apps"
SITE_DIR="_site"
PRIVACY_POLICY_LAYOUT="_layouts/privacy-policy.html"

echo "Generating privacy policies for each app..."
mkdir -p "$SITE_DIR"

for app_file in "$APPS_DIR"/*.md; do
    APP_SLUG=$(basename "$app_file" .md)
    APP_TITLE=$(grep -E '^title:' "$app_file" | head -n 1 | sed 's/title: //; s/"//g; s/$//' | tr -d '\r')
    echo "Processing $APP_SLUG (Title: $APP_TITLE)"

    # Generate privacy content with app title and remove front matter
    FINAL_HTML=$(sed -e "s/{{ page.title }}/$APP_TITLE/g" \
                   -e '/^---$/,/^---$/d' "$PRIVACY_POLICY_LAYOUT")

    OUTPUT_DIR="$SITE_DIR/$APP_SLUG/privacy-policy"
    mkdir -p "$OUTPUT_DIR"
    printf "%s" "$FINAL_HTML" > "$OUTPUT_DIR/index.html"
done

echo "Privacy policies generated."
