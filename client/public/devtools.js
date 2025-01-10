var _browser
if (chrome) {
  _browser = chrome
} else {
  _browser = browser
}
_browser.devtools.panels.create(
  "Debugbar", // title
  null, // icon
  "extension/devtools.html" // content
)
