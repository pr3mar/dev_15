/**
 * Created by Power User on 22.10.2015.
 */
var fileContent = "[nan]";
var vertices = [];
var triangles = [];

function handleFiles(event) {
    var file = event.target.files[0];
    console.log(file);
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

function parseElements(line) {
    var identifier = line.shift();
    switch(line.shift()) {
        case "v":
            vertices.push(line);
            break;
        case "f":
            triangles.push(line);
            break;
        default :
            console.log("error");
    }
}

function parse(fileContent) {
    console.log("parsing");
    lines = fileContent.split("\n");
    lines.forEach(function (x) {
        if(x.length > 1)
            parseElements(x.split(" "));
    });
    result = fileContent;
    return result;
}

function startWorking() {
    console.log("started working!!!");
    result = parse(fileContent);
    console.log(vertices);
    console.log(triangles);
}