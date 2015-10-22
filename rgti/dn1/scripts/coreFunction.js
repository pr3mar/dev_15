/**
 * Created by Power User on 22.10.2015.
 */
var fileContent = "[nan]";

function handleFiles(event) {
    var file = event.target.files[0];
    console.log(file);
    if(file.type.match(/text.*/)) {
        var reader = new FileReader();
        reader.onloadend = function() {
            document.getElementById("fileDisplayArea").innerHTML = reader.result;
            fileContent = reader.result;
            startWorking();
        };
        reader.readAsText(file);
    }
}
window.onload = function() {
    document.getElementById("fileChooser").addEventListener("change", handleFiles, false);
};

function parse(fileContent) {
    console.log("parsing");
    lines = fileContent.split("\n");
    for(x in lines) {
        console.log(x, lines[x]);
    }
    result = fileContent;
    return result;
}

function startWorking() {
    console.log("started working!!!");
    result = parse(fileContent);
    console.log(result);
}