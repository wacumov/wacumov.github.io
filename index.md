---
layout: default
title: Apps
---

<ul class="cards">
  {% assign sorted_apps = site.apps | sort: "sortOrder" %}
  {% for app in sorted_apps %}
    <li class="cards-item">
      <div class="card">
        <div class="card-content">
          <div class="card-header-container">
            <div class="card-icon">
              <img src="/assets/images/{{ app.icon }}" alt="{{ app.title }} icon">
            </div>
            <div class="card-header">
              <h2><a href="{{ app.url }}">{{ app.title }}</a></h2>
              <ul class="category-list">
                {% for category in app.categories %}
                  <li class="category">{{ category }}</li>
                {% endfor %}
              </ul>
            </div>
          </div>
          <div class="card-text">
            <p>{{ app.description }}</p>
          </div>
          <a href="https://apps.apple.com/app/id{{ app.appid }}">
            <img class="app-store-badge" src="/assets/images/app-store-badge.svg" alt="Download on the App Store">
          </a>
        </div>
      </div>
    </li>
  {% endfor %}
</ul>
