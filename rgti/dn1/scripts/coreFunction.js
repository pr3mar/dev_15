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
var rotateCoord = false;
var enPerspective = false;
var perspectiveVal = 4;
var transformations = [
    0.0,    // rotate X         0
    0.0,    // rotate Y         1
    0.0,    // rotate Z         2
    100.0,  // scale X          3
    -100.0, // scale Y          4
    100.0,  // scale Z          5
    0.0,    // translate X      6
    0.0,    // translate Y      7
    0.0     // translate Z      8
];

function updatePerspectiveValue(value) {
    //console.log("perspective val = ", value);
    perspectiveVal = value;
    document.getElementById("perspval").innerHTML = "Perspective value: " + value;
    startWorking();
}

function updateRotate() {
    rotateCoord = !rotateCoord;
    if(rotateCoord) {
        document.getElementById("comments").innerHTML = "rotate model coordinate system";
    } else {
        document.getElementById("comments").innerHTML = "rotate in world's coordinate system (0,0,0)";
    }
    startWorking();
}

function updatePerspective() {
    enPerspective = !enPerspective;
    startWorking();
}

function zx(e){
    var charCode = e.which;
    //console.log(charCode);
    switch (charCode) {
        case 87: // w
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateX(6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[0] += 6;
            break;
        case 83: // s
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateX(-6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[0] -= 6;
            break;
        case 68: // d
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateY(-6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[1] -= 6;
            break;
        case 65: // a
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateY(6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[1] += 6;
            break;
        case 69: // e
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateZ(6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[2] += 6;
            break;
        case 81: // q
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, rotateZ(-6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[2] -= 6;
            break;
        case 38: // up arrow
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(0, -6, 0), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[7] -= 6;
            break;
        case 40: // down arrow
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(0, 6, 0), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[7] += 6;
            break;
        case 39: // right arrow
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(6, 0, 0), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[6] += 6;
            break;
        case 37: // left arrow
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(-6, 0, 0), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[6] -= 6;
            break;
        case 49: // 1 (over wasd)
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(0, 0, 6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[8] += 6;
            break;
        case 50: // 2 (over wasd)
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, translate(0, 0, -6), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[8] -= 6;
            break;
        case 107: // numpad +
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, scale(1.1, 1.1, 1.1), mvMatrix);
            //mat4.multiply(mvMatrix, mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[3] *= 1.1;transformations[4] *= 1.1;transformations[5] *= 1.1;
            break;
        case 109: // numpad -
            //mat4.multiply(mvMatrix, mvMatrix, translate(0, 0, 0));
            mat4.multiply(mvMatrix, scale(1/1.1, 1/1.1, 1/1.1), mvMatrix);
            //mat4.multiply(mvMatrix    , mvMatrix, translate(canvas.width/2, canvas.height/2, 0));
            transformations[3] *= 1/1.1;transformations[4] *= 1/1.1;transformations[5] *= 1/1.1;
            break;
        default:
            return;
    }
    draw();
}

document.onkeydown =  zx;

window.onload = function() {
    canvas = document.getElementById("drawingCanvas");
    canvas.width  = parseFloat(canvas.getAttribute("width"));
    canvas.height = parseFloat(canvas.getAttribute("height"));
    context = canvas.getContext("2d");
    document.getElementById("fileChooser").addEventListener("change", handleFiles, false);
};

function handleFiles(event) {
    var file = event.target.files[0];
    //if(file.type.match(/text.*/)) { // only .txt files
    var reader = new FileReader();
    reader.onloadend = function() {
        fileContent = reader.result;
        startWorking();
    };
    reader.readAsText(file);
    //}
}

function parse(fileContent) {
    //console.log(fileContent);
    var lines = fileContent.split("\n");
    lines.forEach(function (x) {
        if(x.length > 1)
            parseElements(x.split(" "));
    });
}

function parseElements(line) {
    var identifier = line.shift();
    switch(identifier) {
        case "v":
            vertices.push(castToGL(line, true));
            break;
        case "f":
            triangles.push(castToGL(line, false));
            break;
        default :
            //console.log("unknown element");
    }
}

function castToGL(array, vertex) {
    var tmpVector = vec4.create(), i = 0;
    array.forEach(function (x) {
        tmpVector[i] = parseFloat(x);
        i++;
    });
    tmpVector[3] = 1;
    if(vertex) {
        vec4.normalize(tmpVector, tmpVector);
        //console.log(tmpVector);
    }
    return tmpVector;
}

function startWorking() {
    mvMatrix = mat4.create();
    pMatrix = mat4.create();
    vertices = [];
    triangles = [];
    transformed = [];
    transformations = [0.0, 0.0, 0.0, 100.0, -100.0, 100.0, 0.0, 0.0, 0.0];
    parse(fileContent);
    mat4.multiply(mvMatrix, scale(100, -100, 100), mvMatrix); // set scaling
    //mat4.multiply(mvMatrix, scale(1, -1, 1), mvMatrix); // set scaling
    draw();
}

function draw() {
    if(vertices.length > 0 && triangles.length > 0) {
        context.clearRect(0, 0, canvas.width, canvas.height);
        var tmp = mat4.create();
        if(rotateCoord) {
            // ------------------ | rotate on model rotation point
            //console.log(transformations);
            mat4.multiply(tmp, scale(transformations[3], transformations[4], transformations[5]), tmp);
            mat4.multiply(tmp, rotateX(transformations[0]), tmp);
            mat4.multiply(tmp, rotateY(transformations[1]), tmp);
            mat4.multiply(tmp, rotateZ(transformations[2]), tmp);
            mat4.multiply(tmp, translate(transformations[6], transformations[7], transformations[8]), tmp);
            mat4.multiply(tmp, translate(0, 0, -8), tmp);
            if(enPerspective) { // prosim mi sporocite kje je napaka
                //console.log("[world] perspective enabled");
                mat4.multiply(tmp, perspective(perspectiveVal), tmp); // set perspective
            }

            mat4.multiply(tmp, translate(canvas.width / 2, canvas.height / 2, 0), tmp);

        } else {
            // ------------------ | rotate in world
            mat4.multiply(tmp, translate(0, 0, -8), mvMatrix); // set camera
            if(enPerspective) { // prosim mi sporocite kje je napaka
                //console.log("[world] perspective enabled");
                mat4.multiply(tmp, perspective(perspectiveVal), tmp); // set perspective
            }
            mat4.multiply(tmp, translate(canvas.width / 2, canvas.height / 2, 0), tmp);
        }
        vertices.forEach(function (x) {
            transformed.push(transform(tmp, x));
        });
        triangles.forEach(function(current){
            drawLine(current[0] - 1, current[1] - 1);
            drawLine(current[0] - 1, current[2] - 1);
            drawLine(current[1] - 1, current[2] - 1);
        });
        transformed = [];
    }
}

function drawLine(dot1, dot2) {
    context.beginPath();
    context.moveTo(transformed[dot1][0], transformed[dot1][1]);
    context.lineTo(transformed[dot2][0], transformed[dot2][1]);
    context.stroke();
}

function transform(matrix, vector) {
    //console.log(vector);
    var transformation = vec4.create();
    //console.log(matrix);
    vec4.transformMat4(transformation, vector, matrix);
    // normalize? how?
    console.log('before:', transformation);
    if(transformation[3] != 1 && transformation[3] != 0) {
        transformation[0] /= transformation[3];
        transformation[1] /= transformation[3];
        transformation[2] /= transformation[3];
        transformation[3] /= transformation[3];
    }
    console.log('after:', transformation);
    return transformation;
}

//<mat4> translate(<float> dx, <float> dy, <float> dz);
function translate(dx, dy, dz) {
    var translateMatrix = mat4.create();
    translateMatrix[3] = dx;
    translateMatrix[7] = dy;
    translateMatrix[11] = dz;
    //console.log(translateMatrix);
    mat4.transpose(translateMatrix, translateMatrix);
    return translateMatrix;
}
//<mat4> scale(<float> sx, <float> sy, <float> sz);
function scale(sx, sy, sz) {
    var scaleMatrix = mat4.create();
    scaleMatrix[0] = sx;
    scaleMatrix[5] = sy;
    scaleMatrix[10] = sz;
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
    mat4.transpose(rotateXMatrix, rotateXMatrix);
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
    mat4.transpose(rotateYMatrix, rotateYMatrix);
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
    mat4.transpose(rotateZMatrix, rotateZMatrix);
    return rotateZMatrix;
}
//<mat4> perspective(<float> d);
// primerna vrednost je d=4
function perspective(d){
    var perspectiveMatrix = mat4.create();
    perspectiveMatrix[15] = 0;
    perspectiveMatrix[14] = -1 / d;
    mat4.transpose(perspectiveMatrix, perspectiveMatrix);
    console.log("perspective: ", perspectiveMatrix);
    return perspectiveMatrix;
}
