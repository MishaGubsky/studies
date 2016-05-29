var Fs = require("fs");
var JSFtp = require('./js/ftp');

function DateFormat(date) {
    var d = new Date(date);
    var n = d.toLocaleString();
    return n;
}

function createContent(data, path, Ftp) {
    $('.content tbody').empty();
    $('.div-content').show();

    if (path != '/')
        $('.content tbody').append('<tr disabled><td><a id="goBack">..</a></td><td></td><td></td></tr>');


    $('#error').append(path);

    data.forEach(function(file) {
        var styleClass = '';
        var row = '<tr><td><a ';
        if (file.type) {
            row += 'class="folder">' + file.name + '</a></td>' +
                '<td></td><td>' + DateFormat(file.time) + '</td></tr>';
        } else {
            row += 'class="file">' + file.name + '</a></td>' +
                '<td>' + file.size + '</td><td>' + DateFormat(file.time) + '</td></tr>';

        }
        $('.content tbody').append(row);
    });

    $('.content .folder').on('click', function(e) {
        $(this).parent().parent().addClass('selected');

        var filename = $(this).text();
        var newpath = path + filename + '/';
        displayContent(newpath, Ftp);
    });

    $('#goBack').on('click', function(e) {
        // $('#error').empty();

        newpath = getPrevFolderPath(path);
        displayContent(newpath, Ftp);
    });
}

function getPrevFolderPath(path) {
    return path.split('/').slice(0, -2).join('/') + '/' || '/';
}

function getFileName(path, symbol) {
    if (path[path.length - 1] != symbol)
        path += symbol;
    var filename = path.split(symbol);
    return filename[filename.length - 2];
}

function displayContent(path, Ftp) {
    console.log(path);

    Ftp.raw.cwd(path, function(err, res) {
        if (err) {

            $('#error').empty();
            alert(err.message);
            return;
        }
        Ftp.ls(path, function(err, res) {
            if (err) {

                $('#error').empty();
                alert(err.message);
                return;
            }
            $('#error').empty();
            createContent(res, path, Ftp);
        });
    });
}

function getCurrentDir(Ftp) {
    return new Promise((then, fail) => {
        Ftp.raw.pwd(function(err, data) {
            if (err) {
                $('#error').empty();
                alert(err);
                fail(err);
            }
            then(data.text.slice(5, -23));
        });
    });
}

function createFolder(path, Ftp) {
    name = prompt('New folder');
    if (name && name != 'null') {
        newpath = path + '/' + name + '/';
        Ftp.raw.mkd(newpath, function(err, data) {
            if (err) {
                $('#error').empty();
                alert(err);
            }
        });
        displayContent(path + '/', Ftp);
    } else {
        alert("name can't be null");
    }
}

function removeFolder(path, Ftp) {

    console.log('remove:');
    path = path[path.length - 1] == '/' ? path : path + '/';
    var file = $('#remoteTable tr.selected td a');
    var filepath = path + file.text();
    console.log(filepath);

    if (file.hasClass('folder')) {
        if (confirm('Are you sure to remove the folder ' + file.text())) {
            Ftp.raw.rmd(filepath, function(err, data) {
                if (err) {
                    $('#error').empty();
                    alert(err);
                }
            });
        }
        displayContent(path, Ftp);
    } else {
        if (confirm('Are you sure to remove the file ' + file.text())) {
            Ftp.raw.dele(filepath, function(err, data) {
                if (err) {
                    $('#error').empty();
                    alert(err);
                }
            });
        }

        displayContent(path, Ftp);
    }
}

function renameFolder(path, Ftp) {
    console.log('rename:');
    var file = $('#remoteTable tr.selected td a');
    var filename = file.text();
    if (file.hasClass('folder'))
        var name = prompt('rename folder "' + filename + '" to :');
    else
        var name = prompt('rename file "' + filename + '" to :');


    if (name && name != 'null') {

        path = path[path.length - 1] == '/' ? path : path + '/';
        var prevpath = path + filename;
        var newpath = path + name;
        Ftp.rename(prevpath, newpath, function(err, data) {
            if (err) {
                $('#error').empty();
                alert(err);
            }
        });

        displayContent(path, Ftp);
    } else {
        alert("name can't be null");
    }
}


function upload(remotePath, path, Ftp) {
    return new Promise((then, fail) => {

        var filename = getFileName(path, "\\");
        console.log('filename: ' + filename);

        var newPath = remotePath + '/' + filename;
        console.log('newpath: ' + newPath);

        var readStream = Fs.createReadStream(path);
        Ftp.put(readStream, newPath, function(hadError) {
            if (hadError)
                fail(err);
            else {
                then();
            }
        });
    });
}

function uploadFiles(remotePath, localPath, i, Ftp) {

    console.log('remote path: ' + remotePath);
    var path = localPath[i];

    remotePath = remotePath[remotePath.length - 1] == '/' ? remotePath : remotePath + '/';

    upload(remotePath, path, Ftp).then(() => {
            console.log(i);
            if (i < localPath.length - 1)
                uploadFiles(remotePath, localPath, i + 1, Ftp)
        }).then(() => {
            displayContent(remotePath, Ftp);
        })
        .catch(err => console.error(err));
}

function download(remotePath, localPath, Ftp) {
    return new Promise((then, fail) => {
        Ftp.get(remotePath, localPath, function(err) {
            if (err)
                fail(err);
            else
                then();
        });
    });
}

function downloadFiles(remoteDir, selectedFiles, localPath, i, Ftp) {

    var filename = selectedFiles[i].text;
    var remotePath = remoteDir + '/' + filename + '/';
    var newpath = localPath + '\\' + filename + '\\';
    console.log('remote path: ' + remotePath);
    console.log('local path: ' + newpath);

    download(remotePath, newpath, Ftp).then(() => {
            console.log(i);
            if (i < selectedFiles.length - 1)
                downloadFiles(remoteDir, selectedFiles, localPath, i + 1, Ftp);
        }).then(() => {
            $('#error').empty();
            alert('Files copied successfully!');
        })
        .catch(err => console.error(err));
}

function GetDirectory() {
    strFile = document.FileForm.filename.value;
    intPos = strFile.lastIndexOf("\\");
    strDirectory = strFile.substring(0, intPos);
    //alert(strDirectory);
    document.FileForm.Directory.value = strDirectory;
}

function prepareWindow(Ftp) {
    $(".buttons").show();
    $('table.content').show();

    $('#removeButton').attr('disabled', true);
    $('#renameButton').attr('disabled', true);

    $('#createButton').on('click', function() {
        getCurrentDir(Ftp)
            .then((path) => {
                console.log('current: ' + path);
                return path;
            })
            .then((path) => {
                createFolder(path, Ftp);
            })
            .catch(err => console.error(err));
    });

    $('#removeButton').on('click', function() {
        getCurrentDir(Ftp)
            .then((path) => {
                console.log('current: ' + path);
                return path;
            })
            .then((path) => {
                removeFolder(path, Ftp);
            })
            .catch(err => console.error(err));
    });

    $('#renameButton').on('click', function() {
        getCurrentDir(Ftp)
            .then((path) => {
                console.log('current: ' + path);
                return path;
            })
            .then((path) => {
                renameFolder(path, Ftp);
            })
            .catch(err => console.error(err));
    });

    $('#fileUpload').on('change', function() {
        var filePath = $(this).val();
        console.log("upload: " + filePath);
        getCurrentDir(Ftp)
            .then((path) => {
                console.log('current: ' + path);
                return path;
            })
            .then((path) => {
                $('#error').empty();
                alert('Wait please..');
                uploadFiles(path, filePath.split(';'), 0, Ftp);
            })
            .catch(err => console.error(err));
    });

    $('#fileDownload').on('change', function() {
        var filePath = $(this).val();
        console.log("download: " + filePath);
        getCurrentDir(Ftp)
            .then((path) => {
                console.log('current: ' + path);
                return path;
            })
            .then((path) => {
                $('#error').empty();
                alert('Wait please..');
                var files = $('#remoteTable tr.selected td a');
                downloadFiles(path, files, filePath, 0, Ftp);
            })
            .catch(err => console.error(err));
    });
}

function sortTable(column) {
    var theader = document.getElementById("theader");
    var oldOrder = theader.cells[column].dataset.order || '1';
    oldOrder = parseInt(oldOrder, 10)
    var newOrder = 0 - oldOrder;
    theader.cells[column].dataset.order = newOrder;

    var tbody = document.getElementById("tbody");
    var rows = tbody.rows;
    var list = [],
        i;
    for (i = 0; i < rows.length; i++) {
        list.push(rows[i]);
    }

    list.sort(function(row1, row2) {
        var a = row1.cells[column].dataset.value;
        var b = row2.cells[column].dataset.value;
        if (column) {
            a = parseInt(a, 10);
            b = parseInt(b, 10);
            return a > b ? newOrder : a < b ? oldOrder : 0;
        }

        // Column 0 is text.
        // Also the parent directory should always be sorted at one of the ends.
        if (b == ".." | a > b) {
            return newOrder;
        } else if (a == ".." | a < b) {
            return oldOrder;
        } else {
            return 0;
        }
    });
    // Appending an existing child again just moves it.
    for (i = 0; i < list.length; i++) {
        tbody.appendChild(list[i]);
    }
}


$(function() {
    // require('nw.gui').Window.get().showDevTools();
    $(".buttons").hide();
    $('.div-content').hide();
    $('table.content').hide();

    $('.connectionForm button').on('click', function(e) {
        if ($('.connectionForm button').text() != "Disconnect") {
            var Ftp = new JSFtp({
                host: $('#host').val() || "localhost",
                port: $('#post').val() || 21, // defaults to 21
                user: $('#user').val() || "anonymous", // defaults to "anonymous"
                pass: $('#pass').val() || "" // defaults to "@anonymous"
            });

            $('.connectionForm button').text("Disconnect");
            $('#error').empty();
            $('#error').append("Connection..");

            displayContent('/', Ftp);
            setTimeout(function() {
                if ($('#error').text() == "Connection..") {
                    $('.div-content').hide();

                    $('.content tbody').empty();
                    $('.content').hide();
                    $(".buttons").hide();
                    $('.connectionForm button').text("Connect");
                    $('#error').empty();
                    $('#error').append("Connection error!");
                    return
                }
            }, 9000);

            var interval = setInterval(function() {
                if ($('#error').text() != "Connection..") {
                    if ($('#error').text() != "Connection error!") {
                        if (Ftp.user && Ftp.user != 'anonymous') {
                            prepareWindow(Ftp);
                        } else {
                            $(".buttons").hide();
                        }
                    }
                    clearInterval(interval);
                }
            }, 300);

        } else {
            $('.div-content').hide();

            $('.content tbody').empty();
            $('.content').hide();
            $(".buttons").hide();
            $('.connectionForm button').text("Connect");
        }
    });

    $(window.document).on('click', '.content tbody tr', function(e) {
        if ($(this).hasClass('selected')) {
            $(this).removeClass('selected');
        } else {
            // if (!$(this).children().has('#goBack')) {
            $(this).addClass('selected');
            // }
        }

        if ($('#remoteTable tr.selected').length > 0) {
            $('#removeButton').attr('disabled', true);
            $('#renameButton').attr('disabled', true);
            $('#fileDownload').attr('disabled', false);

            if ($('#remoteTable tr.selected').length == 1) {
                $('#renameButton').attr('disabled', false);
                $('#removeButton').attr('disabled', false);
            }
        } else {
            $('#removeButton').attr('disabled', true);
            $('#renameButton').attr('disabled', true);
            $('#fileDownload').attr('disabled', true);
        }
    });
});
