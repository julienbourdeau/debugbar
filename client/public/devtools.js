var _browser
if (chrome) {
  _browser = chrome
} else {
  _browser = browser
}
_browser.devtools.panels.create(
  "Debugbar", // title
  "todo.png", // icon
  "extension/devtools.html" // content
)
