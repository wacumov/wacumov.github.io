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

    # Logic for Information Collection Content
    if [ "$HAS_APPODEAL" == "true" ]; then
        COLLECTION_CONTENT="<p>The app itself does not collect personal information and has no servers of its own. Your games, scores and settings stay on your device.</p><p>The app shows ads through the Appodeal SDK. Appodeal and its advertising partners may collect:</p><ul><li>the advertising identifier (IDFA), only if you allow tracking when the app asks;</li><li>device data: model, operating system version, language, time zone and screen size;</li><li>the IP address, which some ad networks may use to estimate the country or region;</li><li>ad data: which ads were shown and tapped.</li></ul><p>They use this data to show ads, to personalise them, to measure how ads perform and to prevent fraud. If you allow tracking, the advertising identifier may be used to show you ads based on your activity in other companies\x27 apps and websites. For more details, see the <a href=\"https://appodeal.com/privacy-policy/\">Appodeal Privacy Policy</a>.</p><h3>Your Choices</h3><p>You can allow or deny tracking when the app asks, and change it any time in Settings, Privacy and Security, Tracking. Where the law requires it, the app also asks for your consent to personalised ads. Without tracking you still see ads, but they are not personalised.</p><h3>Data Retention and Deletion</h3><p>The app keeps no data on servers, so the developer holds nothing to delete. Appodeal and its partners keep and delete the data they collect under their own policies; to ask them for access or deletion, use the contacts in the Appodeal Privacy Policy.</p>"
    else
        COLLECTION_CONTENT="<p>The app does not collect any information. All information added to the app resides within the app itself.</p>"
    fi

    # Logic for Analytics Content
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
    # 3. Replace placeholders (sed with pipe delimiter for safety with HTML)
    FINAL_HTML=$(cat "$PRIVACY_POLICY_LAYOUT" | \
                   sed '/^---$/,/^---$/d' | \
                   sed "s/{{ page.title }}/$APP_TITLE/g" | \
                   sed "s|{{ COLLECTION_CONTENT }}|$COLLECTION_CONTENT|g" | \
                   sed "s|{{ ANALYTICS_CONTENT }}|$ANALYTICS_CONTENT|g" | \
                   sed "s|{{ SERVICE_PROVIDERS }}|$SERVICE_PROVIDERS_CONTENT|g")

    OUTPUT_DIR="$SITE_DIR/apps/$APP_SLUG/privacy-policy"
    mkdir -p "$OUTPUT_DIR"
    printf "%s" "$FINAL_HTML" > "$OUTPUT_DIR/index.html"
done

echo "Privacy policies generated."
