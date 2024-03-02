const btnTestAll = document.querySelector('#btnTestAll');
if (window.Worker) {
    const myWorker = new Worker("workers.js");
    const startTest = (divId) => {
        const divItem = document.getElementById(divId);
        const postItem = {
            task: divId,
            host: divItem.querySelector('#' + divId + 'Host')?.value,
            port: divItem.querySelector('#' + divId + 'Port')?.value,
            user: divItem.querySelector('#' + divId + 'User')?.value,
            password: divItem.querySelector('#' + divId + 'Password')?.value,
            database: divItem.querySelector('#' + divId + 'Database')?.value
        };
        divItem.querySelector('.loader').classList.add('loading');
        myWorker.postMessage(["test.php", postItem]);
    };
    btnTestAll.onclick = function () {
        const loaders = Array.from(document.querySelectorAll('.loader'));
        loaders.forEach((el) => {
            el.classList.remove('loaded_success');
            el.classList.remove('loaded_error');
        });
        startTest('mysqlTest');
        startTest('postgresTest');
        startTest('redisTest');
    };
    myWorker.onmessage = function (e) {
        const divItem = document.getElementById(e.data.task);
        const loader = divItem.querySelector('.loader');
        divItem.querySelector('textarea').value = e.data.message;
        loader.classList.add(e.data.success ? 'loaded_success' : 'loaded_error');
        setTimeout(() => {
            loader.classList.remove('loading');
        }, 1300);
    };
} else {
    console.log("Your browser doesn't support web workers.");
}