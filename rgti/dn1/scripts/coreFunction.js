/**
 * Created by Power User on 22.10.2015.
 */

var fileContent = "[nan]";
var vertices = [];
var triangles = [];

var mvMatrix;

function handleFiles(event) {
    var file = event.target.files[0];
    //console.log(file);
    if(file.type.match(/text.*/)) {
        var reader = new FileReader();
        reader.onloadend = function() {
            //document.getElementById("fileDisplayArea").innerHTML = reader.result;
            fileContent = reader.result;
            startWorking();
        };
        reader.readAsText(file);
    }
}
window.onload = function() {
    document.getElementById("fileChooser").addEventListener("change", handleFiles, false);
};

function startWorking() {
    result = parse(fileContent);
    console.log(vertices);
    console.log(triangles);
}

function parse(fileContent) {
    lines = fileContent.split("\n");
    lines.forEach(function (x) {
        if(x.length > 1)
            parseElements(x.split(" "));
    });
    result = fileContent;
    return result;
}

function parseElements(line) {
    var identifier = line.shift();
    switch(identifier) {
        case "v":
            vertices.push(castToGL(line));
            break;
        case "f":
            triangles.push(castToGL(line));
            break;
        default :
            console.log("error");
    }
}

function castToGL(array) {
    tmpVector = vec4.create();
    for(i in array){
        tmpVector[i] = parseFloat(array[i]);
    }
    tmpVector[3] = 1;
    return tmpVector;
}

//<mat4> rotateX(<float> alpha);
function rotateX(alpha) {
    return mvMatrix;
}
//<mat4> rotateY(<float> alpha);
function rotateY(alpha) {
    return mvMatrix;
}
//<mat4> rotateZ(<float> alpha);
function rotateZ(alpha) {
    return mvMatrix;
}
//<mat4> translate(<float> dx, <float> dy, <float> dz);
function translate(dx, dy, dz) {
    return mvMatrix;
}
//<mat4> scale(<float> sx, <float> sy, <float> sz);
function scale(sx, sy, sz) {
    return mvMatrix;
}
//<mat4> perspective(<float> d); // primerna vrednost je d=4
function perspective(d){
    return mvMatrix;
}
