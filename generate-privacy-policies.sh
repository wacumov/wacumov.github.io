#!/bin/bash

APPS_DIR="_apps"
SITE_DIR="_site"
PRIVACY_POLICY_LAYOUT="_layouts/privacy-policy.html"

echo "Generating privacy policies for each app..."
mkdir -p "$SITE_DIR"

for app_file in "$APPS_DIR"/*.md; do
    APP_SLUG=$(basename "$app_file" .md)
    # Extract Title (handling quotes and extra spaces)
    APP_TITLE=$(grep -E '^title:' "$app_file" | head -n 1 | sed 's/title: //; s/"//g; s/$//' | tr -d '\r')

    # Extract Android App ID
    ANDROID_APPID=$(grep -E '^android_appid:' "$app_file" | head -n 1 | awk '{print $2}' | tr -d '\r')

    # Extract has_appodeal flag
    HAS_APPODEAL=$(grep -E '^has_appodeal:' "$app_file" | head -n 1 | awk '{print $2}' | tr -d '\r')

    echo "Processing $APP_SLUG (Title: $APP_TITLE, Android: ${ANDROID_APPID:-No}, Appodeal: ${HAS_APPODEAL:-No})"

    # logic for Analytics Content
    if [ -n "$ANDROID_APPID" ]; then
        ANALYTICS_CONTENT="<p>The current app version and later uses Apple App Analytics (for iOS) and Google Play Services (for Android) to detect crashes and improve stability. These services are covered by their respective privacy policies.</p>"
    else
        ANALYTICS_CONTENT="<p>The current app version and later does not use any first or third party analytics other than the Apple App Analytics, which you may optionally opt into on your device. These are covered by Apple’s (Apple Inc.) privacy policy which can be found under the privacy settings on the iOS device. The key reason these analytics are used by the app is to be able to detect app crashes and fix them.</p>"
    fi

    # Logic for Service Providers
    SERVICE_PROVIDERS_CONTENT=""
    if [ "$HAS_APPODEAL" == "true" ]; then
        SERVICE_PROVIDERS_CONTENT="<h3>Third Party Services</h3><p>This app uses Appodeal. You can find their privacy policy here: <a href=\"https://appodeal.com/privacy-policy/\">Appodeal Privacy Policy</a>.</p>"
    fi

    # Generate final HTML
    # 1. Strip front matter (sed)
    # 2. Replace title (sed)
    # 3. Replace placeholders (perl for safety with special chars/HTML)
    FINAL_HTML=$(cat "$PRIVACY_POLICY_LAYOUT" | \
                   sed '/^---$/,/^---$/d' | \
                   sed "s/{{ page.title }}/$APP_TITLE/g" | \
                   perl -pe "s|\\{\\{ ANALYTICS_CONTENT \\}\}|$ANALYTICS_CONTENT|g" | \
                   perl -pe "s|\\{\\{ SERVICE_PROVIDERS \\}\}|$SERVICE_PROVIDERS_CONTENT|g")

    OUTPUT_DIR="$SITE_DIR/apps/$APP_SLUG/privacy-policy"
    mkdir -p "$OUTPUT_DIR"
    printf "%s" "$FINAL_HTML" > "$OUTPUT_DIR/index.html"
done

echo "Privacy policies generated."
