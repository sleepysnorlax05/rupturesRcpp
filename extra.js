// Guide chapters: mark the current chapter in the sidebar and add previous/next
// links at the end of the page, in the order the sidebar lists them.
document.addEventListener("DOMContentLoaded", function () {
  var links = Array.prototype.slice.call(document.querySelectorAll(".guide-nav a"));
  var main = document.getElementById("main");
  if (!links.length || !main) return;

  var page = function (href) { return href.split("/").pop().replace(/\.html$/, ""); };
  var here = page(window.location.pathname);
  var current = links.findIndex(function (a) { return page(a.getAttribute("href")) === here; });
  if (current < 0) return;
  links[current].setAttribute("aria-current", "page");

  var link = function (target, cls, label) {
    var a = document.createElement("a");
    a.className = cls;
    a.href = target.getAttribute("href");
    var span = document.createElement("span");
    span.className = "chapter-nav-label";
    span.textContent = label;
    a.appendChild(span);
    a.appendChild(document.createTextNode(target.textContent));
    return a;
  };

  var nav = document.createElement("nav");
  nav.className = "chapter-nav";
  nav.setAttribute("aria-label", "Chapters");
  if (current > 0) nav.appendChild(link(links[current - 1], "chapter-nav-prev", "Previous"));
  if (current < links.length - 1) nav.appendChild(link(links[current + 1], "chapter-nav-next", "Next"));
  main.appendChild(nav);
});
