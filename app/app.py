import os
from playwright.sync_api import sync_playwright


def handler(event, context):
    playwright = sync_playwright().start()
    browser = playwright.webkit.launch(headless=True)
    browser_context = browser.new_context()
    page = browser_context.new_page()
    r = page.goto('https://github.com')
    print(f"Success:{r.ok}")
