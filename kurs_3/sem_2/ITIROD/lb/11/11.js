function add() {
    var par = document.createElement("p");
    var node = document.createTextNode(document.getElementsByClassName('input')[0].value);
    var element = document.getElementsByClassName("js-add")[0];
    par.appendChild(node);
    element.appendChild(par);
}