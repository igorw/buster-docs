var buster = buster || {};

buster.byClass = function (className) {
    if (document.getElementsByClassName) {
        return document.getElementsByClassName(className);
    }

    var elements = document.getElementsByTagName("*"), results = [];
    var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");

    for (var i = 0, l = elements.length; i < l; ++i) {
        if (regexp.test(elements[i].className)) {
            results.push(elements[i]);
        }
    }

    return results;
};

function sectionTitle(section) {
    var attr = section.getAttribute("data-title");

    if (attr && /^\+/.test(attr) && /\+$/.test(attr)) {
        attr = "<code>" + attr.substring(1, attr.length - 1) + "</code>";
    }

    return attr || section.innerHTML;
}

buster.addHoverAnchor = function (element) {
    var hoverAnchor = document.createElement("a");
    hoverAnchor.innerHTML = "\u00B6";
    hoverAnchor.href = "#" + element.id;
    hoverAnchor.className = "pilcrow_anchor";
    element.appendChild(hoverAnchor);
}

function sectionNav(element, tagName, callback) {
    var elements = element.getElementsByTagName(tagName);
    var ul = document.createElement("ul"), li;

    for (var i = 0, l = elements.length; i < l; ++i) {
        li = document.createElement("li");
        li.innerHTML = "<a href=\"#" + elements[i].id + "\">" +
            sectionTitle(elements[i]) + "</a>";

        if (typeof callback == "function") {
            li.appendChild(callback(elements[i]));
        }

        buster.addHoverAnchor(elements[i]);
        ul.appendChild(li);
    }

    return ul;
}

(function () {
    // Initialize sidebar
    var aside = buster.byClass("aside")[0];
    var content = buster.byClass("content")[0];

    if (!aside || !content) {
        return;
    }

    var heading = document.createElement("h2");
    heading.innerHTML = document.getElementsByTagName("h1")[0].innerHTML;

    var ul = sectionNav(content, "h2", function (h2) {
        return sectionNav(h2.parentNode, "h3");
    });

    ul.className = "nav";
    // aside.appendChild(heading);
    // aside.appendChild(ul);
    aside.insertBefore(ul, aside.firstChild);
    aside.insertBefore(heading, aside.firstChild);

    // Highlight current selection, if any
    var highlighted;

    function highlight(el) {
        if (highlighted) {
            highlighted.className = "";
        }

        highlighted = el;

        if (highlighted) {
            highlighted.className = "highlight";
        }
    }

    highlight(document.getElementById(window.location.hash.substring(1)));

    ul.onclick = function (e) {
        e = e || window.event;
        var target = e.relatedTarget || e.toElement;

        if (!target) {
            return;
        }

        while (target && target.tagName.toLowerCase() != "a") {
            target = target.parentNode;
        }

        highlight(document.getElementById((target.href || "").split("#")[1] || ""));
    };
}());
