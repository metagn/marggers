import ../src/[margrave, margrave/common, margrave/element], dom

proc convertMargrave(text: NativeString): NativeString =
  result = ""
  for elem in parseMargrave(text):
    result.add(toNativeString(elem))
    result.add(NativeString("\n"))

proc input(): cstring =
  getElementById("input").value

proc convert() {.exportc.} =
  let input = input()
  let output = convertMargrave(input)
  getElementById("output").innerHTML = output

proc convertToSource() {.exportc.} =
  let input = input()
  let output = convertMargrave(input)
  let sourceBlock = document.createElement("pre")
  sourceBlock.textContent = output
  let outputElement = getElementById("output")
  outputElement.innerHTML = ""
  outputElement.appendChild(sourceBlock)

proc filename(): cstring =
  proc `or`(x, y: cstring): cstring {.importjs: "# || #".} 
  getElementById("filename").value or "output.html"

proc download() {.exportc.} =
  let input = input()
  let output = convertMargrave(input)

  proc blobHtml(str: cstring): Blob {.importjs: "new Blob([#], {type: 'text/html'})", constructor.}
  proc createUrl(blob: Blob): cstring {.importc: "window.URL.createObjectURL".}
  proc revokeUrl(url: cstring) {.importc: "window.URL.revokeObjectURL".}

  let blob = blobHtml(output)
  let url = createUrl(blob)
  let a = document.createElement("a")
  a.style.display = "none"
  a.setAttr("href", url)
  a.setAttr("download", filename())
  document.body.appendChild(a)
  a.click()
  revokeUrl(url)
  document.body.removeChild(a)
