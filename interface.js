function thisMovie(movieName) {
  if (navigator.appName.indexOf("Microsoft") != -1)
    return window[movieName];
  else
    return document[movieName];
}

function getInnerHTML(element) {
  /*if (navigator.appName.indexOf("Microsoft") != -1)
    return element.innerText;
  else*/
    return element.innerHTML;
}

function setInnerHTML(element,HTML) {
  /*if (navigator.appName.indexOf("Microsoft") != -1)
    element.innerText = HTML;
  else*/
    element.innerHTML = HTML;
}

function removeCurrentLayer () {
  thisMovie("editor").removeCurrentLayer();
}

function removeLayer (depth) {
  var tabs = $("#tabs-holder").children("div");
  
  if (depth != (tabs.length - 1))
  {
    for (var n=depth;n<tabs.length;n++) {
      tabs.eq(n-1).children(".label").text(tabs.eq(n).children(".label").text());
    }
  }
  
  $("#tabs-holder").children(":last").remove();
  thisMovie("editor").removeLayer(depth);
}

function addTab (caption) {
  var depth = $("#tabs-holder").children("div").length;
  var tab = $("<div/>");
  var remove = $("<a/>");
  var label = $("<a/>");
  tab.attr("id","tab"+depth);
  remove.attr("href","javascript:void(removeLayer("+depth+"))");
  remove.attr("class","remove");
  label.attr("href","javascript:void(setActiveLayer("+depth+"))");
  label.attr("class","label");
  label.text(caption);
  remove.appendTo(tab);
  label.appendTo(tab);
  tab.appendTo("#tabs-holder");
}

function addTextLayer () {
  thisMovie("editor").addComponent("text");
  addTab("text");
}

function addDrawLayer () {
  thisMovie("editor").addComponent("draw");
  addTab("draw");
}

function addImageLayer (path) {
  if (!path) {
    alert("Path to image must not be empty!");
    return;
  }
  
  thisMovie("editor").addComponent("image",path);
  addTab("image");
}

function setActiveLayer (depth) {
  $("#tabs-holder").children("div").css("background-color","#ccc");
  $("#tabs-holder").children("#tab"+depth).css("background-color","#e0ffe0");
  
  thisMovie("editor").setActiveLayer(depth);
}

$(document).ready(function() {
  $("#color-picker").draggable();
  $("#color-picker").show();
});