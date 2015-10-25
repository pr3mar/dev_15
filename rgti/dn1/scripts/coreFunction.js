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
    parse(fileContent);
    mvMatrix = mat4.create();
    //console.log(vertices);
    //console.log(triangles);
    for(var i = 0; i < vertices.length; i++) {
        console.log(vertices[i]);
        mvMatrix = scale(1/2, 1/2, 1/2);
        var tmp = transform(mvMatrix, vertices[i]);
        console.log(tmp);
        mvMatrix = translate(10, 10, 10);
        vertices[i] = transform(mvMatrix, vertices[i]);
        console.log(vertices[i]);
        console.log();
        mvMatrix = mat4.create();
    }
}

function parse(fileContent) {
    lines = fileContent.split("\n");
    lines.forEach(function (x) {
        if(x.length > 1)
            parseElements(x.split(" "));
    });
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

function transform(matrix, vector) {
    var transformation = vec4.create();
    for(var i = 0; i < vector.length; i++) {
        for(var j = 0; j < vector.length; j++) {
            transformation[i] += matrix[i * vector.length + j] * vector[j];
        }
    }
    return transformation;
}

//<mat4> translate(<float> dx, <float> dy, <float> dz);
function translate(dx, dy, dz) {
    var translateMatrix = mat4.create();
    translateMatrix[3] = dx;
    translateMatrix[7] = dy;
    translateMatrix[11] = dz;
    //console.log(translateMatrix);
    mat4.multiply(mvMatrix, mvMatrix, translateMatrix);
    return mvMatrix;
}
//<mat4> scale(<float> sx, <float> sy, <float> sz);
function scale(sx, sy, sz) {
    var scaleMatrix = mat4.create();
    scaleMatrix[0] = sx;
    scaleMatrix[5] = sy;
    scaleMatrix[10] = sz;
    mat4.multiply(mvMatrix, mvMatrix, scaleMatrix);
    return mvMatrix;
}
//<mat4> rotateX(<float> alpha);
function rotateX(alpha) {
    var rotateXMatrix = mat4.create();
    rotateXMatrix[5] = Math.cos(alpha);
    rotateXMatrix[6] = -Math.sin(alpha);
    rotateXMatrix[9] = Math.cos(alpha);
    rotateXMatrix[10] = Math.sin(alpha);
    mat4.multiply(mvMatrix, mvMatrix, rotateXMatrix);
    return mvMatrix;
}
//<mat4> rotateY(<float> alpha);
function rotateY(alpha) {
    var rotateYMatrix = mat4.create();
    rotateYMatrix[0] = Math.cos(alpha);
    rotateYMatrix[2] = Math.sin(alpha);
    rotateYMatrix[8] = -Math.sin(alpha);
    rotateYMatrix[10] = Math.cos(alpha);
    mat4.multiply(mvMatrix, mvMatrix, rotateYMatrix);
    return mvMatrix;
}
//<mat4> rotateZ(<float> alpha);
function rotateZ(alpha) {
    var rotateZMatrix = mat4.create();
    rotateZMatrix[0] = Math.cos(alpha);
    rotateZMatrix[1] = -Math.sin(alpha);
    rotateZMatrix[4] = Math.cos(alpha);
    rotateZMatrix[5] = Math.sin(alpha);
    mat4.multiply(mvMatrix, mvMatrix, rotateZMatrix);
    return mvMatrix;
}
//<mat4> perspective(<float> d); // primerna vrednost je d=4
function perspective(d){
    return mvMatrix;
}
