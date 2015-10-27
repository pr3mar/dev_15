/**
 * Created by Power User on 22.10.2015.
 */

var fileContent = "[nan]";
var vertices = [];
var transformed = [];
var triangles = [];

var mvMatrix = mat4.create();
var pMatrix = mat4.create();
var canvas;
var context;

function zx(e){
    var charCode = e.which;
    console.log(charCode);
    switch (charCode) {
        case 87:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateX(6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 83:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateX(-6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 68:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateY(6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 65:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateY(-6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 69:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateZ(6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 81:
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, rotateZ(-6));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 38: // up arrow
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(0, -6, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 40: // down arrow
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(0, 6, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 39: // right arrow
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(6, 0, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 37: // left arrow
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(-6, 0, 0));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 107: // numpad +
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, scale(1.1, 1.1, 1.1));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;
        case 109: // numpad -
            mat4.multiply(mvMatrix, mvMatrix, translate(-canvas.width/2, -canvas.height/2, 0));
            mat4.multiply(mvMatrix, mvMatrix, scale(1/1.1, 1/1.1, 1/1.1));
            mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            break;

        default:
            return;
    }
    draw();
}
document.onkeydown =  zx;

window.onload = function() {
    document.getElementById("fileChooser").addEventListener("change", handleFiles, false);
};

function handleFiles(event) {
    var file = event.target.files[0];
    //console.log(file);
    //if(file.type.match(/text.*/)) {
    var reader = new FileReader();
    reader.onloadend = function() {
        //document.getElementById("fileDisplayArea").innerHTML = reader.result;
        fileContent = reader.result;
        startWorking();
    };
    reader.readAsText(file);
    //}
}

function parse(fileContent) {
    //console.log(fileContent);
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
            //console.log("error");
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

function startWorking() {
    mvMatrix = mat4.create();
    vertices = [];
    triangles = [];
    transformed = [];
    parse(fileContent);
    pMatrix = perspective(-4);
    //mat4.multiply(pMatrix, pMatrix, translate(0, 1, 0));
    //mat4.multiply(pMatrix, pMatrix, scale(0.2, 1, 10));
    var tmp = mat4.create();
    canvas = document.getElementById("drawingCanvas");
    canvas.width  = 800;
    canvas.height = 600;
    context = canvas.getContext("2d");
    mat4.multiply(mvMatrix, mvMatrix, rotateZ(45));
    mat4.multiply(mvMatrix, mvMatrix, rotateX(45));
    //mat4.multiply(mvMatrix, mvMatrix, rotateY(45));
    mat4.multiply(mvMatrix, mvMatrix, scale(10, 10, 10));
    mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, -8));
    draw();
}

function draw() {
    if(vertices.length > 0 && triangles.length > 0) {
        //canvas.log("draw");
        //mat4.multiply(mvMatrix, mvMatrix, scale(100, 100, 100));
        //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, -8));
        //console.log(mvMatrix);
        context.clearRect(0, 0, canvas.width, canvas.height);
        for(var i = 0; i < vertices.length; i++) {
            //console.log(vertices[i]);
            transformed.push(transform(mvMatrix, vertices[i]));
            //console.log(vertices[i]);
        }
        for(var i = 0; i < triangles.length; i++) {
            var current = triangles[i];
            drawLine(current[0] - 1, current[1] - 1);
            drawLine(current[0] - 1, current[2] - 1);
            drawLine(current[1] - 1, current[2] - 1);
        }
        transformed = [];
        //mvMatrix = mat4.create();
    }
}

function drawLine(dot1, dot2) {
    context.beginPath();
    context.moveTo(transformed[dot1][0], transformed[dot1][1]);
    context.lineTo(transformed[dot2][0], transformed[dot2][1]);
    context.stroke();
}

function transform(matrix, vector) {
    var transformation = vec4.create();
    for(var i = 0; i < vector.length; i++) {
        for(var j = 0; j < vector.length; j++) {
            transformation[i] += matrix[i * vector.length + j] * vector[j];
        }
    }
    // not sure if correct (?)
    //if(transformation[transformation.length - 1] != 1) {
    //    for(var i = 0; i < transformation.length; i++) {
    //        transformation[i] /= transformation[transformation.length - 1];
    //    }
    //}
    return transformation;
}

//<mat4> translate(<float> dx, <float> dy, <float> dz);
function translate(dx, dy, dz) {
    var translateMatrix = mat4.create();
    translateMatrix[3] = dx;
    translateMatrix[7] = dy;
    translateMatrix[11] = dz;
    console.log(translateMatrix);
    //mat4.multiply(mvMatrix, mvMatrix, translateMatrix);
    return translateMatrix;
}
//<mat4> scale(<float> sx, <float> sy, <float> sz);
function scale(sx, sy, sz) {
    var scaleMatrix = mat4.create();
    scaleMatrix[0] = sx;
    scaleMatrix[5] = sy;
    scaleMatrix[10] = sz;
    //mat4.multiply(mvMatrix, mvMatrix, scaleMatrix);
    return scaleMatrix;
}

function deg2rad(alpha) {
    return alpha * Math.PI/180;
}

//<mat4> rotateX(<float> alpha);
function rotateX(alpha) {
    alpha = deg2rad(alpha);
    var rotateXMatrix = mat4.create();
    rotateXMatrix[5] = Math.cos(alpha);
    rotateXMatrix[6] = -Math.sin(alpha);
    rotateXMatrix[9] = Math.sin(alpha);
    rotateXMatrix[10] = Math.cos(alpha);
    //mat4.multiply(mvMatrix, mvMatrix, rotateXMatrix);
    return rotateXMatrix;
}
//<mat4> rotateY(<float> alpha);
function rotateY(alpha) {
    alpha = deg2rad(alpha);
    var rotateYMatrix = mat4.create();
    rotateYMatrix[0] = Math.cos(alpha);
    rotateYMatrix[2] = Math.sin(alpha);
    rotateYMatrix[8] = -Math.sin(alpha);
    rotateYMatrix[10] = Math.cos(alpha);
    //mat4.multiply(mvMatrix, mvMatrix, rotateYMatrix);
    return rotateYMatrix;
}
//<mat4> rotateZ(<float> alpha);
function rotateZ(alpha) {
    alpha = deg2rad(alpha);
    var rotateZMatrix = mat4.create();
    rotateZMatrix[0] = Math.cos(alpha);
    rotateZMatrix[1] = -Math.sin(alpha);
    rotateZMatrix[4] = Math.sin(alpha);
    rotateZMatrix[5] = Math.cos(alpha);
    //mat4.multiply(mvMatrix, mvMatrix, rotateZMatrix);
    return rotateZMatrix;
}
//<mat4> perspective(<float> d); // primerna vrednost je d=4
function perspective(d){
    var perspectiveMatrix = mat4.create();
    perspectiveMatrix[10] = 0;
    perspectiveMatrix[14] = 1/d;
    //mat4.multiply(mvMatrix, mvMatrix, perspectiveMatrix);
    return perspectiveMatrix;
}
