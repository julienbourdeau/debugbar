export function copyToClipboard(content: string | object) {
  const text = typeof content === "string" ? content : JSON.stringify(content)
  const type = "text/plain"
  const blob = new Blob([text], { type })
  const data = [new ClipboardItem({ [type]: blob })]
  navigator.clipboard.write(data)
}
