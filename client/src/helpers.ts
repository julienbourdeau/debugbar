export function copyToClipboard(content: string | object) {
  const text = typeof content === "string" ? content : JSON.stringify(content)
  const type = "text/plain"
  const blob = new Blob([text], { type })
  const data = [new ClipboardItem({ [type]: blob })]
  navigator.clipboard.write(data)
}

export function extractAfterPath(url: URL): string {
  const prefixLen = url.origin.length + url.pathname.length
  return url.href.slice(prefixLen)
}

export function extractQueryParams(url: URL): object {
  const params = {}
  for (const [key, value] of url.searchParams) {
    params[key] = value
  }
  return params
}
