onmessage = function (e) {
    const url = e.data[0];
    const postItems = e.data[1];
    const formData = new FormData();
    formData.append('task', postItems.task);
    formData.append('host', postItems.host);
    formData.append('port', postItems.port);
    formData.append('user', postItems.user);
    formData.append('password', postItems.password);
    formData.append('database', postItems.database);
    fetch(url, {
        body: formData,
        method: "post"
    }).then((
        (response) => response.json()
    )).then((json) => {
        json.url = json;
        postMessage(json);
    });
};