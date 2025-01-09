// var _browser
// if (chrome) {
//   _browser = chrome
// } else {
//   _browser = browser
// }
// _browser.devtools.panels.create(
//   "Debugbar", // title
//   "todo.png", // icon
//   "extension/devtools.html" // content
// )

// Create a panel in DevTools
chrome.devtools.panels.create("Request Monitor", null, "extension/devtools.html", function (panel) {
  console.log("Panel created")
})

// Create a background page connection
const backgroundPageConnection = chrome.runtime.connect({
  name: "devtools-page",
})

// Listen to network requests
chrome.devtools.network.onRequestFinished.addListener((request) => {
  const requestData = {
    url: request.request.url,
    method: request.request.method,
    status: request.response.status,
    timestamp: new Date().toISOString(),
  }

  addRequestToList(requestData)
})

function addRequestToList(requestData) {
  const list = document.getElementById("requests-list")
  const listItem = document.createElement("li")
  listItem.className = "request-item"
  listItem.innerHTML = `
        <strong>${requestData.method}</strong> ${requestData.status}
        <br>
        ${requestData.url}
        <br>
        <small>${requestData.timestamp}</small>
    `
  list.insertBefore(listItem, list.firstChild)
}
